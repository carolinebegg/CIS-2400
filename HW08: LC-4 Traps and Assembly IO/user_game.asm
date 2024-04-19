;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : user_game.asm                            ;
;  author      : Caroline Begg                            ;
;  description : game to test traps                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

.DATA
.ADDR x3010
done
    .STRINGZ "ALL DONE"           ; string for "ALL DONE"

.ADDR x4000
green_sprite                      ; values for X sprite
    .FILL #129
    .FILL #66
    .FILL #36
    .FILL #24
    .FILL #24
    .FILL #36
    .FILL #66
    .FILL #129

.CODE
.ADDR x0000

;; GREEN X SPRITE
LEA R3, green_sprite                ; starting address of word array for first sprite
CONST R0, #60                       ; starting column
CONST R1, #55                       ; starting row
CONST R2, xE0                       ; color
HICONST R2, x03                     ; color

TEMPS .UCONST x4200                 ; temporary storage
LC R7, TEMPS                        ; load address into R7
STR R0, R7, #0                      ; R0 = R7[0]
STR R1, R7, #1                      ; R1 = R7[1]
STR R2, R7, #2                      ; R2 = R7[2]
STR R3, R7, #3                      ; R3 = R7[3]
TRAP x0A                            ; TRAP_DRAW_SPRITE call

;; UPPER LEFT CORNER RECTANGLE
CONST R0, #0 ; x coordinate
CONST R1, #0, ; y coordinate
CONST R2, #25 ; length
CONST R3, #50 ; width
CONST R4, x9C ; color
HICONST R4, xF1 ; color
TRAP x09                            ; TRAP_DRAW_RECT call

;; UPPER RIGHT CORNER RECTANGLE
CONST R0, #75 ; x coordinate
CONST R1, #10 ; y coordinate
CONST R2, #50 ; length
CONST R3, #20 ; width
CONST R4, xE0 ; color
HICONST R4, x03 ; color
TRAP x09                            ; TRAP_DRAW_RECT call

;; LOWER LEFT CORNER RECTANGLE
CONST R0, #5  ; x coordinate
CONST R1, #80 ; y coordinate
CONST R2, #20 ; length
CONST R3, #40 ; width
CONST R4, xFF ; color
HICONST R4, x00 ; color
TRAP x09                            ; TRAP_DRAW_RECT call

;; LOWER RIGHT CORNER RECTANGLE
CONST R0, #90 ; x coordinate
CONST R1, #90 ; y coordinate
CONST R2, #25 ; length
CONST R3, #25 ; width
CONST R4, xCF ; color
HICONST R4, x89 ; color
TRAP x09                            ; TRAP_DRAW_RECT call

BEGIN_LOOP
    CONST R0, xA0           ; R0 = 4000 ms (4 second timer interval)
    HICONST R0, x0F
    TRAP x05                ; TRAP_GETC_TIMER call

    CMPI R0, x00            ; check if null
      BRz NULL

    CMPI R0, x0A            ; check if "enter" was pressed
      BRz ALL_DONE
      
    UP
    CONST R1, x69;
    CMP R0, R1             ; check if "i" was pressed
      BRnp DOWN
      LC R7, TEMPS         ; load in current values for R0, R1, R2, R3
      LDR R0, R7, #0       ; R0 = row
      LDR R1, R7, #1       ; R1 = length
      LDR R2, R7, #2       ; R2 = color
      LDR R3, R7, #3       ; R3 = address of sprite data
      ADD R1, R1, #-5      ; subtract 5 pixels
      STR R1, R7, #1       ; store new length
      TRAP x0A             ; TRAP_DRAW_SPRITE call
      JMP BEGIN_LOOP       ; return to beginning of loop

    DOWN
    CONST R1, x6B
    CMP R0, R1              ; check if "k" was pressed
      BRnp LEFT
      LC R7, TEMPS         ; load in current values for R0, R1, R2, R3
      LDR R0, R7, #0       ; R0 = row
      LDR R1, R7, #1       ; R1 = length
      LDR R2, R7, #2       ; R2 = color
      LDR R3, R7, #3       ; R3 = address of sprite data
      ADD R1, R1, #5       ; add 5 pixels
      STR R1, R7, #1       ; store new length
      TRAP x0A             ; TRAP_DRAW_SPRITE call
      JMP BEGIN_LOOP       ; return to beginning of loop
    
    LEFT
    CONST R1, x6A
    CMP R0, R1             ; check if "j" was pressed
      BRnp RIGHT          
      LC R7, TEMPS         ; load in current values for R0, R1, R2, R3
      LDR R0, R7, #0       ; R0 = row
      LDR R1, R7, #1       ; R1 = length
      LDR R2, R7, #2       ; R2 = color
      LDR R3, R7, #3       ; R3 = address of sprite data
      ADD R0, R0, #-5      ; subtract 5 pixels
      STR R0, R7, #0       ; store new width
      TRAP x0A             ; TRAP_DRAW_SPRITE call
      JMP BEGIN_LOOP       ; return to beginning of loop

    RIGHT
    CONST R1, x6C
    CMP R0, R1            ; check if "l" was pressed
      BRnp NULL
      LC R7, TEMPS         ; load in current values for R0, R1, R2, R3
      LDR R0, R7, #0       ; R0 = row
      LDR R1, R7, #1       ; R1 = length
      LDR R2, R7, #2       ; R2 = color
      LDR R3, R7, #3       ; R3 = address of sprite data
      ADD R0, R0, #5       ; add 5 pixels
      STR R0, R7, #0       ; store new width
      TRAP x0A             ; TRAP_DRAW_SPRITE call
      JMP BEGIN_LOOP       ; return to beginning of loop
    
  NULL
      ADD R0, R0, #3       ; seed
      TRAP x0B             ; TRAP_LFSR_SET_SEED call
      TRAP x0C             ; TRAP_LFSR call
      SLL R0, R0, #1       ; left logical shift
      SRL R0, R0, #1       ; right logical shift
      ADD R2, R0, #0       ; R2 = R0 (color is new pseudo-random number)
      LC R7, TEMPS         ; load in current values for R0, R1, R3
      LDR R0, R7, #0       ; R0 = row
      LDR R1, R7, #1       ; R1 = length
      STR R2, R7, #2       ; store new color
      LDR R3, R7, #3       ; R3 = address of sprite data
      TRAP x0A             ; TRAP_DRAW_SPRITE call

ALL_DONE
    LEA R0, done           ; load in STRINGZ data
    TRAP x03               ; TRAP_PUTS call
END