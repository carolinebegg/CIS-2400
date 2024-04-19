;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : lfsr_sub.asm                           ;
;  author      : Caroline Begg                          ;
;  description : LC4 Assembly program for an LFSR       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CONST R4, x00            ; load low byte, R4 is pointer to the memory address x00
HICONST R4, x20          ; load high byte, R4 is pointer to the memory address x20
CONST R5, #87            ; R5 = 87 is the seed
CONST R6, xFF            ; load low byte, loop counter variable
HICONST R6, xFF          ; load high byte, loop counter variable
STR R5, R4, #0           ; store R5 = 21 at the address pointed to be R4 (x2000)

LOOP                     ; main loop
  CMPIU R6, #0           ; loop control (comparison)
  BRnz END_LOOP
  JSR LSF_SUB            ; subroutine call
  ADD R6, R6, #-1        ; loop control (decrement)
  JMP LOOP
  END_LOOP
  CMP R5, R0             ; seed comparison after full iteration loop

JMP END
.FALIGN
LSF_SUB
  LDR R0, R4, #0           ; load contents from R4 pointer (x2000) to R0
  SRL R2, R0, #15          ; 15th bit
  SRL R3, R0, #13          ; 13th bit
  XOR R2, R2, R3           ; XOR 15th and 13th -> R2 stores value of 15 XOR 13
  SRL R3, R0, #12          ; 12th bit
  XOR R2, R2, R3           ; XOR the result of (15 XOR 13) with 12 -> stored in R2
  SRL R3, R0, #10          ; 10th bit
  XOR R2, R2, R3           ; XOR the result of ((15 XOR 13) XOR 12) with 10 -> stored in R2
  SLL R0, R0, #1           ; logical left shift
  ADD R0, R0, R2           ; add 1 or 0
  STR R0, R4, #0           ; update x2000
  RET
END