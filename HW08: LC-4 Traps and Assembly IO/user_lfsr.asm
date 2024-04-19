;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : user_lfsr.asm                            ;
;  author      : 
;  description : read characters from the keyboard,       ;
;	             then echo them back to the ASCII display ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

CONST R0, #21               ; R0 = 21 (seed)
TRAP x0B                    ; TRAP_LFSR_SET_SEED call
ADD R5, R0, #0              ; R5 = R0 (seed)

CONST R1, x00               ; load low byte, loop counter variable
HICONST R1, x00             ; load high byte, loop counter variable

LOOP                        ; main loop
  TRAP x0C                      ; TRAP_LFSR call
  ADD R1, R1, #1                ; loop control (increment)
  CMP R0, R5                    ; loop control (comparison)
  BRz END_LOOP                  ; go to end loop
  JMP LOOP                      ; restart loop
  END_LOOP                  ; end loop
END