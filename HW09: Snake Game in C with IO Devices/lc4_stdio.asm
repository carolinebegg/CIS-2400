;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : lc4_stdio.asm                          ;
;  author      : Caroline Begg
;  description : LC4 Assembly subroutines that call     ;
;                call the TRAPs in os.asm (the wrappers);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; WRAPPER SUBROUTINES FOLLOW ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
.DATA
.ADDR x2000
data_memory
.ADDR x2002

.CODE
.ADDR x0010    ;; this code should be loaded after line 10
               ;; this is done to preserve "USER_START"
               ;; subroutine that calls "main()"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_RESET_VMEM Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_reset_vmem

    ;; STUDENTS - DON'T edit these wrappers - they must be here to get PennSim to work in double-buffer mode
    ;;          - DON'T use their prologue or epilogue's as models - use the slides!!

    ;; prologue
    ADD R6, R6, #-2
    STR R5, R6, #0
    STR R7, R6, #1
    ;; no arguments
    TRAP x06
    ;; epilogue
    LDR R5, R6, #0
    LDR R7, R6, #1
    ADD R6, R6, #2
RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_BLT_VMEM Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_blt_vmem

    ;; STUDENTS - DON'T edit these wrappers - they must be here to get PennSim to work in double-buffer mode
    ;;          - DON'T use their prologue or epilogue's as models - use the slides!!

    ;; prologue
    ADD R6, R6, #-2
    STR R5, R6, #0
    STR R7, R6, #1
    ;; no arguments
    TRAP x07
    ;; epilogue
    LDR R5, R6, #0
    LDR R7, R6, #1
    ADD R6, R6, #2
RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_PUTC Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_putc

;; PROLOGUE ;;
    STR R7, R6, #-2
    STR R5, R6, #-3
    ADD R6, R6, #-3
    ADD R5, R6, #0	

;; FUNCTION BODY ;;
    LDR R0, R6, #3	; R0 = R6 #3 (ASCII character to write to ASCII display)
    TRAP x01        ; call TRAP_PUTC (x01)

;; EPILOGUE ;; 
    ADD R6, R5, #0	;; pop locals off stack
    ADD R6, R6, #3	;; free space for return address and base pointer
            ; TRAP_PUTC has no return value, so nothing to copy back to stack
    LDR R5, R6, #-3	;; restore base pointer
    LDR R7, R6, #-2	;; restore return address
RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_GETC Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_getc

;; PROLOGUE ;;
    STR R7, R6, #-2
    STR R5, R6, #-3
    ADD R6, R6, #-3
    ADD R5, R6, #0
		
;; FUNCTION BODY ;;
                    ;; TRAP_GETC does not take any arguments
    TRAP x00        ;; call TRAP_GETC (x00)
    ADD R7, R0, #0  ;; copy ascii character from R0 back to the stack (R7 = R0)
	
;; EPILOGUE ;; 
    ADD R6, R5, #0 ; pop local variables
    ADD R6, R6, #3 ; decrease stack
    STR R7, R6, #-1 ; update return value
    LDR R5, R6, #-3 ; restore base ptr
    LDR R7, R6, #-2 ; restore R7 for RET
RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_PUTS Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_puts

;; PROLOGUE ;;
    STR R7, R6, #-2
    STR R5, R6, #-3
    ADD R6, R6, #-3
    ADD R5, R6, #0
		
;; FUNCTION BODY ;;
    LDR R0, R6, #3      ;; R0 = address of first character
    TRAP x03            ;; call TRAP_PUTS (x03)
	
;; EPILOGUE ;; 
    ADD R6, R5, #0	;; pop locals off stack
    ADD R6, R6, #3	;; free space for return address, base pointer, and return value
        ;; TRAP_PUTS has no return value, so nothing to copy back to stack
    LDR R5, R6, #-3	;; restore base pointer
    LDR R7, R6, #-2	;; restore return address
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_GETC_TIMER Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Inputs           - R0 = time to wait
;;; Outputs          - R0 = ASCII character from keyboard (or NULL)

.FALIGN
lc4_getc_timer

;; PROLOGUE ;;
    STR R7, R6, #-2
    STR R5, R6, #-3
    ADD R6, R6, #-3
    ADD R5, R6, #0
		
;; FUNCTION BODY ;;
    LDR R0, R5, #3          ;; R0 = timer value

    LEA R7, data_memory     ;; R7 = x2000
    STR R6, R7, #0          ;; x2000 = R6 (RA)
    STR R5, R7, #1          ;; x2001 = R5 (FP)

    TRAP x05                ;; call TRAP_GETC_TIMER (x05)

    LEA R7, data_memory     ;; R7 = x2000
    LDR R6, R7, #0          ;; R6 = RA
    LDR R5, R7, #1          ;; R5 = FP
    ADD R7, R0, #0          ;; R7 = R0 = ascii char (or null)

;; EPILOGUE ;; 
    ADD R6, R5, #0	;; pop locals off stack
    ADD R6, R6, #3	;; free space for return address and base pointer
    ;; STR R0, R6, #-1 ; update return value
    STR R7, R6, #-1 ; update return value
    LDR R5, R6, #-3	;; restore base pointer
    LDR R7, R6, #-2	;; restore return address
RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_DRAW_RECT Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Inputs    - R0 = x coord, R1 = y coord, R2 = length, R3 = width, R4 = color
;;; Outputs   - none (output is drawn on video display)

.FALIGN
lc4_draw_rect

;; PROLOGUE ;;
    STR R7, R6, #-2
    STR R5, R6, #-3
    ADD R6, R6, #-3
    ADD R5, R6, #0
		
;; FUNCTION BODY ;;
    LDR R0, R6, #3
    LDR R1, R6, #4
    LDR R2, R6, #5
    LDR R3, R6, #6
    LDR R4, R6, #7

    LEA R7, data_memory     ;; R7 = x2000
    STR R6, R7, #0          ;; x2000 = R6 (RA)
    STR R5, R7, #1          ;; x2001 = R5 (FP)

    TRAP x09                ;; call TRAP_DRAW_RECT (x09)

    LEA R7, data_memory     ;; R7 = x2000
    LDR R6, R7, #0          ;; R6 = RA
    LDR R5, R7, #1          ;; R5 = FP

;; EPILOGUE ;; 
    ADD R6, R5, #0	;; pop locals off stack
    ADD R6, R6, #3	;; free space for return address and base pointer
        ;; TRAP_DRAW_RECT has no return value, so nothing to copy back to stack
    LDR R5, R6, #-3	;; restore base pointer
    LDR R7, R6, #-2	;; restore return address
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_DRAW_SPRITE Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_draw_sprite

;; PROLOGUE ;;
        STR R7, R6, #-2
        STR R5, R6, #-3
        ADD R6, R6, #-3
        ADD R5, R6, #0
		
;; FUNCTION BODY ;;
        LDR R0, R6, #3
        LDR R1, R6, #4
        LDR R2, R6, #5
        LDR R3, R6, #6

        LEA R7, data_memory     ;; R7 = x2000
        STR R6, R7, #0          ;; x2000 = R6 (RA)
        STR R5, R7, #1          ;; x2001 = R5 (FP)

        TRAP x0A                ;; call TRAP_DRAW_SPRITE (xA0)

        LEA R7, data_memory     ;; R7 = x2000
        LDR R6, R7, #0          ;; R6 = RA
        LDR R5, R7, #1          ;; R5 = FP

;; EPILOGUE ;; 
        ADD R6, R5, #0	;; pop locals off stack
        ADD R6, R6, #3	;; free space for return address and base pointer
        LDR R5, R6, #-3	;; restore base pointer
        LDR R7, R6, #-2	;; restore return address
RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_LFSR_SET_SEED Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_lfsr_set_seed

;; PROLOGUE ;;
        STR R7, R6, #-2
        STR R5, R6, #-3
        ADD R6, R6, #-3
        ADD R5, R6, #0
		
;; FUNCTION BODY ;;
        ;; ADD R6, R6, #-1;
        ;; LDR R0, R5, #-1	

        LDR R0, R6, #3          ;; R0 = lfsr seed
        TRAP x0B                ;; call TRAP_LFSR_SET_SEED (x0B)

        ;;ADD R7, R0, #0

;; EPILOGUE ;; 
    ADD R6, R5, #0	;; pop locals off stack
    ADD R6, R6, #3	;; free space for return address and base pointer
        ;; TRAP_LFSR_SET_SEED has no return value, so nothing to copy back to stack
    LDR R5, R6, #-3	;; restore base pointer
    LDR R7, R6, #-2	;; restore return address
RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_LFSR Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_lfsr

;; PROLOGUE ;;
    STR R7, R6, #-2
    STR R5, R6, #-3
    ADD R6, R6, #-3
    ADD R5, R6, #0

;; FUNCTION BODY ;;
    LEA R7, data_memory     ;; R7 = x2000
    STR R6, R7, #0          ;; x2000 = R6 (RA)
    STR R5, R7, #1          ;; x2001 = R5 (FP)

    TRAP x0C                ;; call TRAP_LFSR (x0C)

    LEA R7, data_memory     ;; R7 = x2000
    LDR R6, R7, #0          ;; R6 = RA
    LDR R5, R7, #1          ;; R5 = FP

;; EPILOGUE ;; 
    ADD R6, R5, #0	;; pop locals off stack
    ADD R6, R6, #3	;; free space for return address and base pointer
    STR R0, R6, #-1 ; update return value
    LDR R5, R6, #-3	;; restore base pointer
    LDR R7, R6, #-2	;; restore return address
RET