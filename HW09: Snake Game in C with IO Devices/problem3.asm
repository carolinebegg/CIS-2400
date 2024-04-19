		.DATA
L2_problem3 		.FILL #84
		.FILL #121
		.FILL #112
		.FILL #101
		.FILL #32
		.FILL #72
		.FILL #101
		.FILL #114
		.FILL #101
		.FILL #62
		.FILL #0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;main;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
main
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-12	;; allocate stack space for local variables
	;; function body
	ADD R1, R5, #-11
	LEA R0, L2_problem3
;ASGNB
	ADD R6, R6, #-1
	STR R2, R6, #0
	ADD R6, R6, #-1
	STR R3, R6, #0
;blkloop!!!!
	AND R3, R3, #0
	ADD R3, R3, #11
L8
	LDR R2, R0, #0
	STR R2, R1, #0
	ADD R0, R0, #1
	ADD R1, R1, #1
	ADD R3, R3, #-1
BRnp L8
	LDR R3, R6, #0
	ADD R6, R6, #1
	LDR R2, R6, #0
	ADD R6, R6, #1
	ADD R7, R5, #-11
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #1	;; free space for arguments
	JMP L4_problem3
L3_problem3
	JSR lc4_getc
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-12
	LDR R7, R5, #-12
	CONST R3, #10
	CMP R7, R3
	BRnp L6_problem3
	JMP L5_problem3
L6_problem3
	LDR R7, R5, #-12
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_putc
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #1	;; free space for arguments
L4_problem3
	JMP L3_problem3
L5_problem3
	CONST R7, #0
L1_problem3
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

