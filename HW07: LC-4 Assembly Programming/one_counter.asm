;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : one_counter.asm                        ;
;  author      : Caroline Begg                          ;
;  description : LC4 Assembly program to compute the    ;
;                number of 1s in a given register       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;; pseudo-code of one_counter algorithm
;
; R0 = 1111;
; compare R0 with 1000
;   if (R0 >= 1000)
;     the first bit in R0 must be a 1
;     increment R1 by 1
;   logical left shift by 1 place on R0
;
; terminate loop when R0 = 0000

;;; TO-DO: implement one_counter program

LOOP                  ; main loop
  CMPI R0, #0         ; loop variable comparison, check if R0 is 0
  BRz END             ; branch to END if loop counter is 0

  CMPI R0, #0         ; loop variable comparison, check if R0 is negative (leading bit would be a 1)
  BRp NOT_A_ONE       ; branch to NOT_A_ONE if R0 is positive
  
  ADD R1, R1, #1      ; increment 1s counter (skipped if R0 is negative)

  NOT_A_ONE
  SLL R0, R0, #1      ; left logical shift 1 place

  JMP LOOP
END