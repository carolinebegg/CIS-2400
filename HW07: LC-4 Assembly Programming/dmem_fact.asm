;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : dmem_fact.asm                          ;
;  author      : Caroline Begg                          ;
;  description : LC4 Assembly program to populate rows  ;
;                of data in the data memory, compute    ;
;                the factorial of each number, and      ;
;                store the factorial back in the data   ;
;                memory by overwriting the original #   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.DATA                         ; lines below are DATA memory
.ADDR x4020                   ; where to start in DATA memory

global_array                  ; label address x4020: global array
  .FILL #6                    ; x4020 = 6
  .FILL #5                    ; x4021 = 5
  .FILL #8                    ; x4022 = 8
  .FILL #10                   ; x4023 = 10
  .FILL #-5                   ; x4024 = -5

.CODE                         ; lines below are PROGRAM memory
.ADDR x0000                   ; where to start in PROGRAM memory

INIT
  LEA R0, global_array        ; load starting address of data to R0
  CONST R2, #5                ; loop counter variable

FOR_LOOP                      ; loop for row iteration
  CMPI R2, #0
  BRnz END
  
  LDR R3, R0, #0              ; load data at R0 to R3
  LDR R1, R0, #0              ; load data at R0 to R1

  JSR SUB_FACTORIAL

  STR R1, R0, #0              ; store the data from R1 at the address pointed to by R0

  ADD R0, R0, #1              ; increment R0
  ADD R2, R2, #-1             ; decrement R2
  JMP FOR_LOOP

  JMP END                 ; skip over subroutine

  .FALIGN
  SUB_FACTORIAL

    CMPI R3, #0           ; check if A < 0
    BRnz INVALID
    CMPI R3, #8           ; check if A > 7
    BRzp INVALID

    LOOP_OUTER            ; label for outer loop
      CMPI R3, #1         ; sets NZP
      BRnz OUTER_END      ; test NZP

      ADD R3, R3, #-1     ; A = A - 1

      CONST R4, #0        ; sets C = 0
      LOOP_INNER          ; label for inner loop
        CMPI R1, #0       ; sets NZP
        BRnz END_INNER    ; test NZP
        ADD R4, R4, R3    ; C = C + A
        ADD R1, R1, #-1   ; B = B - 1
        BRnzp LOOP_INNER  ; send inner loop back to the beginning
        END_INNER         ; label for end of inner loop
        ADD R1, R4, 0     ; B = C
      BRnzp LOOP_OUTER    ; send outer loop back to the beginning
    JMP OUTER_END
    INVALID
      CONST R1, #-1       ; set B = -1 if A < 0 or A > 7
    OUTER_END
      RET                 ; end subroutine
END                       ; end program