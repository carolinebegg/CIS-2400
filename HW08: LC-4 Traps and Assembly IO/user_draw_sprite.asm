;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : user_draw_sprite.asm                     ;
;  author      : Caroline Begg                            ;
;  description : read characters from the keyboard,       ;
;	             then echo them back to the ASCII display ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
.DATA
.ADDR x4000
first_sprite
    .FILL #255
    .FILL #129
    .FILL #129
    .FILL #153
    .FILL #153
    .FILL #129
    .FILL #129
    .FILL #255

.ADDR x4020
second_sprite
    .FILL #65433
    .FILL #65433
    .FILL #65433
    .FILL #65433
    .FILL #65433
    .FILL #65433
    .FILL #65433
    .FILL #65433

.ADDR x4040
third_sprite
    .FILL #65535
    .FILL #65535
    .FILL #65535
    .FILL #65535
    .FILL #65535
    .FILL #65535
    .FILL #65535
    .FILL #65535

.CODE
.ADDR x0000
LEA R3, first_sprite                ; starting address of word array for first sprite
CONST R0, #20                       ; starting column
CONST R1, #20                       ; starting row
CONST R2, xE0                       ; color
HICONST R2, x03                     ; color
TRAP x0A                            ; TRAP_DRAW_SPRITE call

LEA R3, second_sprite               ; starting address of word array for second sprite
CONST R0, #40                       ; starting column
CONST R1, #40                       ; starting row
CONST R2, xE0                       ; color
HICONST R2, x03                     ; color
TRAP x0A                            ; TRAP_DRAW_SPRITE call

LEA R3, third_sprite                ; starting address of word array for third sprite
CONST R0, #120                      ; starting column
CONST R1, #120                      ; starting row
CONST R2, xE0                       ; color
HICONST R2, x03                     ; color
TRAP x0A                            ; TRAP_DRAW_SPRITE call

END