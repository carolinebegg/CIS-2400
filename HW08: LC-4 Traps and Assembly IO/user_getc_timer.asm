;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : user_getc_timer.asm                      ;
;  author      : Caroline Begg                            ;
;  description : get a single character from the keyboard ;
;	                and time out if a character is not    ;
;                   enter afted a specified interval      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

CONST R0, xE8           ; R0 = 1000 ms (timer interval)
HICONST R0, x03

;; CONST R0, x88              ; R0 = 5000 ms (timer interval)
;; HICONST R0, x13

TRAP x05                ; TRAP_GETC_TIMER
END