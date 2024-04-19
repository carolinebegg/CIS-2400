/***************************************************************************
 * file name   : assembler.c                                               *
 * author      : tjf & you                                                 *
 * description : This program will assemble a .ASM file into a .OBJ file   *
 *               This program will use the "asm_parser" library to achieve *
 *			     its functionality.										   * 
 *                                                                         *
 ***************************************************************************
 *
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "asm_parser.h"

int main(int argc, char** argv) {

	char* filename = NULL ;					// name of ASM file
	char  program [ROWS][COLS] ; 			// ASM file line-by-line
	char  program_bin_str [ROWS][17] ; 		// instructions converted to a binary string
	unsigned short int program_bin [ROWS] ; // instructions in binary (HEX)
  unsigned short int addresses[ROWS]; // EXTRA CREDIT: program memory addresses

/* 1. Initialize all arrays to zero */

for (int i = 0; i < ROWS; i++) {
  for (int j = 0; j < COLS; j++) {
    program[i][j] = '\0';
  }
}
for (int i = 0; i < ROWS; i++) {
  for (int j = 0; j < 17; j++) {
    program_bin_str[i][j] = '\0';
  }
}
for (int i = 0; i < ROWS; i++) {
  program_bin[i] = '\0';
}
for (int i = 0; i < ROWS; i++) {
  addresses[i] = '\0';
}

if (argc != 2) {
  fprintf(stderr, "error1: usage: %s <assembly_file.asm>\n", argv[0]);
  return 1;
} else {
  filename = argv[1];
  printf("\nThe input file is %s\n", filename);
}

/* 2. Call read_asm_file() */
read_asm_file (filename, program);

/* VISUAL FOR TESTING */

  printf("\n\n");
  for (int row = 0; row < 7; row++) {
    printf("Row %d: ", row); 
    for (int col = 0; col < 15; col++) {
      if (program[row][col] == '\0') {
        printf("N");
      }
      if (program[row][col] == '\n') {
        printf("NL");
      }
      printf("%c", program[row][col]);
    }
    printf("\n");
  }
  printf("\n\n");
/************/


/* Loop */
for (int row = 0; row < ROWS; row++) {
  parse_instruction(program[row], program_bin_str[row]);              // 3. Call parse_instruction()
  program_bin[row] = str_to_bin (program_bin_str[row]);               // 4. Call str_to_bin()
}

/* VISUAL FOR TESTING */

  printf("\n\n");
  for (int row = 0; row < 7; row++) {
    printf("Row %d: ", row); 
    for (int col = 0; col < 15; col++) {
      if (program_bin_str[row][col] == '\0') {
        printf("N");
      }
      if (program_bin_str[row][col] == '\n') {
        printf("NL");
      }
      printf("%c", program_bin_str[row][col]);
    }
    printf("\n");
  }
  printf("\n\n");

  printf("\n\n");
  for (int row = 0; row < 7; row++) {
    printf("Row %d: 0x%X\n", row, program_bin[row]);
  }
  printf("\n\n");
/************/

write_obj_file(filename, program_bin);

/*** Earlier Print Statements Used for Testing and Debugging ***/

  // printf("\n\n\n");
  // for (int row = 0; row < 25; row++) {
  //   for (int col = 0; col < 50; col++) {
  //     if (program[row][col] == '\0') {
  //       printf("N");
  //     }
  //     if (program[row][col] == '\n') {
  //       printf("NL");
  //     }
  //     printf("%c", program[row][col]);
  //   }
  //   printf("\n");
  // }
  // printf("\n\n\n");

  // for (int i = 0; i < 7; i++) {
  //   parse_instruction (program[i], program_bin_str[i]);
  //   printf("binary string text: %s\n", program_bin_str[i]);
  //   program_bin[i] = str_to_bin (program_bin_str[i]);
  //   printf("hex: “0x%x”)\n", program_bin[i]);
  // }
}
