;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : os.asm                                 ;
;  author      : 
;  description : LC4 Assembly program to serve as an OS ;
;                TRAPS will be implemented in this file ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;   OS - TRAP VECTOR TABLE   ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.OS
.CODE
.ADDR x8000
  ; TRAP vector table
  JMP TRAP_GETC           ; x00
  JMP TRAP_PUTC           ; x01
  JMP TRAP_GETS           ; x02
  JMP TRAP_PUTS           ; x03
  JMP TRAP_TIMER          ; x04
  JMP TRAP_GETC_TIMER     ; x05
  JMP TRAP_RESET_VMEM	  ; x06
  JMP TRAP_BLT_VMEM	      ; x07
  JMP TRAP_DRAW_PIXEL     ; x08
  JMP TRAP_DRAW_RECT      ; x09
  JMP TRAP_DRAW_SPRITE    ; x0A
  JMP TRAP_LFSR_SET_SEED  ; x0B
  JMP TRAP_LFSR           ; x0C

  ;
  ; TO DO - add additional vectors as described in homework 
  ;
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   OS - MEMORY ADDRESSES & CONSTANTS   ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; these handy alias' will be used in the TRAPs that follow
  USER_CODE_ADDR .UCONST x0000	; start of USER code
  OS_CODE_ADDR 	 .UCONST x8000	; start of OS code

  OS_GLOBALS_ADDR .UCONST xA000	; start of OS global mem
  OS_STACK_ADDR   .UCONST xBFFF	; start of OS stack mem

  OS_KBSR_ADDR .UCONST xFE00  	; alias for keyboard status reg
  OS_KBDR_ADDR .UCONST xFE02  	; alias for keyboard data reg

  OS_ADSR_ADDR .UCONST xFE04  	; alias for display status register
  OS_ADDR_ADDR .UCONST xFE06  	; alias for display data register

  OS_TSR_ADDR .UCONST xFE08 	; alias for timer status register
  OS_TIR_ADDR .UCONST xFE0A 	; alias for timer interval register

  OS_VDCR_ADDR	.UCONST xFE0C	; video display control register
  OS_MCR_ADDR	.UCONST xFFEE	; machine control register
  OS_VIDEO_NUM_COLS .UCONST #128
  OS_VIDEO_NUM_ROWS .UCONST #124


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; OS DATA MEMORY RESERVATIONS ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.DATA
.ADDR xA000
OS_GLOBALS_MEM	.BLKW x1000
;;;  LFSR value used by lfsr code
LFSR .FILL 0x0001

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; OS VIDEO MEMORY RESERVATION ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.DATA
.ADDR xC000
OS_VIDEO_MEM .BLKW x3E00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;   OS & TRAP IMPLEMENTATIONS BEGIN HERE   ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.CODE
.ADDR x8200
.FALIGN
  ;; first job of OS is to return PennSim to x0000 & downgrade privledge
  CONST R7, #0   ; R7 = 0
  RTI            ; PC = R7 ; PSR[15]=0


;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_GETC   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Get a single character from keyboard
;;; Inputs           - none
;;; Outputs          - R0 = ASCII character from ASCII keyboard

.CODE
TRAP_GETC
    LC R0, OS_KBSR_ADDR  ; R0 = address of keyboard status reg
    LDR R0, R0, #0       ; R0 = value of keyboard status reg
    BRzp TRAP_GETC       ; if R0[15]=1, data is waiting!
                             ; else, loop and check again...

    ; reaching here, means data is waiting in keyboard data reg

    LC R0, OS_KBDR_ADDR  ; R0 = address of keyboard data reg
    LDR R0, R0, #0       ; R0 = value of keyboard data reg
    RTI                  ; PC = R7 ; PSR[15]=0


;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_PUTC   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Put a single character out to ASCII display
;;; Inputs           - R0 = ASCII character to write to ASCII display
;;; Outputs          - none

.CODE
TRAP_PUTC
  LC R1, OS_ADSR_ADDR 	; R1 = address of display status reg
  LDR R1, R1, #0    	; R1 = value of display status reg
  BRzp TRAP_PUTC    	; if R1[15]=1, display is ready to write!
		    	    ; else, loop and check again...

  ; reaching here, means console is ready to display next char

  LC R1, OS_ADDR_ADDR 	; R1 = address of display data reg
  STR R0, R1, #0    	; R1 = value of keyboard data reg (R0)
  RTI			; PC = R7 ; PSR[15]=0


;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_GETS   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Get a string of characters from the ASCII keyboard
;;; Inputs           - R0 = Address to place characters from keyboard
;;; Outputs          - R1 = Lenght of the string without the NULL

.CODE
TRAP_GETS
  CONST R2, x00            ; load low byte, R2 is pointer to the memory address x00
  HICONST R2, x20          ; load high byte, R2 is pointer to the memory address x20

  CONST R3, xFF            ; load low byte, R3 is pointer to the memory address xFF
  HICONST R3, x7F          ; load high byte, R3 is pointer to the memory address x7F
  
  CMP R0, R2
    BRn END_TRAP_GETS
    
  CMP R0, R3
    BRp END_TRAP_GETS

  LOOP_TRAP_GETS
    WRITE_TRAP_GETS
        LC R4, OS_KBSR_ADDR  ; R0 = address of keyboard status reg
        LDR R4, R4, #0       ; R0 = value of keyboard status reg
        BRzp WRITE_TRAP_GETS       ; if R0[15]=1, data is waiting!
                             ; else, loop and check again...

    LC R4, OS_KBDR_ADDR  ; R0 = address of keyboard data reg
    LDR R4, R4, #0       ; R0 = value of keyboard data reg

    CMPI R4, x0A
      BRz END_TRAP_GETS

    STR R4, R0, #0    	; R1 = value of keyboard data reg (R0)

    ADD R0, R0, #1
    ADD R1, R1, #1
    ;; LDR R4, R0, #0
    JMP LOOP_TRAP_GETS

  END_TRAP_GETS
  RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_PUTS   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Put a string of characters out to ASCII display
;;; Inputs           - R0 = Address for first character
;;; Outputs          - none

.CODE
TRAP_PUTS
  CONST R2, x00            ; load low byte, R2 is pointer to the memory address x00
  HICONST R2, x20          ; load high byte, R2 is pointer to the memory address x20

  CONST R3, xFF            ; load low byte, R3 is pointer to the memory address xFF
  HICONST R3, x7F          ; load high byte, R3 is pointer to the memory address x7F

;; CHECK THAT R0 IS A VALID MEMORY ADDRESS
  CMP R0, R2
    BRn END_TRAP_PUTS
    
  CMP R0, R3
    BRp END_TRAP_PUTS

  LDR R4, R0, #0                ; load value at the address pointed to by R0 into R4
  
  LOOP_TRAP_PUTS
    CMPI R4, x0000                 ; check 
      BRz END_TRAP_PUTS

    WRITE_TRAP_PUTS
        LC R1, OS_ADSR_ADDR 	      ; R1 = address of display status reg
        LDR R1, R1, #0    	        ; R1 = value of display status reg
        BRzp WRITE_TRAP_PUTS    	  ; if R1[15]=1, display is ready to write!

    LC R1, OS_ADDR_ADDR 	      ; R1 = address of display data reg
    STR R4, R1, #0    	        ; store R4's value into the address at R1 (R1 = value of keyboard data reg (R0))
    ADD R0, R0, #1              ; increment the address at R0

    LDR R4, R0, #0              ; load value at the address pointed to by R0 into R4

  JMP LOOP_TRAP_PUTS
    
  END_TRAP_PUTS

  RTI


;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_TIMER   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function:
;;; Inputs           - R0 = time to wait in milliseconds
;;; Outputs          - none

.CODE
TRAP_TIMER
  LC R1, OS_TIR_ADDR 	; R1 = address of timer interval reg
  STR R0, R1, #0    	; Store R0 in timer interval register

COUNT
  LC R1, OS_TSR_ADDR  	; Save timer status register in R1
  LDR R1, R1, #0    	; Load the contents of TSR in R1
  BRzp COUNT    	; If R1[15]=1, timer has gone off!

  ; reaching this line means we've finished counting R0

  RTI       		; PC = R7 ; PSR[15]=0



;;;;;;;;;;;;;;;;;;;;;;;   TRAP_GETC_TIMER   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Get a single character from keyboard
;;; Inputs           - R0 = time to wait
;;; Outputs          - R0 = ASCII character from keyboard (or NULL)

.CODE
TRAP_GETC_TIMER

    LC R1, OS_TIR_ADDR 	; R1 = address of timer interval reg
    STR R0, R1, #0    	; Store R0 in timer interval register

  COUNT_GETC
  
    LC R2, OS_KBSR_ADDR  ; R0 = address of keyboard status reg
    LDR R2, R2, #0       ; R0 = value of keyboard status reg
    BRn PRESSED_GETC

    LC R1, OS_TSR_ADDR  	; Save timer status register in R1
    LDR R1, R1, #0    	; Load the contents of TSR in R1
    BRzp COUNT_GETC    	; If R1[15]=1, timer has gone off!

    ; reaching here, means data is waiting in keyboard data reg

    PRESSED_GETC
    LC R0, OS_KBDR_ADDR  ; R0 = address of keyboard data reg
    LDR R0, R0, #0       ; R0 = value of keyboard data reg
  RTI                  ; PC = R7 ; PSR[15]=0
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TRAP_RESET_VMEM ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; In double-buffered video mode, resets the video display
;;; DO NOT MODIFY this trap, it's for future HWs
;;; Inputs - none
;;; Outputs - none
.CODE	
TRAP_RESET_VMEM
  LC R4, OS_VDCR_ADDR
  CONST R5, #1
  STR R5, R4, #0
  RTI


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TRAP_BLT_VMEM ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TRAP_BLT_VMEM - In double-buffered video mode, copies the contents
;;; of video memory to the video display.
;;; DO NOT MODIFY this trap, it's for future HWs
;;; Inputs - none
;;; Outputs - none
.CODE
TRAP_BLT_VMEM
  LC R4, OS_VDCR_ADDR
  CONST R5, #2
  STR R5, R4, #0
  RTI


;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_DRAW_PIXEL   ;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Draw point on video display
;;; Inputs           - R0 = row to draw on (y)
;;;                  - R1 = column to draw on (x)
;;;                  - R2 = color to draw with
;;; Outputs          - none

.CODE
TRAP_DRAW_PIXEL
  LEA R3, OS_VIDEO_MEM       ; R3=start address of video memory
  LC  R4, OS_VIDEO_NUM_COLS  ; R4=number of columns

  CMPIU R1, #0    	         ; Checks if x coord from input is > 0
  BRn END_PIXEL
  CMPIU R1, #127    	     ; Checks if x coord from input is < 127
  BRp END_PIXEL
  CMPIU R0, #0    	         ; Checks if y coord from input is > 0
  BRn END_PIXEL
  CMPIU R0, #123    	     ; Checks if y coord from input is < 123
  BRp END_PIXEL

  MUL R4, R0, R4      	     ; R4= (row * NUM_COLS)
  ADD R4, R4, R1      	     ; R4= (row * NUM_COLS) + col
  ADD R4, R4, R3      	     ; Add the offset to the start of video memory
  STR R2, R4, #0      	     ; Fill in the pixel with color from user (R2)

END_PIXEL
  RTI       		         ; PC = R7 ; PSR[15]=0
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_DRAW_RECT   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Draw rectangle on video display
;;; Inputs    - R0 = x coord, R1 = y coord, R2 = length, R3 = width, R4 = color
;;; Outputs   - none (output is drawn on video display)

.CODE
TRAP_DRAW_RECT

  LEA R5, OS_VIDEO_MEM       ; R5=start address of video memory
  LC  R6, OS_VIDEO_NUM_COLS  ; R6=number of columns

;; CHECK UPPER RIGHT CORNER BOUNDARY
  CMPIU R0, #0    	          ; Checks if x coord from input is > 0
  BRn END_RECT
  CMPIU R0, #127    	        ; Checks if x coord from input is < 127
  BRp END_RECT
  CMPIU R1, #0    	          ; Checks if y coord from input is > 0
  BRn END_RECT
  CMPIU R1, #123    	        ; Checks if y coord from input is < 123
  BRp END_RECT

;; SET CORRECT STARTING POSITION 
  MUL R6, R1, R6      	     ; R6= (row * NUM_COLS)
  ADD R6, R6, R0      	     ; R6= (row * NUM_COLS) + col
  ADD R6, R6, R5      	     ; Add the offset to the start of video memory
  
;; CHECK RECTANGLE BOUNDARIES
  ADD R0, R0, R2             ; R0 = x coord + width
  CMPIU R0, #127    	       ; check if width drawn from x-coord of rectangle is outside the bounds < 127
  BRp END_RECT
  ADD R1, R1, R3             ; R1 = y coord + length
  CMPIU R1, #123    	       ; checks if length drawn from y coord from input is < 123
  BRp END_RECT

  ADD R0, R2, #0             ; R0 = width
  CONST R1, #128             ; R1 = 128

  OUTER_LOOP_RECT            ; outer loop label
    CMPIU R3, #0              ; check current length (outer loop control) 
    BRnz END_RECT             ; outer loop branch to exit
    
    INNER_LOOP_RECT           ; inner loop label
      CMPIU R2, #0              ; check current width (inner loop control)
      BRp DO_INNER              ; outer loop branch to execution
      
      INNER_TO_OUTER_RESET      ; resets values when moving from inner to outer loop
      ADD R3, R3, #-1               ; decrement length by 1
      SUB R6, R6, R0                ; R6 = R6 - width
      ADD R6, R6, R1                ; R6 = R6 + 128 
      ADD R2, R0, #0                ; R2 = width
      JMP OUTER_LOOP_RECT       ; return to outer loop

      DO_INNER                  ; inner loop execution label
      STR R4, R6, #0      	        ; fill in the pixel with color from user (R2)
      ADD R6, R6, #1                ; increment R6 (R6 = R6 + 1)
      ADD R2, R2, #-1               ; decrement R2 (R2 = R2 - 1)
    JMP INNER_LOOP_RECT         ; restart inner loop 
  END_RECT
  RTI       		         ; PC = R7 ; PSR[15]=0


;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_DRAW_SPRITE   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Draw point on video display
;;; Inputs: R0 = x coord, R1 = y coord, R2 = color of sprite, R3 = starting address of sprite data
;;; Outputs          - none

.CODE
TRAP_DRAW_SPRITE
  LEA R5, OS_VIDEO_MEM                ; R5=start address of video memory
  LC  R6, OS_VIDEO_NUM_COLS           ; R6=number of columns

  CMPIU R0, #0    	                  ; checks if x coord from input is > 0
  BRn END_SPRITE
  CMPIU R0, #127    	                ; checks if x coord from input is < 127
  BRp END_SPRITE
  CMPIU R1, #0    	                  ; checks if y coord from input is > 0
  BRn END_SPRITE
  CMPIU R1, #123    	                ; checks if y coord from input is < 123
  BRp END_SPRITE

  MUL R6, R1, R6      	              ; R6= (row * NUM_COLS)
  ADD R6, R6, R0      	              ; R6= (row * NUM_COLS) + col
  ADD R6, R6, R5      	              ; add the offset to the start of video memory
  
  ;;ADD R0, R0, #8                      ; R0 = x coord + width
  ;;CMPIU R0, #127    	                ; checks if length of rectangle is outside the bounds < 127
  ;;BRp END_SPRITE
  
  ;;ADD R1, R1, #8                      ; R1 = y coord + length
  ;;CMPIU R1, #123    	                ; checks if y coord from input is < 123
  ;;BRp END_SPRITE

  CONST R0, #8
  CONST R1, #8

  LEA R4, OS_GLOBALS_MEM              ; R4 = start address of additional variables
    STR R2, R4, #0                      ; store color in R4 #0

  OUTER_LOOP_SPRITE
    STR R0, R4, #1                    ; store outer loop counter in R4 #1
    CMPIU R0, #0                      ; outer loop control 
    BRnz END_SPRITE

    LDR R2, R3, #0                    ; R2 = word at R3
    SLL R2, R2, #8                    ; left logical shift R2 by 8 bits to get the 8 LSBs

    INNER_LOOP_SPRITE
      STR R1, R4, #4                  ; store inner loop counter in R4 #4
      CMPIU R1, #0                    ; R1 = inner loop counter
        BRnz INNER_TO_OUTER_SPRITE_RESET

      LDR R1, R4, #0                  ; R1 = color

      CONST R0, x00                   ; R0 = x8000
      HICONST R0, x80

      AND R0, R2, R0                  ; isolate MSB

      CMPIU R0, #0                    ; check if pixel is active (0 or 1)
        BRnz NON_ACTIVE_SPRITE
      STR R1, R6, #0      	          ; fill in the pixel with color from user (R1)

      NON_ACTIVE_SPRITE
        SLL R2, R2, #1                ; left logical shift R2 by 1
        ADD R6, R6, #1                ; increment R6 (R6 = R6 + 1)
        LDR R1, R4, #4                ; R1 = value of inner loop counter
        ADD R1, R1, #-1               ; decrement inner loop counter (R1 = R1 - 1)
      
    JMP INNER_LOOP_SPRITE

      INNER_TO_OUTER_SPRITE_RESET
        ADD R3, R3, #1                ; increment address at R3
        CONST R1, #128                ; R1 = 128
        ADD R6, R6, R1                ; R6 = R6 + 128
        ADD R6, R6, #-8               ; R6 = R6 - 8
        LDR R0, R4, #1                ; R0 = outer loop counter variable
        ADD R0, R0, #-1               ; decrement outer loop counter (R0 = R0 - 1)
        CONST R1, #8                  ; R1 = 8 (reset inner loop counter)
        JMP OUTER_LOOP_SPRITE
  END_SPRITE

  RTI


;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_LFSR_SET_SEED   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: save seed in R0 and store it in OS data memory location xA000
;;; Inputs    - R0 = seed
;;; Outputs   - none

.CODE
TRAP_LFSR_SET_SEED
    LEA R4, LFSR        ; load address of LFSR into R4
    STR R0, R4, #0      ; store seed (R0) at the address pointed to by R4
    RTI


;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_LFSR   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: generate a pseudo-random number from a seed from TRAP_LFSR_SET_SEED using the LFSR algorithm
;;; Inputs    - none
;;; Outputs   - R0 = pseudo-random number

.CODE
TRAP_LFSR
    LEA R4, LFSR             ; [UPDATE] load seed address into R4 from label LFSR
    LDR R0, R4, #0           ; load seed value from R4 (seed address)

    SRL R2, R0, #15          ; 15th bit
    AND R2, R2, #1           ; isolate LSB

    SRL R3, R0, #13          ; 13th bit
    AND R3, R3, #1           ; isolate LSB

    XOR R2, R2, R3           ; XOR 15th and 13th -> R2 stores value of 15 XOR 13

    SRL R3, R0, #12          ; 12th bit
    AND R3, R3, #1           ; isolate LSB

    XOR R2, R2, R3           ; XOR the result of (15 XOR 13) with 12 -> stored in R2

    SRL R3, R0, #10          ; 10th bit
    AND R3, R3, #1           ; isolate LSB

    XOR R2, R2, R3           ; XOR the result of ((15 XOR 13) XOR 12) with 10 -> stored in R2
    
    SLL R0, R0, #1           ; logical left shift
    ADD R0, R0, R2           ; add 1 or 0
    STR R0, R4, #0           ; update LFSR

  RTI