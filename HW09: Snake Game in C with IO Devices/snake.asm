		.DATA
timer 		.FILL #150
		.DATA
seed 		.FILL #111
;;;;;;;;;;;;;;;;;;;;;;;;;;;;printnum;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
printnum
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-13	;; allocate stack space for local variables
	;; function body
	LDR R7, R5, #3
	CONST R3, #0
	CMP R7, R3
	BRnp L2_snake
	LEA R7, L4_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	JMP L1_snake
L2_snake
	LDR R7, R5, #3
	CONST R3, #0
	CMP R7, R3
	BRzp L6_snake
	LDR R7, R5, #3
	NOT R7,R7
	ADD R7,R7,#1
	STR R7, R5, #-13
	JMP L7_snake
L6_snake
	LDR R7, R5, #3
	STR R7, R5, #-13
L7_snake
	LDR R7, R5, #-13
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #0
	CMP R7, R3
	BRzp L8_snake
	LEA R7, L10_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	JMP L1_snake
L8_snake
	ADD R7, R5, #-12
	ADD R7, R7, #10
	STR R7, R5, #-2
	LDR R7, R5, #-2
	ADD R7, R7, #-1
	STR R7, R5, #-2
	CONST R3, #0
	STR R3, R7, #0
	JMP L12_snake
L11_snake
	LDR R7, R5, #-2
	ADD R7, R7, #-1
	STR R7, R5, #-2
	LDR R3, R5, #-1
	CONST R2, #10
	MOD R3, R3, R2
	CONST R2, #48
	ADD R3, R3, R2
	STR R3, R7, #0
	LDR R7, R5, #-1
	CONST R3, #10
	DIV R7, R7, R3
	STR R7, R5, #-1
L12_snake
	LDR R7, R5, #-1
	CONST R3, #0
	CMP R7, R3
	BRnp L11_snake
	LDR R7, R5, #3
	CONST R3, #0
	CMP R7, R3
	BRzp L14_snake
	LDR R7, R5, #-2
	ADD R7, R7, #-1
	STR R7, R5, #-2
	CONST R3, #45
	STR R3, R7, #0
L14_snake
	LDR R7, R5, #-2
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
L1_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;endl;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
endl
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	;; function body
	LEA R7, L17_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
L16_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;rand16;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
rand16
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	LEA R7, seed
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_lfsr_set_seed
	ADD R6, R6, #1	;; free space for arguments
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #-1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_lfsr_set_seed
	ADD R6, R6, #1	;; free space for arguments
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #-1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_lfsr_set_seed
	ADD R6, R6, #1	;; free space for arguments
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #-1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_lfsr_set_seed
	ADD R6, R6, #1	;; free space for arguments
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #-1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_lfsr_set_seed
	ADD R6, R6, #1	;; free space for arguments
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #-1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_lfsr_set_seed
	ADD R6, R6, #1	;; free space for arguments
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #-1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_lfsr_set_seed
	ADD R6, R6, #1	;; free space for arguments
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #-1
	LEA R3, seed
	STR R7, R3, #0
	CONST R3, #127
	AND R7, R7, R3
L18_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

		.DATA
zero 		.FILL #255
		.FILL #195
		.FILL #195
		.FILL #195
		.FILL #195
		.FILL #195
		.FILL #195
		.FILL #255
		.DATA
one 		.FILL #24
		.FILL #24
		.FILL #24
		.FILL #24
		.FILL #24
		.FILL #24
		.FILL #24
		.FILL #24
		.DATA
two 		.FILL #255
		.FILL #255
		.FILL #7
		.FILL #255
		.FILL #255
		.FILL #224
		.FILL #255
		.FILL #255
		.DATA
three 		.FILL #255
		.FILL #255
		.FILL #7
		.FILL #255
		.FILL #255
		.FILL #7
		.FILL #255
		.FILL #255
		.DATA
four 		.FILL #195
		.FILL #195
		.FILL #195
		.FILL #255
		.FILL #3
		.FILL #3
		.FILL #3
		.FILL #3
		.DATA
five 		.FILL #255
		.FILL #255
		.FILL #224
		.FILL #255
		.FILL #255
		.FILL #7
		.FILL #255
		.FILL #255
		.DATA
six 		.FILL #255
		.FILL #255
		.FILL #193
		.FILL #192
		.FILL #255
		.FILL #193
		.FILL #193
		.FILL #255
		.DATA
seven 		.FILL #255
		.FILL #255
		.FILL #195
		.FILL #195
		.FILL #3
		.FILL #3
		.FILL #3
		.FILL #3
		.DATA
eight 		.FILL #255
		.FILL #195
		.FILL #195
		.FILL #255
		.FILL #255
		.FILL #195
		.FILL #195
		.FILL #255
		.DATA
nine 		.FILL #255
		.FILL #255
		.FILL #131
		.FILL #131
		.FILL #255
		.FILL #255
		.FILL #3
		.FILL #3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;init_snake;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
init_snake
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	CONST R7, #1
	STR R7, R5, #-1
L20_snake
	LDR R7, R5, #-1
	SLL R7, R7, #1
	LEA R3, snake
	ADD R7, R7, R3
	CONST R3, #-1
	STR R3, R7, #0
	LDR R7, R5, #-1
	SLL R7, R7, #1
	LEA R3, snake
	ADD R7, R7, R3
	CONST R3, #-1
	STR R3, R7, #1
L21_snake
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #25
	CMP R7, R3
	BRn L20_snake
	LEA R7, snake
	CONST R3, #10
	STR R3, R7, #0
	STR R3, R7, #1
	LEA R7, snake_length
	CONST R3, #1
	STR R3, R7, #0
	LEA R7, snake_direction
	CONST R3, #3
	STR R3, R7, #0
L19_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;reset_bombs;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
reset_bombs
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	CONST R7, #0
	STR R7, R5, #-1
L25_snake
	LDR R7, R5, #-1
	SLL R7, R7, #1
	LEA R3, bomb
	ADD R7, R7, R3
	CONST R3, #-1
	STR R3, R7, #0
	LDR R7, R5, #-1
	SLL R7, R7, #1
	LEA R3, bomb
	ADD R7, R7, R3
	CONST R3, #-1
	STR R3, R7, #1
L26_snake
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #5
	CMP R7, R3
	BRn L25_snake
	LEA R7, bombs_count
	CONST R3, #0
	STR R3, R7, #0
L24_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;turn_snake;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
turn_snake
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	;; function body
	LDR R7, R5, #3
	CONST R3, #1
	CMP R7, R3
	BRnp L30_snake
	LEA R7, snake_direction
	LDR R7, R7, #0
	CONST R3, #0
	CMP R7, R3
	BRz L30_snake
	LEA R7, snake_direction
	CONST R3, #1
	STR R3, R7, #0
	JMP L31_snake
L30_snake
	LDR R7, R5, #3
	CONST R3, #0
	CMP R7, R3
	BRnp L32_snake
	LEA R7, snake_direction
	LDR R7, R7, #0
	CONST R3, #1
	CMP R7, R3
	BRz L32_snake
	LEA R7, snake_direction
	CONST R3, #0
	STR R3, R7, #0
	JMP L33_snake
L32_snake
	LDR R7, R5, #3
	CONST R3, #2
	CMP R7, R3
	BRnp L34_snake
	LEA R7, snake_direction
	LDR R7, R7, #0
	CONST R3, #3
	CMP R7, R3
	BRz L34_snake
	LEA R7, snake_direction
	CONST R3, #2
	STR R3, R7, #0
	JMP L35_snake
L34_snake
	LDR R7, R5, #3
	CONST R3, #3
	CMP R7, R3
	BRnp L36_snake
	LEA R7, snake_direction
	LDR R7, R7, #0
	CONST R3, #2
	CMP R7, R3
	BRz L36_snake
	LEA R7, snake_direction
	CONST R3, #3
	STR R3, R7, #0
L36_snake
L35_snake
L33_snake
L31_snake
L29_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;grow_snake;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
grow_snake
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	;; function body
	LEA R7, snake_length
	LDR R7, R7, #0
	SLL R7, R7, #1
	LEA R3, snake
	ADD R2, R7, R3
	ADD R3, R3, #-2
	ADD R7, R7, R3
	LDR R7, R7, #0
	STR R7, R2, #0
	LEA R7, snake_length
	LDR R7, R7, #0
	SLL R7, R7, #1
	LEA R3, snake
	ADD R2, R7, R3
	ADD R3, R3, #-2
	ADD R7, R7, R3
	LDR R7, R7, #1
	STR R7, R2, #1
	LEA R7, snake_length
	LDR R3, R7, #0
	ADD R3, R3, #1
	STR R3, R7, #0
L38_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;move_snake;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
move_snake
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-5	;; allocate stack space for local variables
	;; function body
	LEA R7, snake
	LDR R7, R7, #0
	STR R7, R5, #-2
	LEA R7, snake
	LDR R7, R7, #1
	STR R7, R5, #-3
	LEA R7, snake_direction
	LDR R7, R7, #0
	CONST R3, #0
	CMP R7, R3
	BRnp L40_snake
	LDR R7, R5, #-2
	ADD R7, R7, #-1
	STR R7, R5, #-2
L40_snake
	LEA R7, snake_direction
	LDR R7, R7, #0
	CONST R3, #1
	CMP R7, R3
	BRnp L42_snake
	LDR R7, R5, #-2
	ADD R7, R7, #1
	STR R7, R5, #-2
L42_snake
	LEA R7, snake_direction
	LDR R7, R7, #0
	CONST R3, #3
	CMP R7, R3
	BRnp L44_snake
	LDR R7, R5, #-3
	ADD R7, R7, #1
	STR R7, R5, #-3
L44_snake
	LEA R7, snake_direction
	LDR R7, R7, #0
	CONST R3, #2
	CMP R7, R3
	BRnp L46_snake
	LDR R7, R5, #-3
	ADD R7, R7, #-1
	STR R7, R5, #-3
L46_snake
	LDR R7, R5, #-2
	STR R7, R5, #-4
	CONST R3, #0
	CMP R7, R3
	BRn L50_snake
	CONST R7, #15
	LDR R3, R5, #-4
	CMP R3, R7
	BRn L48_snake
L50_snake
	CONST R7, #0
	JMP L39_snake
L48_snake
	LDR R7, R5, #-3
	STR R7, R5, #-5
	CONST R3, #0
	CMP R7, R3
	BRn L53_snake
	CONST R7, #15
	LDR R3, R5, #-5
	CMP R3, R7
	BRn L51_snake
L53_snake
	CONST R7, #0
	JMP L39_snake
L51_snake
	LEA R7, snake_length
	LDR R7, R7, #0
	CONST R3, #1
	CMP R7, R3
	BRnz L54_snake
	LEA R7, snake_length
	LDR R7, R7, #0
	ADD R7, R7, #-1
	STR R7, R5, #-1
	JMP L59_snake
L56_snake
	LDR R7, R5, #-1
	SLL R7, R7, #1
	LEA R3, snake
	ADD R2, R7, R3
	ADD R3, R3, #-2
	ADD R7, R7, R3
	LDR R7, R7, #0
	STR R7, R2, #0
	LDR R7, R5, #-1
	SLL R7, R7, #1
	LEA R3, snake
	ADD R2, R7, R3
	ADD R3, R3, #-2
	ADD R7, R7, R3
	LDR R7, R7, #1
	STR R7, R2, #1
L57_snake
	LDR R7, R5, #-1
	ADD R7, R7, #-1
	STR R7, R5, #-1
L59_snake
	LDR R7, R5, #-1
	CONST R3, #0
	CMP R7, R3
	BRp L56_snake
L54_snake
	LEA R7, snake
	LDR R3, R5, #-2
	STR R3, R7, #0
	LDR R3, R5, #-3
	STR R3, R7, #1
	CONST R7, #1
L39_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;spawn_fruit;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
spawn_fruit
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-4	;; allocate stack space for local variables
	;; function body
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #14
	MOD R7, R7, R3
	STR R7, R5, #-2
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #14
	MOD R7, R7, R3
	STR R7, R5, #-3
	CONST R7, #0
	STR R7, R5, #-1
L61_snake
	LDR R7, R5, #-1
	SLL R7, R7, #1
	LEA R3, bomb
	ADD R7, R7, R3
	STR R7, R5, #-4
	LDR R3, R7, #0
	LDR R2, R5, #-2
	CMP R3, R2
	BRnp L65_snake
	LDR R7, R5, #-4
	LDR R7, R7, #1
	LDR R3, R5, #-3
	CMP R7, R3
	BRnp L65_snake
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #14
	MOD R7, R7, R3
	STR R7, R5, #-2
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #14
	MOD R7, R7, R3
	STR R7, R5, #-3
L65_snake
L62_snake
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #5
	CMP R7, R3
	BRn L61_snake
	LEA R7, fruit
	LDR R3, R5, #-2
	STR R3, R7, #0
	LDR R3, R5, #-3
	STR R3, R7, #1
L60_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;spawn_bomb;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
spawn_bomb
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-4	;; allocate stack space for local variables
	;; function body
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #14
	MOD R7, R7, R3
	STR R7, R5, #-2
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #14
	MOD R7, R7, R3
	STR R7, R5, #-3
	CONST R7, #0
	STR R7, R5, #-1
	JMP L71_snake
L68_snake
	LDR R7, R5, #-1
	SLL R7, R7, #1
	LEA R3, bomb
	ADD R7, R7, R3
	STR R7, R5, #-4
	LDR R3, R7, #0
	LDR R2, R5, #-2
	CMP R3, R2
	BRnp L72_snake
	LDR R7, R5, #-4
	LDR R7, R7, #1
	LDR R3, R5, #-3
	CMP R7, R3
	BRnp L72_snake
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #14
	MOD R7, R7, R3
	STR R7, R5, #-2
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #14
	MOD R7, R7, R3
	STR R7, R5, #-3
L72_snake
L69_snake
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
L71_snake
	LDR R7, R5, #-1
	LEA R3, bombs_count
	LDR R3, R3, #0
	CMP R7, R3
	BRn L68_snake
	LEA R7, fruit
	STR R7, R5, #-4
	LDR R3, R7, #0
	LDR R2, R5, #-2
	CMP R3, R2
	BRnp L74_snake
	LDR R7, R5, #-4
	LDR R7, R7, #1
	LDR R3, R5, #-3
	CMP R7, R3
	BRnp L74_snake
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #14
	MOD R7, R7, R3
	STR R7, R5, #-2
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #14
	MOD R7, R7, R3
	STR R7, R5, #-3
L74_snake
	LEA R7, bombs_count
	LDR R7, R7, #0
	SLL R7, R7, #1
	LEA R3, bomb
	ADD R7, R7, R3
	LDR R3, R5, #-2
	STR R3, R7, #0
	LEA R7, bombs_count
	LDR R7, R7, #0
	SLL R7, R7, #1
	LEA R3, bomb
	ADD R7, R7, R3
	LDR R3, R5, #-3
	STR R3, R7, #1
	LEA R7, bombs_count
	LDR R3, R7, #0
	ADD R3, R3, #1
	STR R3, R7, #0
L67_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;check_bomb_collision;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
check_bomb_collision
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-2	;; allocate stack space for local variables
	;; function body
	CONST R7, #0
	STR R7, R5, #-1
	JMP L80_snake
L77_snake
	LEA R7, snake
	STR R7, R5, #-2
	LDR R3, R5, #-1
	SLL R3, R3, #1
	LEA R2, bomb
	ADD R3, R3, R2
	LDR R2, R7, #0
	LDR R1, R3, #0
	CMP R2, R1
	BRnp L81_snake
	LDR R7, R5, #-2
	LDR R7, R7, #1
	LDR R3, R3, #1
	CMP R7, R3
	BRnp L81_snake
	CONST R7, #2
	JMP L76_snake
L81_snake
L78_snake
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
L80_snake
	LDR R7, R5, #-1
	LEA R3, bombs_count
	LDR R3, R3, #0
	CMP R7, R3
	BRn L77_snake
	CONST R7, #0
L76_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;check_fruit_collision;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
check_fruit_collision
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	LEA R7, snake
	STR R7, R5, #-1
	LEA R3, fruit
	LDR R2, R7, #0
	LDR R1, R3, #0
	CMP R2, R1
	BRnp L84_snake
	LDR R7, R5, #-1
	LDR R7, R7, #1
	LDR R3, R3, #1
	CMP R7, R3
	BRnp L84_snake
	CONST R7, #3
	JMP L83_snake
L84_snake
	CONST R7, #0
L83_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;check_self_collision;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
check_self_collision
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-2	;; allocate stack space for local variables
	;; function body
	CONST R7, #1
	STR R7, R5, #-1
	JMP L90_snake
L87_snake
	LEA R7, snake
	STR R7, R5, #-2
	LDR R3, R5, #-1
	SLL R3, R3, #1
	ADD R3, R3, R7
	LDR R2, R7, #0
	LDR R1, R3, #0
	CMP R2, R1
	BRnp L91_snake
	LDR R7, R5, #-2
	LDR R7, R7, #1
	LDR R3, R3, #1
	CMP R7, R3
	BRnp L91_snake
	CONST R7, #4
	JMP L86_snake
L91_snake
L88_snake
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
L90_snake
	LDR R7, R5, #-1
	LEA R3, snake_length
	LDR R3, R3, #0
	CMP R7, R3
	BRn L87_snake
	CONST R7, #0
L86_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;handle_collisions;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
handle_collisions
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-3	;; allocate stack space for local variables
	;; function body
	JSR check_fruit_collision
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-3
	JSR check_bomb_collision
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	JSR check_self_collision
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-2
	LDR R7, R5, #-1
	CONST R3, #0
	CMP R7, R3
	BRz L94_snake
	LDR R7, R5, #-1
	JMP L93_snake
L94_snake
	LDR R7, R5, #-2
	CONST R3, #0
	CMP R7, R3
	BRz L96_snake
	LDR R7, R5, #-2
	JMP L93_snake
L96_snake
	LDR R7, R5, #-3
L93_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;update_game_state;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
update_game_state
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-2	;; allocate stack space for local variables
	;; function body
	JSR move_snake
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-2
	JSR handle_collisions
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #-2
	CONST R3, #0
	CMP R7, R3
	BRnp L99_snake
	LEA R7, L101_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	CONST R7, #2
	JMP L98_snake
L99_snake
	LDR R7, R5, #-1
	CONST R3, #2
	CMP R7, R3
	BRnp L102_snake
	LEA R7, L104_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	CONST R7, #2
	JMP L98_snake
L102_snake
	LDR R7, R5, #-1
	CONST R3, #4
	CMP R7, R3
	BRnp L105_snake
	LEA R7, L107_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	CONST R7, #2
	JMP L98_snake
L105_snake
	LDR R7, R5, #-1
	CONST R3, #3
	CMP R7, R3
	BRnp L108_snake
	JSR spawn_fruit
	ADD R6, R6, #0	;; free space for arguments
	JSR grow_snake
	ADD R6, R6, #0	;; free space for arguments
	LEA R7, snake_length
	LDR R7, R7, #0
	CONST R3, #25
	CMP R7, R3
	BRnp L110_snake
	LEA R7, L112_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	CONST R7, #1
	JMP L98_snake
L110_snake
	LEA R7, snake_length
	LDR R7, R7, #0
	CONST R3, #5
	MOD R7, R7, R3
	CONST R3, #0
	CMP R7, R3
	BRnp L113_snake
	JSR spawn_bomb
	ADD R6, R6, #0	;; free space for arguments
	LEA R7, timer
	LDR R7, R7, #0
	CONST R3, #30
	SUB R7, R7, R3
	CONST R3, #35
	CMP R7, R3
	BRn L115_snake
	LEA R7, timer
	LDR R3, R7, #0
	CONST R2, #30
	SUB R3, R3, R2
	STR R3, R7, #0
L115_snake
	LEA R7, L117_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
L113_snake
L108_snake
	CONST R7, #0
L98_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;index_to_pixel;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
index_to_pixel
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	;; function body
	LDR R7, R5, #3
	SLL R7, R7, #3
L118_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;draw_pixel;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
draw_pixel
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-2	;; allocate stack space for local variables
	;; function body
	LDR R7, R5, #4
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR index_to_pixel
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #1	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #3
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR index_to_pixel
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #1	;; free space for arguments
	STR R7, R5, #-2
	LDR R7, R5, #5
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #8
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	LDR R7, R5, #-2
	ADD R6, R6, #-1
	STR R7, R6, #0
	LDR R7, R5, #-1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_rect
	ADD R6, R6, #5	;; free space for arguments
L119_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;draw_snake;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
draw_snake
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	CONST R7, #0
	STR R7, R5, #-1
	JMP L124_snake
L121_snake
	CONST R7, #0
	HICONST R7, #51
	ADD R6, R6, #-1
	STR R7, R6, #0
	LDR R7, R5, #-1
	SLL R7, R7, #1
	LEA R3, snake
	ADD R7, R7, R3
	LDR R3, R7, #1
	ADD R6, R6, #-1
	STR R3, R6, #0
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR draw_pixel
	ADD R6, R6, #3	;; free space for arguments
L122_snake
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
L124_snake
	LDR R7, R5, #-1
	LEA R3, snake_length
	LDR R3, R3, #0
	CMP R7, R3
	BRn L121_snake
L120_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;draw_bombs;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
draw_bombs
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	CONST R7, #0
	STR R7, R5, #-1
	JMP L129_snake
L126_snake
	CONST R7, #255
	HICONST R7, #255
	ADD R6, R6, #-1
	STR R7, R6, #0
	LDR R7, R5, #-1
	SLL R7, R7, #1
	LEA R3, bomb
	ADD R7, R7, R3
	LDR R3, R7, #1
	ADD R6, R6, #-1
	STR R3, R6, #0
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR draw_pixel
	ADD R6, R6, #3	;; free space for arguments
L127_snake
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
L129_snake
	LDR R7, R5, #-1
	LEA R3, bombs_count
	LDR R3, R3, #0
	CMP R7, R3
	BRn L126_snake
L125_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;draw_fruit;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
draw_fruit
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	;; function body
	CONST R7, #0
	HICONST R7, #124
	ADD R6, R6, #-1
	STR R7, R6, #0
	LEA R7, fruit
	LDR R3, R7, #1
	ADD R6, R6, #-1
	STR R3, R6, #0
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR draw_pixel
	ADD R6, R6, #3	;; free space for arguments
L130_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;display_score;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
display_score
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-7	;; allocate stack space for local variables
	;; function body
	CONST R7, #1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR index_to_pixel
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #1	;; free space for arguments
	STR R7, R5, #-6
	CONST R7, #2
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR index_to_pixel
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #1	;; free space for arguments
	STR R7, R5, #-7
	CONST R7, #1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR index_to_pixel
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #1	;; free space for arguments
	STR R7, R5, #-3
	LEA R7, snake_length
	LDR R7, R7, #0
	CONST R3, #10
	DIV R7, R7, R3
	STR R7, R5, #-4
	LEA R7, snake_length
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	STR R7, R5, #-2
	LEA R7, zero
	STR R7, R5, #-5
	LEA R7, zero
	STR R7, R5, #-1
	LDR R7, R5, #-4
	CONST R3, #2
	CMP R7, R3
	BRnp L132_snake
	LEA R7, two
	STR R7, R5, #-5
	JMP L133_snake
L132_snake
	LDR R7, R5, #-4
	CONST R3, #1
	CMP R7, R3
	BRnp L134_snake
	LEA R7, one
	STR R7, R5, #-5
L134_snake
L133_snake
	LDR R7, R5, #-2
	CONST R3, #9
	CMP R7, R3
	BRnp L136_snake
	LEA R7, nine
	STR R7, R5, #-1
	JMP L137_snake
L136_snake
	LDR R7, R5, #-2
	CONST R3, #8
	CMP R7, R3
	BRnp L138_snake
	LEA R7, eight
	STR R7, R5, #-1
	JMP L139_snake
L138_snake
	LDR R7, R5, #-2
	CONST R3, #7
	CMP R7, R3
	BRnp L140_snake
	LEA R7, seven
	STR R7, R5, #-1
	JMP L141_snake
L140_snake
	LDR R7, R5, #-2
	CONST R3, #6
	CMP R7, R3
	BRnp L142_snake
	LEA R7, six
	STR R7, R5, #-1
	JMP L143_snake
L142_snake
	LDR R7, R5, #-2
	CONST R3, #5
	CMP R7, R3
	BRnp L144_snake
	LEA R7, five
	STR R7, R5, #-1
	JMP L145_snake
L144_snake
	LDR R7, R5, #-2
	CONST R3, #4
	CMP R7, R3
	BRnp L146_snake
	LEA R7, four
	STR R7, R5, #-1
	JMP L147_snake
L146_snake
	LDR R7, R5, #-2
	CONST R3, #3
	CMP R7, R3
	BRnp L148_snake
	LEA R7, three
	STR R7, R5, #-1
	JMP L149_snake
L148_snake
	LDR R7, R5, #-2
	CONST R3, #2
	CMP R7, R3
	BRnp L150_snake
	LEA R7, two
	STR R7, R5, #-1
	JMP L151_snake
L150_snake
	LDR R7, R5, #-2
	CONST R3, #1
	CMP R7, R3
	BRnp L152_snake
	LEA R7, one
	STR R7, R5, #-1
L152_snake
L151_snake
L149_snake
L147_snake
L145_snake
L143_snake
L141_snake
L139_snake
L137_snake
	LEA R7, snake_length
	LDR R7, R7, #0
	CONST R3, #10
	CMP R7, R3
	BRzp L154_snake
	LDR R7, R5, #-1
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #240
	HICONST R7, #127
	ADD R6, R6, #-1
	STR R7, R6, #0
	LDR R7, R5, #-3
	ADD R6, R6, #-1
	STR R7, R6, #0
	LDR R7, R5, #-6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #4	;; free space for arguments
	JMP L155_snake
L154_snake
	LDR R7, R5, #-5
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #240
	HICONST R7, #127
	ADD R6, R6, #-1
	STR R7, R6, #0
	LDR R7, R5, #-3
	ADD R6, R6, #-1
	STR R7, R6, #0
	LDR R7, R5, #-6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #4	;; free space for arguments
	LDR R7, R5, #-1
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #240
	HICONST R7, #127
	ADD R6, R6, #-1
	STR R7, R6, #0
	LDR R7, R5, #-3
	ADD R6, R6, #-1
	STR R7, R6, #0
	LDR R7, R5, #-7
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #4	;; free space for arguments
L155_snake
L131_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;redraw;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
redraw
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	;; function body
	JSR lc4_reset_vmem
	ADD R6, R6, #0	;; free space for arguments
	JSR draw_snake
	ADD R6, R6, #0	;; free space for arguments
	JSR draw_bombs
	ADD R6, R6, #0	;; free space for arguments
	JSR draw_fruit
	ADD R6, R6, #0	;; free space for arguments
	JSR display_score
	ADD R6, R6, #0	;; free space for arguments
	JSR lc4_blt_vmem
	ADD R6, R6, #0	;; free space for arguments
L156_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;play_game;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
play_game
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-3	;; allocate stack space for local variables
	;; function body
	CONST R7, #0
	STR R7, R5, #-1
	LEA R7, timer
	CONST R3, #150
	STR R3, R7, #0
	LEA R7, seed
	CONST R3, #111
	STR R3, R7, #0
	JSR init_snake
	ADD R6, R6, #0	;; free space for arguments
	JSR reset_bombs
	ADD R6, R6, #0	;; free space for arguments
	JSR spawn_fruit
	ADD R6, R6, #0	;; free space for arguments
	JSR redraw
	ADD R6, R6, #0	;; free space for arguments
	JMP L159_snake
L158_snake
	LEA R7, timer
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_getc_timer
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #1	;; free space for arguments
	STR R7, R5, #-2
	LDR R7, R5, #-2
	CONST R3, #113
	CMP R7, R3
	BRnp L161_snake
	CONST R7, #2
	STR R7, R5, #-3
	LEA R7, L163_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	JMP L160_snake
L161_snake
	LDR R7, R5, #-2
	CONST R3, #105
	CMP R7, R3
	BRnp L164_snake
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR turn_snake
	ADD R6, R6, #1	;; free space for arguments
L164_snake
	LDR R7, R5, #-2
	CONST R3, #106
	CMP R7, R3
	BRnp L166_snake
	CONST R7, #2
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR turn_snake
	ADD R6, R6, #1	;; free space for arguments
L166_snake
	LDR R7, R5, #-2
	CONST R3, #107
	CMP R7, R3
	BRnp L168_snake
	CONST R7, #1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR turn_snake
	ADD R6, R6, #1	;; free space for arguments
L168_snake
	LDR R7, R5, #-2
	CONST R3, #108
	CMP R7, R3
	BRnp L170_snake
	CONST R7, #3
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR turn_snake
	ADD R6, R6, #1	;; free space for arguments
L170_snake
	JSR update_game_state
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	JSR redraw
	ADD R6, R6, #0	;; free space for arguments
L159_snake
	LDR R7, R5, #-1
	CONST R3, #0
	CMP R7, R3
	BRz L158_snake
L160_snake
L157_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;main;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
main
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	CONST R7, #0
	STR R7, R5, #-1
	LEA R7, L173_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	LEA R7, L174_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	JMP L176_snake
L175_snake
	CONST R7, #100
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_getc_timer
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #1	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #113
	CMP R7, R3
	BRnp L178_snake
	JMP L177_snake
L178_snake
	LDR R7, R5, #-1
	CONST R3, #114
	CMP R7, R3
	BRnp L180_snake
	LEA R7, L182_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	LEA R7, L183_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	LEA R7, L184_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	JSR play_game
	ADD R6, R6, #0	;; free space for arguments
	LEA R7, L185_snake
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
L180_snake
L176_snake
	JMP L175_snake
L177_snake
	CONST R7, #0
L172_snake
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

		.DATA
bombs_count 		.BLKW 1
		.DATA
fruit 		.BLKW 2
		.DATA
bomb 		.BLKW 10
		.DATA
snake_direction 		.BLKW 1
		.DATA
snake_length 		.BLKW 1
		.DATA
snake 		.BLKW 50
		.DATA
L185_snake 		.STRINGZ "Press 'r' to play again, or 'q' to quit...\n"
		.DATA
L184_snake 		.STRINGZ "Eat food (red) to grow, and avoid bombs (white)\n"
		.DATA
L183_snake 		.STRINGZ "Use i, j, k, l to move\n"
		.DATA
L182_snake 		.STRINGZ "\nNew game!\n"
		.DATA
L174_snake 		.STRINGZ "Press 'r' to start\n"
		.DATA
L173_snake 		.STRINGZ "Welcome to Snake!\n"
		.DATA
L163_snake 		.STRINGZ "\nGame quit. Better luck next time!\n"
		.DATA
L117_snake 		.STRINGZ "\nA new bomb has appeared. Be careful!\n"
		.DATA
L112_snake 		.STRINGZ "\nCongratulations! You have won the game!\n"
		.DATA
L107_snake 		.STRINGZ "\nGame Over: SNAKE Collision!\n"
		.DATA
L104_snake 		.STRINGZ "\nGame Over: BOMB Collision!\n"
		.DATA
L101_snake 		.STRINGZ "\nGame Over: Out of Bounds. Better luck next time!\n"
		.DATA
L17_snake 		.STRINGZ "\n"
		.DATA
L10_snake 		.STRINGZ "-32768"
		.DATA
L4_snake 		.STRINGZ "0"
