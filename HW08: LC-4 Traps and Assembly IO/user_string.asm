;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : user_string.asm                            ;
;  author      : 
;  description : read characters from the keyboard,       ;
;	             then echo them back to the ASCII display ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

.DATA                       ; lines below are DATA memory
.ADDR x4000                 ; where to start in DATA memory

string                      ; label address x4000: string
  .FILL x49                     ; x4000 = "I"
  .FILL x20                     ; x4001 = " "
  .FILL x6C                     ; x4002 = "l"
  .FILL x6F                     ; x4003 = "o"
  .FILL x76                     ; x4004 = "v"
  .FILL x65                     ; x4005 = "e"
  .FILL x20                     ; x4006 = " "
  .FILL x43                     ; x4007 = "C"
  .FILL x49                     ; x4008 = "I"
  .FILL x53                     ; x4009 = "S"
  .FILL x00                     ; x4010 = null

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The following CODE will go into USER's Program Memory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.CODE
.ADDR x0000

LEA R0, string                  ; R0 = first address at string (x4000)
TRAP x03                        ; TRAP_PUTS call

END