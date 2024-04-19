.DATA                         ; lines below are DATA memory
.ADDR x4020                   ; where to start in DATA memory
  .FILL #1                    ; x4020 = 1
  .FILL #2                    ; x4021 = 2

.CODE                         ; lines below are PROGRAM memory
.ADDR x0000                   ; where to start in PROGRAM memory

ADD R1, R0, R1
MUL R2, R1, R1
SUB R3, R2, R1
DIV R1, R3, R2
AND R1, R2, R3
OR R1, R3, R2
XOR R1, R3, R2
