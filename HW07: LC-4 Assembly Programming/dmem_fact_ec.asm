;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : dmem_fact_ec.asm                       ;
;  author      : Caroline Begg                          ;
;  description : LC4 Assembly program to populate rows  ;
;                of data in the data memory, compute    ;
;                the factorial of each number, and      ;
;                store the factorial back in the data   ;
;                memory by overwriting the original #   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


MAIN
  .DATA                         ; lines below are DATA memory
  .ADDR x4020                   ; where to start in DATA memory
  memory_address                ; label address x4020: memory address
    .FILL #5                    ; x4020 = 5
  .CODE                         ; lines below are PROGRAM memory
  .ADDR x0000                   ; where to start in PROGRAM memory 

  JSR SUB_FACTORIAL             ; subroutine call

JMP END                         ; skip over subroutine
.FALIGN                         ; align subroutine

SUB_FACTORIAL
  LEA R0, memory_address        ; load address of data at memory_address to R0
  LDR R1, R0, #0                ; load R1 with the data pointed to by R0
  LDR R2, R0, #0                ; load R1 with the data pointed to by R0

  CMPI R1, #0             ; check if A < 0
    BRnz INVALID
    CMPI R1, #8           ; check if A > 7
    BRzp INVALID
  LOOP_OUTER              ; label for outer loop
    CMPI R1, #1           ; sets NZP
    BRnz OUTER_END        ; test NZP
    ADD R1, R1, #-1       ; A = A - 1
    CONST R3, #0          ; sets C = 0
    LOOP_INNER            ; label for inner loop
      CMPI R2, #0         ; sets NZP
      BRnz END_INNER      ; test NZP
      ADD R3, R3, R1      ; C = C + A
      ADD R2, R2, #-1     ; B = B - 1
      BRnzp LOOP_INNER    ; send inner loop back to the beginning
    END_INNER             ; label for end of inner loop
    ADD R2, R3, 0         ; B = C
    BRnzp LOOP_OUTER      ; send outer loop back to the beginning
    JMP OUTER_END
    INVALID
      CONST R2, #-1       ; set B = -1 if A < 0 or A > 7
    OUTER_END
    STR R2, R0, #0        ; store the value of R2 at the address pointed to by R0
  RET                     ; end subroutine
END                       ; end program