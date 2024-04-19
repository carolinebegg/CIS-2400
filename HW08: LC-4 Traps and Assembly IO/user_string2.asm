;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : user_string2.asm                         ;
;  author      : Caroline Begg                            ;
;  description : read string of characters from the       ;
;                   keyboard and calculate the length of  ;
;                   the string                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

.DATA
.ADDR x2020
input               ; input = x2020

.CODE
.ADDR x0000
LEA R0, input       ; R0 = first address at input (x2020)

TRAP x02            ; TRAP_GETS call

TEMPS .UCONST x4200         ; address of tempory storage
LC R7, TEMPS                ; load address into R7
STR R0, R7, #0              ; store R0 in R7[0]
STR R1, R7, #1              ; store R1 in R7[1]

CONST R0, x4C   ; ASCII code for "L"
TRAP x01        ; TRAP_PUTC call

CONST R0, x65   ; ASCII code for "e"
TRAP x01        ; TRAP_PUTC call

CONST R0, x6E   ; ASCII code for "n"
TRAP x01        ; TRAP_PUTC call

CONST R0, x67   ; ASCII code for "g"
TRAP x01        ; TRAP_PUTC call

CONST R0, x74   ; ASCII code for "t"
TRAP x01        ; TRAP_PUTC call

CONST R0, x68   ; ASCII code for "h:
TRAP x01        ; TRAP_PUTC call

CONST R0, x0A   ; ASCII code for space
TRAP x01        ; TRAP_PUTC call

CONST R0, x3D   ; ASCII code for "="
TRAP x01        ; TRAP_PUTC call

CONST R0, x0A   ; ASCII code for space
TRAP x01        ; TRAP_PUTC call

LC R7, TEMPS                ; load address into R7
LDR R0, R7, #1              ; load value at R7[1] into R0
LDR R1, R7, #1              ; load value at R7[1] into R1
CONST R5, #48               ; R5 = 48
ADD R0, R0, R5              ; R0 = R0 + 48 (convert decimal to ASCII)
TRAP x01                    ; TRAP_PUTC call

CONST R0, x0A   ; ASCII code for space
TRAP x01        ; TRAP_PUTC call

LC R7, TEMPS                ; load address into R7
LDR R0, R7, #0              ; load value at R7[0] into R0
LDR R1, R7, #1              ; load value at R7[1] into R1

LEA R0, input               ; load starting address of input (x2020) to R0
TRAP x03                    ; TRAP_PUTS call

LC R7, TEMPS                ; load address into R7
LDR R0, R7, #0              ; load value at R7[0] into R0
LDR R1, R7, #1              ; load value at R7[1] into R1

END