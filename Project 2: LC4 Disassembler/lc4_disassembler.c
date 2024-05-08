
/************************************************************************/
/* File Name : lc4_disassembler.c 										*/
/* Purpose   : This file implements the reverse assembler 				*/
/*             for LC4 assembly.  It will be called by main()			*/
/*             															*/
/* Author(s) : tjf and you												*/
/************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lc4_hash.h"

#define INSN_OP(I) ((I) >> 12); // extract 4-bit opcode [15:12]
#define INSN_OP_SHORT(I) ((I) >> 13); // extract 3-bit opcode [15:13]

#define INSN_5_3(I) (((I) >> 3) & 0x7); // extract 3-bit sub-opcode for ARITH and LOGIC [5:3]
#define INSN_11_9(I) (((I) >> 9) & 0x7); // extract 3-bit sub-opcode for BR / d-register code [5:3]
#define INSN_8_6(I) (((I) >> 6) & 0x7); // extract 3-bit s-register code [8:6]
#define INSN_2_0(I) ((I) & 0x7); // extract 3-bit t-register code [2:0]
#define INSN_5(I) (((I) >> 5) & 0x1); // extract 6th bit [5]
#define INSN_4_0(I) ((I) & 0x1F); // extract 5-bit number IMM5 [4:0]

unsigned short int opcode = 0;
unsigned short int subop = 0;
unsigned short int imm_subop = 0;
short int IMM5 = 0;
char Rd = 0;
char Rs = 0;
char Rt = 0;

char* contents_to_string(row_of_memory* row) {
	opcode = INSN_OP(row->contents);
	subop = INSN_5_3(row->contents);
    imm_subop = INSN_5(row->contents);
    IMM5 = INSN_4_0(row->contents);
	Rd = INSN_11_9(row->contents);
  	Rs = INSN_8_6(row->contents);
  	Rt = INSN_2_0(row->contents);

    int length = strlen("ADD RX RX RX ");
    int length_IMM = strlen("XXX RX RX # ");
    int length_OR = strlen("OR RX RX RX ");
    int length_NOT = strlen("NOT RX RX ");

    if(opcode == 0x0001 && imm_subop == 0x1) {
		if (IMM5 >= 0 && IMM5 < 10) {
			row->assembly = malloc(length_IMM + 1);
			if (row->assembly == NULL) {
				return NULL;
			}
		} else {
			row->assembly = malloc(length_IMM + 2);
			if (row->assembly == NULL) {
				return NULL;
			}
		}
        sprintf(row->assembly, "ADD R%d R%d #%d", Rd, Rs, IMM5);
        return row->assembly;
    }
    if(opcode == 0x0005 && imm_subop == 0x1) {
		if (IMM5 >= 0 && IMM5 < 10) {
			row->assembly = malloc(length_IMM + 1);
			if (row->assembly == NULL) {
				return NULL;
			}
		} else {
			row->assembly = malloc(length_IMM + 2);
			if (row->assembly == NULL) {
				return NULL;
			}
		}
        sprintf(row->assembly, "AND R%d R%d #%d", Rd, Rs, IMM5);
        return row->assembly;
    }
	if (opcode == 5 && subop == 1) {
		row->assembly = malloc(length_NOT);
		if (row->assembly == NULL) {
			return NULL;
		}
		sprintf(row->assembly, "NOT R%d R%d", Rd, Rs);
        return row->assembly;
	}
	if (opcode == 5 && subop == 2) {
		row->assembly = malloc(length_NOT);
		if (row->assembly == NULL) {
			return NULL;
		}
		sprintf(row->assembly, "OR R%d R%d R%d", Rd, Rs, Rt);
        return row->assembly;
	}

	row->assembly = malloc(length);
	if (row->assembly == NULL) {
		return NULL;
	}
	if (opcode == 1) {
		switch(subop) {
			case 0:
				sprintf(row->assembly, "ADD R%d R%d R%d", Rd, Rs, Rt);
				return row->assembly;
			case 1:
				sprintf(row->assembly, "MUL R%d R%d R%d", Rd, Rs, Rt);
				return row->assembly;
			case 2:
				sprintf(row->assembly, "SUB R%d R%d R%d", Rd, Rs, Rt);
				return row->assembly;
			case 3:
				sprintf(row->assembly, "DIV R%d R%d R%d", Rd, Rs, Rt);
				return row->assembly;	
			}
	} else if (opcode == 5) {
		switch(subop) {
			case 0:
				if (sprintf(row->assembly, "AND R%d R%d R%d", Rd, Rs, Rt) == length) {
					return row->assembly;
				}
			case 3:
				if (sprintf(row->assembly, "XOR R%d R%d R%d", Rd, Rs, Rt) == length) {
					return row->assembly;
				}
		}
	}
	return NULL;
}

int reverse_assemble (lc4_memory_segmented* memory) {
	row_of_memory* user_program_memory = memory->buckets[0];
	row_of_memory* os_program_memory = memory->buckets[2];

	row_of_memory* curr = NULL;

	curr = search_opcode(user_program_memory, 1);
	while (curr != NULL) {
		contents_to_string(curr);
        curr = search_opcode(user_program_memory, 1);
	}

    curr = search_opcode(user_program_memory, 5);
	while (curr != NULL) {
		contents_to_string(curr);
        curr = search_opcode(user_program_memory, 5);
	}

	curr = search_opcode(os_program_memory, 1);
	while (curr != NULL) {
		contents_to_string(curr);
        curr = search_opcode(os_program_memory, 1);
	}

    curr = search_opcode(os_program_memory, 5);
	while (curr != NULL) {
		contents_to_string(curr);
        curr = search_opcode(os_program_memory, 5);
	}

	return 0 ;
}
