;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : factorial.asm                          ;
;  author      : Caroline Begg                          ;
;  description : LC4 Assembly program to compute the    ;
;                factorial of a number                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;; pseudo-code of factorial algorithm
;
; A = 5 ;  // example to do 5!
; B = A ;  // B=A! when while loop completes
;
; while (A > 1) {
; 	A = A - 1 ;
; 	B = B * A ;
; }
;

;;; TO-DO: Implement the factorial algorithm above using LC4 Assembly instructions

CONST R0, #5          ; sets A = 5
CONST R1, #5          ; sets B = 5

LOOP_OUTER            ; label for outer loop
  CMPI R0, #1         ; sets NZP
  BRnz END            ; test NZP
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
END                   ; end program