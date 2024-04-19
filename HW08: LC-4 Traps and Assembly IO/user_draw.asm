;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : user_draw.asm                            ;
;  author      : Caroline Begg                            ;
;  description : draw a rectangle in a specified position ;
;                    with specified length, width, color  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

;; TEST 1: RED BOX
CONST R0, #50                   ; x coordinate
CONST R1, #5,                   ; y coordinate
CONST R2, #10                   ; length
CONST R3, #5                    ; width
CONST R4, x00                   ; color
HICONST R4, x7C                 ; color
TRAP x09                        ; TRAP_DRAW_RECT call

;; TEST 2: GREEN BOX
CONST R0, #10                   ; x coordinate
CONST R1, #10                   ; y coordinate
CONST R2, #50                   ; length
CONST R3, #40                   ; width
CONST R4, xE0                   ; color
HICONST R4, x03                 ; color
TRAP x09                        ; TRAP_DRAW_RECT call

;;TEST 3: YELLOW BOX
CONST R0, #120                  ; x coordinate
CONST R1, #100                  ; y coordinate
CONST R2, #27                   ; length
CONST R3, #10                   ; width
CONST R4, xE0                   ; color
HICONST R4, x7F                 ; color
TRAP x09                        ; TRAP_DRAW_RECT call
                                    ;; should not draw becase rectangle is out of bounds
END