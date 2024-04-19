;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : factorial_sub.asm                      ;
;  author      : Caroline Begg
;  description : LC4 Assembly program to compute the    ;
;                factorial of a number using a          ;
;                subroutine                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;; TO-DO: Implement the factorial algorithm above as a subroutine using LC4 Assembly instructions

MAIN
  CONST R0, #6            ; R0 = A
  CONST R1, #6            ; R1 = B = A
  JSR SUB_FACTORIAL       ; call subroutine

  JMP END                 ; skip over subroutine
  .FALIGN                 ; align subroutine

  SUB_FACTORIAL
    CMPI R0, #0           ; check if A < 0
    BRnz INVALID
    CMPI R0, #8           ; check if A > 7
    BRzp INVALID

    LOOP_OUTER            ; label for outer loop
      CMPI R0, #1         ; sets NZP
      BRnz OUTER_END      ; test NZP

      ADD R0, R0, #-1     ; A = A - 1

      CONST R2, #0        ; sets C = 0
      LOOP_INNER          ; label for inner loop
        CMPI R1, #0       ; sets NZP
        BRnz END_INNER    ; test NZP
        ADD R2, R2, R0    ; C = C + A
        ADD R1, R1, #-1   ; B = B - 1
        BRnzp LOOP_INNER  ; send inner loop back to the beginning
        END_INNER         ; label for end of inner loop
        ADD R1, R2, 0     ; B = C
      BRnzp LOOP_OUTER    ; send outer loop back to the beginning
    INVALID
      CONST R1, #-1       ; set B = -1 if A < 0 or A > 7
    OUTER_END
      RET                 ; end subroutine
END                       ; end program