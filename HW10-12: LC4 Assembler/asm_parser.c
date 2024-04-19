/***************************************************************************
 * file name   : asm_parser.c                                              *
 * author      : tjf & you                                                 *
 * description : the functions are declared in asm_parser.h                *
 *               The intention of this library is to parse a .ASM file     *
 *			        										               * 
 *                                                                         *
 ***************************************************************************
 *
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "asm_parser.h"

int read_asm_file (char* filename, char program [ROWS][COLS] ) {
  FILE* src_file;
  src_file = fopen(filename, "r");                           // open src file
  
  if (src_file == NULL) {                                   // throw an error if src_file is null
    fprintf(stderr, "error2: read_asm_file() failed\n");
    return 2;
  }
  // printf("The source file was opened correctly\n"); PRINT STATEMENT FOR TESTING + DEBUGGING
  
  for (int row = 0; row < ROWS; row++) {              // iterate through the rows of the ASM
    int comment = 0;                                // EXTRA CREDIT: comment indicator
    int data = 0;                                   // EXTRA CREDIT: data indicator
    int code = 0;                                   // EXTRA CREDIT: code indicator
    
    char* row_ptr = program[row];                   // row pointer 
    fgets(row_ptr, COLS, src_file);                   // read src values into program via row_ptr
    
    if (strcmp(row_ptr, ".CODE") == 0) {
      code = 1;
      data = 0;
    }
    if (strcmp(row_ptr, ".DATA") == 0) {
      data = 1;
      code = 0;
    }
    if (strcmp(row_ptr, ".ADDR") == 0) {
      unsigned short int addr = (unsigned short int) strtol(row_ptr, NULL, 16);
      if (code == 1) {
        //addresses[row] = addr;
      }
    }
    
    int length = strlen(row_ptr);                   // number of characters in the current row 

    if (length > 255) {                             // check the length
      fprintf(stderr, "error2: read_asm_file() failed\n");
      return 2;
    }
    
    // printf("\nRow %d: %d", row + 1, length); // PRINT STATEMENT FOR TESTING + DEBUGGING
    
    for (int col = 0; col < length; col++) {        // iterate through each character in each row
      if (program[row][col] == ';') {               // EXTRA CREDIT: check for semicolon
        comment = 1;                                // EXTRA CREDIT: set comment indicator to 1 (true)
      }
      if (program[row][col] == '\n') {              // check for carriage return 
        program[row][col] = '\0';                   // remove for carriage return 
        break;
      }
      if (comment == 1) {                           // EXTRA CREDIT: if comment dicator is 1 (true),
        program[row][col] = '\0';                   //         set all following characters to null 
      }
    }
  }
  fclose(src_file);                           // close src file
  return 0;
}

int parse_instruction (char* instr, char* instr_bin_str) {
  memset(instr_bin_str, 0, strlen(instr_bin_str));
  char* opcode = strtok(instr, " ");                                // get opcode with strtok by seperating by space
  if (opcode == NULL) {                                             // throw an error if opcode is null
    fprintf(stderr, "error3: parse_instruction() failed.\n");
    return 3;
  }
  int code = 0;
  int mode = 0;
  if (strcmp(opcode, "ADD") == 0) {                                 // check ADD
    // printf("\nOpcode: %s\n", opcode); PRINT STATEMENT FOR TESTING + DEBUGGING
    code = parse_add(instr, instr_bin_str);
  } else if (strcmp(opcode, "SUB") == 0) {                          // check SUB
    // printf("\nOpcode: %s\n", opcode); PRINT STATEMENT FOR TESTING + DEBUGGING
    code = parse_sub(instr, instr_bin_str);
  } else if (strcmp(opcode, "MUL") == 0) {                          // check MUL
    // printf("\nOpcode: %s\n", opcode); PRINT STATEMENT FOR TESTING + DEBUGGING
    code = parse_mul(instr, instr_bin_str);
  } else if (strcmp(opcode, "DIV") == 0) {                          // check DIV
    // printf("\nOpcode: %s\n", opcode); PRINT STATEMENT FOR TESTING + DEBUGGING
    code = parse_div(instr, instr_bin_str);
  } else if (strcmp(opcode, "AND") == 0) {                          // check AND
    // printf("\nOpcode: %s\n", opcode); PRINT STATEMENT FOR TESTING + DEBUGGING
    code = parse_and(instr, instr_bin_str);
  } else if (strcmp(opcode, "XOR") == 0) {                          // check XOR
    // printf("\nOpcode: %s\n", opcode); PRINT STATEMENT FOR TESTING + DEBUGGING
    code = parse_xor(instr, instr_bin_str);
  } else if (strcmp(opcode, "OR") == 0) {                           // check OR
    // printf("\nOpcode: %s\n", opcode); PRINT STATEMENT FOR TESTING + DEBUGGING
    code = parse_or(instr, instr_bin_str);
  } else if (strcmp(opcode, ".DATA") == 0) {                           // check DATA
    // printf("\nOpcode: %s\n", opcode); PRINT STATEMENT FOR TESTING + DEBUGGING
    mode = 0;
    code = parse_data(instr, instr_bin_str);
  } else if (strcmp(opcode, ".CODE") == 0) {                           // check CODE
    // printf("\nOpcode: %s\n", opcode); PRINT STATEMENT FOR TESTING + DEBUGGING
    mode = 1;
    code = parse_code(instr, instr_bin_str);
  } else if (strcmp(opcode, ".ADDR") == 0) {                           // check ADDR
    // printf("\nOpcode: %s\n", opcode); PRINT STATEMENT FOR TESTING + DEBUGGING
    code = parse_addr(instr, instr_bin_str, mode);
  }
  if (code == 4) {
    fprintf(stderr, "error3: parse_instruction() failed.\n");
    return 3;
  }
  strcat(instr_bin_str, "\0");
  return 0;
}

int parse_add (char* instr, char* instr_bin_str) {
  if (instr_bin_str == NULL){
    fprintf(stderr, "error4: parse_add() failed.\n");
    return 4;
  }
  if (instr == NULL){
    fprintf(stderr, "error4: parse_add() failed.\n");
    return 4;
  }
  strcat(instr_bin_str, "0001");                                      // denote arithmetic operator
  // printf("opcode (add): %s\n", instr_bin_str); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rd = strtok(NULL, ", ");                                      // register Rd
  // printf("rd: %s\n", rd); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rs = strtok(NULL, ", ");                                      // register Rs
  // printf("rs: %s\n", rs); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rt = strtok(NULL, ", ");                                      // register Rt
  // printf("rt: %s\n", rt); PRINT STATEMENT FOR TESTING + DEBUGGING

  if (rd[0] != 'R' || rs[0] != 'R' || rt[0] != 'R') {                               // check register format
    fprintf(stderr, "error4: parse_add() failed.\n");
    return 4;
  }

  parse_reg(rd[1], instr_bin_str);                                      // append Rd to instr_bin_str
  parse_reg(rs[1], instr_bin_str);                                      // append Rs to instr_bin_str
  strcat(instr_bin_str, "000");                                         // append ADD sub-opcode to instr_bin_str
  parse_reg(rt[1], instr_bin_str);                                      // append Rt to instr_bin_str

  return 0;

}
int parse_sub (char* instr, char* instr_bin_str ) {
  if (instr_bin_str == NULL){
    fprintf(stderr, "error4: parse_sub() failed.\n");
    return 4;
  }
  if (instr == NULL){
    fprintf(stderr, "error4: parse_sub() failed.\n");
    return 4;
  }
  strcat(instr_bin_str, "0001");                                      // denote arithmetic operator
  // printf("opcode (add): %s\n", instr_bin_str); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rd = strtok(NULL, ", ");                                      // register Rd
  // printf("rd: %s\n", rd); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rs = strtok(NULL, ", ");                                      // register Rs
  // printf("rs: %s\n", rs); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rt = strtok(NULL, ", ");                                      // register Rt
  // printf("rt: %s\n", rt); PRINT STATEMENT FOR TESTING + DEBUGGING

  if (rd[0] != 'R' || rs[0] != 'R' || rt[0] != 'R') {                               // check register format
    fprintf(stderr, "error4: parse_sub() failed.\n");
    return 4;
  }

  parse_reg(rd[1], instr_bin_str);                                      // append Rd to instr_bin_str
  parse_reg(rs[1], instr_bin_str);                                      // append Rs to instr_bin_str
  strcat(instr_bin_str, "010");                                         // append SUB sub-opcode to instr_bin_str
  parse_reg(rt[1], instr_bin_str);                                      // append Rt to instr_bin_str

  return 0;
  
}
int parse_mul (char* instr, char* instr_bin_str ) {
  if (instr_bin_str == NULL){
    fprintf(stderr, "error4: parse_mul() failed.\n");
    return 4;
  }
  if (instr == NULL){
    fprintf(stderr, "error4: parse_mul() failed.\n");
    return 4;
  }
  strcat(instr_bin_str, "0001");                                      // denote arithmetic operator
  // printf("opcode (add): %s\n", instr_bin_str); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rd = strtok(NULL, ", ");                                      // register Rd
  // printf("rd: %s\n", rd); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rs = strtok(NULL, ", ");                                      // register Rs
  // printf("rs: %s\n", rs); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rt = strtok(NULL, ", ");                                      // register Rt
  // printf("rt: %s\n", rt); PRINT STATEMENT FOR TESTING + DEBUGGING

  if (rd[0] != 'R' || rs[0] != 'R' || rt[0] != 'R') {                               // check register format
    fprintf(stderr, "error4: parse_mul() failed.\n");
    return 4;
  }

  parse_reg(rd[1], instr_bin_str);                                      // append Rd to instr_bin_str
  parse_reg(rs[1], instr_bin_str);                                      // append Rs to instr_bin_str
  strcat(instr_bin_str, "001");                                         // append MUL sub-opcode to instr_bin_str
  parse_reg(rt[1], instr_bin_str);                                      // append Rt to instr_bin_str

  return 0;
  
}
int parse_div (char* instr, char* instr_bin_str ) {
  if (instr_bin_str == NULL){
    fprintf(stderr, "error4: parse_div() failed.\n");
    return 4;
  }
  if (instr == NULL){
    fprintf(stderr, "error4: parse_div() failed.\n");
    return 4;
  }
  strcat(instr_bin_str, "0001");                                      // denote arithmetic operator
  // printf("opcode (add): %s\n", instr_bin_str); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rd = strtok(NULL, ", ");                                      // register Rd
  // printf("rd: %s\n", rd); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rs = strtok(NULL, ", ");                                      // register Rs
  // printf("rs: %s\n", rs); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rt = strtok(NULL, ", ");                                      // register Rt
  // printf("rt: %s\n", rt); PRINT STATEMENT FOR TESTING + DEBUGGING

  if (rd[0] != 'R' || rs[0] != 'R' || rt[0] != 'R') {                               // check register format
    fprintf(stderr, "error4: parse_div() failed.\n");
    return 4;
  }

  parse_reg(rd[1], instr_bin_str);                                      // append Rd to instr_bin_str
  parse_reg(rs[1], instr_bin_str);                                      // append Rs to instr_bin_str
  strcat(instr_bin_str, "011");                                         // append DIV sub-opcode to instr_bin_str
  parse_reg(rt[1], instr_bin_str);                                      // append Rt to instr_bin_str

  return 0;
  
}
int parse_and (char* instr, char* instr_bin_str ) {
  if (instr_bin_str == NULL){
    fprintf(stderr, "error4: parse_and() failed.\n");
    return 4;
  }
  if (instr == NULL){
    fprintf(stderr, "error4: parse_and() failed.\n");
    return 4;
  }
  strcat(instr_bin_str, "0101");                                      // denote logical operator
  // printf("opcode (add): %s\n", instr_bin_str); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rd = strtok(NULL, ", ");                                      // register Rd
  // printf("rd: %s\n", rd); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rs = strtok(NULL, ", ");                                      // register Rs
  // printf("rs: %s\n", rs); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rt = strtok(NULL, ", ");                                      // register Rt
  // printf("rt: %s\n", rt); PRINT STATEMENT FOR TESTING + DEBUGGING

  if (rd[0] != 'R' || rs[0] != 'R' || rt[0] != 'R') {                               // check register format
    fprintf(stderr, "error4: parse_and() failed.\n");
    return 4;
  }

  parse_reg(rd[1], instr_bin_str);                                      // append Rd to instr_bin_str
  parse_reg(rs[1], instr_bin_str);                                      // append Rs to instr_bin_str
  strcat(instr_bin_str, "000");                                         // append AND sub-opcode to instr_bin_str
  parse_reg(rt[1], instr_bin_str);                                      // append Rt to instr_bin_str

  return 0;
  
}
int parse_xor (char* instr, char* instr_bin_str ) {
  if (instr_bin_str == NULL){
    fprintf(stderr, "error4: parse_xor() failed.\n");
    return 4;
  }
  if (instr == NULL){
    fprintf(stderr, "error4: parse_xor() failed.\n");
    return 4;
  }
  strcat(instr_bin_str, "0101");                                      // denote logical operator
  // printf("opcode (add): %s\n", instr_bin_str); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rd = strtok(NULL, ", ");                                      // register Rd
  // printf("rd: %s\n", rd); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rs = strtok(NULL, ", ");                                      // register Rs
  // printf("rs: %s\n", rs); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rt = strtok(NULL, ", ");                                      // register Rt
  // printf("rt: %s\n", rt); PRINT STATEMENT FOR TESTING + DEBUGGING

  if (rd[0] != 'R' || rs[0] != 'R' || rt[0] != 'R') {                               // check register format
    fprintf(stderr, "error4: parse_xor() failed.\n");
    return 4;
  }

  parse_reg(rd[1], instr_bin_str);                                      // append Rd to instr_bin_str
  parse_reg(rs[1], instr_bin_str);                                      // append Rs to instr_bin_str
  strcat(instr_bin_str, "011");                                         // append XOR sub-opcode to instr_bin_str
  parse_reg(rt[1], instr_bin_str);                                      // append Rt to instr_bin_str

  return 0;
  
}
int parse_or (char* instr, char* instr_bin_str ) {
  if (instr_bin_str == NULL){
    fprintf(stderr, "error4: parse_or() failed.\n");
    return 4;
  }
  if (instr == NULL){
    fprintf(stderr, "error4: parse_or() failed.\n");
    return 4;
  }
  strcat(instr_bin_str, "0101");                                      // denote logical operator
  // printf("opcode (add): %s\n", instr_bin_str); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rd = strtok(NULL, ", ");                                      // register Rd
  // printf("rd: %s\n", rd); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rs = strtok(NULL, ", ");                                      // register Rs
  // printf("rs: %s\n", rs); PRINT STATEMENT FOR TESTING + DEBUGGING
  char* rt = strtok(NULL, ", ");                                      // register Rt
  // printf("rt: %s\n", rt); PRINT STATEMENT FOR TESTING + DEBUGGING

  if (rd[0] != 'R' || rs[0] != 'R' || rt[0] != 'R') {                               // check register format
    fprintf(stderr, "error4: parse_or() failed.\n");
    return 4;
  }

  parse_reg(rd[1], instr_bin_str);                                      // append Rd to instr_bin_str
  parse_reg(rs[1], instr_bin_str);                                      // append Rs to instr_bin_str
  strcat(instr_bin_str, "010");                                         // append OR sub-opcode to instr_bin_str
  parse_reg(rt[1], instr_bin_str);                                      // append Rt to instr_bin_str

  return 0;

}
int parse_data (char* instr, char* instr_bin_str) {
  if (instr_bin_str == NULL){
    fprintf(stderr, "error4: parse_data() failed.\n");
    return 4;
  }
  if (instr == NULL){
    fprintf(stderr, "error4: parse_data() failed.\n");
    return 4;
  }
  strcat(instr_bin_str, "1101101011011010");                                      // DATA binary
  return 0;
}
int parse_code (char* instr, char* instr_bin_str) {
  if (instr_bin_str == NULL){
    fprintf(stderr, "error4: parse_code() failed.\n");
    return 4;
  }
  if (instr == NULL){
    fprintf(stderr, "error4: parse_code() failed.\n");
    return 4;
  }
  strcat(instr_bin_str, "1100101011011110");                                      // CODE binary
  return 0;
}
int parse_addr (char* instr, char* instr_bin_str, int mode) {
  if (instr_bin_str == NULL) {
    fprintf(stderr, "error4: parse_addr() failed.\n");
    return 4;
  }
  if (instr == NULL){
    fprintf(stderr, "error4: parse_addr() failed.\n");
    return 4;
  }
  char* addr = strtok(NULL, " ");    
  if (mode == 1) {
    strtol(addr, NULL, 16);
  }
  if (mode != 0 || mode != 1) {
    fprintf(stderr, "error4: parse_addr() failed.\n");
    return 4;
  }
  return 0;
}
int parse_reg (char reg_num, char* instr_bin_str){      // swap statement for parsing registers
  switch(reg_num) {
    case '0':
      strcat(instr_bin_str, "000");
      break;
    case '1':
      strcat(instr_bin_str, "001");
      break;
    case '2':
      strcat(instr_bin_str, "010");
      break;
    case '3':
      strcat(instr_bin_str, "011");
      break;
    case '4':
      strcat(instr_bin_str, "100");
      break;
    case '5':
      strcat(instr_bin_str, "101");
      break;
    case '6':
      strcat(instr_bin_str, "110");
      break;
    case '7':
      strcat(instr_bin_str, "111");
      break;
    default:
      fprintf(stderr, "error5: parse_reg() failed.\n");
      return 5;
  }
  return 0;
}

unsigned short int str_to_bin (char* instr_bin_str) {       // string to binary method
  unsigned short int bin;
  bin = (short) strtol(instr_bin_str, NULL, 2);             // get binary (base-2) number from string
  return bin;
}
int write_obj_file (char* filename, unsigned short int program_bin[ROWS] ) {
  if (program_bin == NULL) {                                   // throw an error if src_file is null
    fprintf(stderr, "error7: write_obj_file() failed\n");
    return 7;
  }

  printf("filename: %s\n", filename);
  int length = strlen(filename);
  filename[length - 3] = 'o';                                     // change the file extension to .obj
  filename[length - 2] = 'b';
  filename[length - 1] = 'j';
  printf("filename: %s\n", filename);

  FILE* obj_file = fopen(filename, "wb");                           // open obj_file

  unsigned short int header = 0xCADE;
  unsigned short int address = 0x0000;
  unsigned short int data = 0xDADA;
  unsigned short int data_address = 0x4020; 

  fwrite(&header, sizeof(unsigned short int), 1, obj_file);         // write code header to obj file
  fwrite(&address, sizeof(unsigned short int), 1, obj_file);         // write address to obj file

  unsigned short int n = 0;
  for (int r = 0; r < ROWS; r++) {                       // count rows with data
    if (program_bin[r] != 0) {
      n++;
    }
  }
    printf("rows of data: %d\n", n);

  fwrite(&n, sizeof(unsigned short int), 1, obj_file);                      // write the number of rows with data

  for (unsigned short int r = 0; r < n; r++) {                              // write the data rows to the obj file
    fwrite(&program_bin[r], sizeof(unsigned short int), 1, obj_file);
  }

  fclose(obj_file);                           // close obj_file
  return 0;
}