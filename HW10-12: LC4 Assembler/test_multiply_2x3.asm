CONST R0, #2    ; A = 2
CONST R1, #3    ; B = 3
CONST R2, #0    ; C = 0
  
ADD R2, R2, R0  ; C = 0 + 2 = 2
ADD R1, R1, #-1 ; B = 3 - 1 = 2

ADD R2, R2, R0  ; C = 2 + 2 = 4
ADD R1, R1, #-1 ; B = 2 - 1 = 1

ADD R2, R2, R0  ; C = 4 + 2 = 6
ADD R1, R1, #-1 ; B = 1 - 1 = 0