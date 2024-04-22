/*
 * LC4.c: Defines simulator functions for executing instructions
 */

#include "LC4.h"
#include <stdio.h>

unsigned short int opcode = 0;
unsigned short int subop = 0;
unsigned short int Rd = 0;
unsigned short int Rs = 0;
unsigned short int Rt = 0;
unsigned short int newPC = 0;
unsigned short int privilege = 0;
unsigned short int userModeError = 0;

#define USER_CODE_START 0x0000
#define USER_CODE_END 0x1FFF
#define USER_DATA_START 0x2000
#define USER_DATA_END 0x7FFF
#define OS_CODE_START 0x8000
#define OS_CODE_END 0x9FFF
#define OS_DATA_START 0xA000
#define OS_DATA_END 0xFFFF


//** Op Code Extraction **//

#define INSN_OP(I) ((I) >> 12); // extract 4-bit opcode [15:12]
#define INSN_OP_SHORT(I) ((I) >> 13); // extract 3-bit opcode [15:13]


//** Sub-Op Code and Register Extraction **//

#define INSN_12(I) (((I) >> 12) & 0x1); // extract 1-bit sub-opsode for LDR and STR [12]
#define INSN_8_7(I) (((I) >> 7) & 0x3); // extract 2-bit sub-opcode for COMP [8:7]
#define INSN_5_4(I) (((I) >> 4) & 0x3); // extract 2-bit sub-opcode for SHIFTS and MOD [5:4]
#define INSN_5_3(I) (((I) >> 3) & 0x7); // extract 3-bit sub-opcode for ARITH and LOGIC [5:3]
#define INSN_11(I) (((I) >> 11) & 0x1); // extract 1-bit sub-opcode for JSR and JMP [11]

#define INSN_11_9(I) (((I) >> 9) & 0x7); // extract 3-bit sub-opcode for BR / d-register code [5:3]
#define INSN_8_6(I) (((I) >> 6) & 0x7); // extract 3-bit s-register code [8:6]
#define INSN_2_0(I) ((I) & 0x7); // extract 3-bit t-register code [2:0]


//** (U)IMM and Individual Bit Extraction **//

#define INSN_10_0(I) ((I) & 0x7FF); // extract 11-bit number IMM11 [10:0]
#define INSN_10(I) (((I) >> 10) & 0x1); // extract 11th bit [10]

#define INSN_8_0(I) ((I) & 0x1FF); // extract 9-bit number IMM9 [8:0]
#define INSN_8(I) (((I) >> 8) & 0x1); // extract 9th bit [8]

#define INSN_7_0(I) ((I) & 0xFF); // extract 8-bit number UIMM8 [7:0]

#define INSN_6_0(I) ((I) & 0x7F); // extract 7-bit number IMM7 [6:0]
#define INSN_6(I) (((I) >> 6) & 0x1); // extract 7th bit [6]

#define INSN_5_0(I) ((I) & 0x3F); // extract 6-bit number IMM6 [5:0]
#define INSN_5(I) (((I) >> 5) & 0x1); // extract 6th bit [5]

#define INSN_4_0(I) ((I) & 0x1F); // extract 5-bit number IMM6 [4:0]
#define INSN_4(I) (((I) >> 4) & 0x1); // extract 5th bit [4]

#define INSN_3_0(I) ((I) & 0xF); // extract 4-bit number IMM4 [3:0]


//** NZP and PSR Extractions **//

#define INSN_NZP(I) (((I) >> 15) & 0x7);
#define INSN_PSR_15(I) ((I) >> 15);

short int sign_extender(MachineState* CPU, int length) {
  short int IMM = 0;
  int sign = 0;
  switch (length) {
    case 5:
      IMM = INSN_4_0(CPU->memory[CPU->PC]);
      sign = INSN_4(CPU->memory[CPU->PC]);
      if (sign == 1) {
        IMM = (IMM | 0xFFE0); // 0xFFE0 = 1111 1111 1110 0000
      }
      break;
    case 6:
      IMM = INSN_5_0(CPU->memory[CPU->PC]);
      sign = INSN_5(CPU->memory[CPU->PC]);
      if (sign == 1) {
        IMM = (IMM | 0xFFC0); // 0xFFC0 = 1111 1111 1100 0000
      }
      break;
    case 7:
      IMM = INSN_6_0(CPU->memory[CPU->PC]);
      sign = INSN_6(CPU->memory[CPU->PC]);
      if (sign == 1) {
        IMM = (IMM | 0xFF80); // 0xFF80 = 1111 1111 1000 0000
      }
      break;
    case 9:
      IMM = INSN_8_0(CPU->memory[CPU->PC]);
      sign = INSN_8(CPU->memory[CPU->PC]);
      if (sign == 1) {
        IMM = (IMM | 0xFE00); // 0xFE00 = 1111 1110 0000 0000
      }
      break;
    case 11:
      IMM = INSN_10_0(CPU->memory[CPU->PC]);
      sign = INSN_10(CPU->memory[CPU->PC]);
      if (sign == 1) {
        IMM = (IMM | 0xF800); // 0xF800 = 1111 1000 0000 0000
      }
      break;
  }
  return IMM;
}

/*
 * Reset the machine state as Pennsim would do
 */
void Reset(MachineState* CPU) {
  printf("\nResetting the machine state...");
    CPU->PC = 0x8200;
    CPU->PSR = 0x8002;
    for (int i = 0; i < 65536; i++) {
      CPU->memory[i] = 0x0000;             // initialize memory values to 0 
    }
    for (int r = 0; r < 8; r++) {
      CPU->R[r] = 0;
    }
    CPU->dmemAddr = 0;
    CPU->dmemValue = 0;
    printf("machine state reset successfully\n");
}

/*
 * Clear all of the control signals (set to 0)
 */
void ClearSignals(MachineState* CPU) {
  printf("\nClearing control signals...");
  CPU->rsMux_CTL = 0;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->regFile_WE = 0;
  CPU->NZP_WE = 0;
  CPU->DATA_WE = 0;
  printf("control signals cleared successfully\n");
}

void checkUserModeAccessError(MachineState* CPU, unsigned short int address) {
  if (address >= OS_CODE_START) {
    privilege = INSN_PSR_15(CPU->PSR);
    if (privilege == 0) {
      fprintf(stderr, "error: attempted to access OS memory without permission");
      userModeError = 1;
    }
  }
}

//////////////// ADDITIONAL PARSING HELPER FUNCTIONS ///////////////////////////

void RTIOp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: RTI\n");
  newPC = CPU->R[7];
  CPU->PSR = ((CPU->PSR) << 1);
  CPU->PSR = ((CPU->PSR) >> 1);

  CPU->rsMux_CTL = 1;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->regFile_WE = 0;
  CPU->NZP_WE = 0;
  CPU->DATA_WE = 0;
}
void CONSTOp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: CONST\n");
  short int IMM9 = 0;
  Rd = INSN_11_9(CPU->memory[CPU->PC]);
  IMM9 = sign_extender(CPU, 9);
  CPU->R[Rd] = IMM9;
  SetNZP(CPU, IMM9);
  CPU->regInputVal = CPU->R[Rd];

  CPU->rsMux_CTL = 0;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->regFile_WE = 1;
  CPU->NZP_WE = 1;
  CPU->DATA_WE = 0;
  newPC = CPU->PC + 1;
}

void HICONSTOp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: HICONST\n");
  unsigned short int UIMM8 = 0;
  subop = INSN_8(CPU->memory[CPU->PC]);
  Rd = INSN_11_9(CPU->memory[CPU->PC]);
  UIMM8 = INSN_7_0(CPU->memory[CPU->PC]);

  CPU->R[Rd] = ((CPU->R[Rd] & 0xFF) | (UIMM8 << 8));
  SetNZP(CPU, ((CPU->R[Rd] & 0xFF) | (UIMM8 << 8)));
  CPU->regInputVal = CPU->R[Rd];

  CPU->rsMux_CTL = 2;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->regFile_WE = 1;
  CPU->NZP_WE = 1;
  CPU->DATA_WE = 0;
  newPC = CPU->PC + 1;
}

void TRAPOp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: TRAP\n");
  unsigned short int UIMM8 = 0;
  UIMM8 = INSN_7_0(CPU->memory[CPU->PC]);

  //printf("UMMI8: %d\n", UIMM8);

  CPU->R[7] = CPU->PC + 1;
  newPC = (0x8000 | UIMM8);
  CPU->PSR = ((CPU->PSR) << 1);
  CPU->PSR = ((CPU->PSR) >> 1);
  CPU->PSR = ((CPU->PSR) | 0x8000);
  SetNZP(CPU, CPU->PC + 1);

  CPU->rsMux_CTL = 0;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 1;
  CPU->regFile_WE = 1;
  CPU->NZP_WE = 1;
  CPU->DATA_WE = 0;
  CPU->regInputVal = CPU->R[7];
  Rd = 7;
}

void LDROp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: LDR\n");
  short int IMM6 = 0;
  IMM6 = sign_extender(CPU, 6);
  Rd = INSN_11_9(CPU->memory[CPU->PC]);
  Rs = INSN_8_6(CPU->memory[CPU->PC]);

  CPU->dmemAddr = CPU->R[Rs] + IMM6;
  CPU->dmemValue = CPU->memory[CPU->dmemAddr];
  CPU->R[Rd] = CPU->dmemValue;
  
  checkUserModeAccessError(CPU, CPU->dmemAddr);

  SetNZP(CPU, CPU->dmemValue);
  CPU->rsMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->rtMux_CTL = 0;
  CPU->regFile_WE = 1;
  CPU->NZP_WE = 1;
  CPU->DATA_WE = 0;

  CPU->regInputVal = CPU->R[Rd];
  newPC = CPU->PC + 1;
}
void STROp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: STR\n");
  short int IMM6 = 0;
  IMM6 = sign_extender(CPU, 6);
  Rt = INSN_11_9(CPU->memory[CPU->PC]);
  Rs = INSN_8_6(CPU->memory[CPU->PC]);

  CPU->dmemAddr = CPU->R[Rs] + IMM6;
  CPU->dmemValue = CPU->R[Rt];
  CPU->memory[CPU->dmemAddr] = CPU->dmemValue;

  checkUserModeAccessError(CPU, CPU->dmemAddr);
  checkUserModeAccessError(CPU, CPU->dmemAddr + IMM6);

  CPU->rsMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->rtMux_CTL = 1;
  CPU->regFile_WE = 0;
  CPU->NZP_WE = 0;
  CPU->DATA_WE = 1;
  newPC = CPU->PC + 1;
}

/*
 * This function should write out the current state of the CPU to the file output.
 */
void WriteOut(MachineState* CPU, FILE* output) {
  if (CPU->PC != 0x80FF) {
    fprintf(output, "%04X ", CPU->PC); // write to file

    unsigned short int binary = 0; 
    unsigned short int temp = 0; 
    binary = CPU->memory[CPU->PC];
    temp = CPU->memory[CPU->PC];

    for (int i = 15; i >= 0; i--) {
      temp = ((binary >> i) & 0x1);
      fprintf(output, "%d", temp);
    }

    fprintf(output, " %d", CPU->regFile_WE); // write to file
    if (CPU->regFile_WE !=0) {
      fprintf(output, " %d", Rd); // write to file
      fprintf(output, " %04X", CPU->regInputVal); // write to file
    } else {
      fprintf(output, " 0"); // write to file
      fprintf(output, " 0000"); // write to file
    }

    fprintf(output, " %d", CPU->NZP_WE); // write to file
    if (CPU->NZP_WE != 0) {
      fprintf(output, " %d", CPU->NZPVal); // write to file
    } else {
      fprintf(output, " 0"); // write to file
    }

    fprintf(output, " %d", CPU->DATA_WE); // write to file
    fprintf(output, " %04X", CPU->dmemAddr); // write to file
    fprintf(output, " %04X", CPU->dmemValue);

    fprintf(output, "\n"); // write to file
  }
}

/*
 * This function should execute one LC4 datapath cycle.
 */
int UpdateMachineState(MachineState* CPU, FILE* output) {
  unsigned short int currentPC = 0;

  opcode = INSN_OP(CPU->memory[CPU->PC]);

  switch (opcode) {
    case 0x0: // opcode = 0000
      BranchOp(CPU, output);
      break;
    case 0x1: // opcode = 0001
      ArithmeticOp(CPU, output);
      break;
    case 0x2: // opcode = 0010
      ComparativeOp(CPU, output);
      break;
    case 0x4: // opcode = 0100
      JSROp(CPU, output);
      break;
    case 0x5: // opcode = 0101
      LogicalOp(CPU, output);
      break;
    case 0x6: // opcode = 0110
      LDROp(CPU, output);
      break;
    case 0x7: // opcode = 0111
      STROp(CPU, output);
      break;
    case 0x8: // opcode = 1000 [RTI]
      RTIOp(CPU, output);
      break;
    case 0x9: // opcode = 1001 [CONST]
      CONSTOp(CPU, output);
      break;
    case 0xA: // opcode = 1010
      ShiftModOp(CPU, output);
      break;
    case 0xC: // opcode = 1100
      JumpOp(CPU, output);
      break;
    case 0xD: // opcode = 1101
      HICONSTOp(CPU, output);
      break;
    case 0xF: // opcode = 1111 [TRAP]
      TRAPOp(CPU, output);
      break;
  }
  checkUserModeAccessError(CPU, newPC);
  if (userModeError == 1) {
      fprintf(stderr, "\nerror: attempted to access the OS memory in user mode\n");
    return 1;
  }

  WriteOut(CPU, output);
  if (newPC == 0x80FF) {
    printf("\nPC = %04X\n", newPC);
    return -1;
  } else {
    CPU->PC = newPC;
  }
  opcode = 0;
  subop = 0;
  CPU->dmemAddr = 0x0;
  CPU->dmemValue = 0x0;
  return 2;
}


//////////////// PARSING HELPER FUNCTIONS ///////////////////////////

/*
 * Parses rest of branch operation and updates state of machine.
 */
void BranchOp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: Branch>");
  short int IMM9 = 0;
  subop = INSN_11_9(CPU->memory[CPU->PC]);
  IMM9 = sign_extender(CPU, 9);

  switch(subop) {
    case 0x0: // sub-opcode: 000 [NOP]
    //printf("NOP\n");
      newPC = CPU->PC + 1;
      break;
    case 0x4: // sub-opcode: 100 [BRn]
    //printf("BRn\n");
      if (CPU->NZPVal == 0x4) {
        newPC = CPU->PC + 1 + IMM9;
      } else {
        newPC = CPU->PC + 1;
      }
      break;
    case 0x6: // sub-opcode: 110 [BRnz]
    //printf("BRnz\n");
      if (CPU->NZPVal == 0x4 || CPU->NZPVal == 0x2) {
        newPC = CPU->PC + 1 + IMM9;
      } else {
        newPC = CPU->PC + 1;
      }
      break;
    case 0x5: // sub-opcode: 101 [BRnp]
    //printf("BRnp\n");
      if (CPU->NZPVal == 0x4 || CPU->NZPVal == 0x1) {
        newPC = CPU->PC + 1 + IMM9;
      } else {
        newPC = CPU->PC + 1;
      }
      break;
    case 0x2: // sub-opcode: 010 [BRz]
    //printf("BRz\n");
      if (CPU->NZPVal == 0x2) {
        newPC = CPU->PC + 1 + IMM9;
      } else {
        newPC = CPU->PC + 1;
      }
      break;
    case 0x3: // sub-opcode: 011 [BRzp]
    //printf("BRzp\n");
      if (CPU->NZPVal == 0x1 || CPU->NZPVal == 0x2) {
        newPC = CPU->PC + 1 + IMM9;
      } else {
        newPC = CPU->PC + 1;
      }
      break;
    case 0x1: // sub-opcode: 001 [BRp]
    //printf("BRp\n");
      if (CPU->NZPVal == 0x1) {
        newPC = CPU->PC + 1 + IMM9;
      } else {
        newPC = CPU->PC + 1;
      }
      break;
    case 0x7: // sub-opcode: 111 [BRnzp]
    //printf("BRnzp\n");
      newPC = CPU->PC + 1 + IMM9;
      break;
  }

  CPU->rsMux_CTL = 0;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->regFile_WE = 0;
  CPU->NZP_WE = 0;
  CPU->DATA_WE = 0;
}

/*
 * Parses rest of arithmetic operation and prints out.
 */
void ArithmeticOp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: Arithmetic>");
  Rd = INSN_11_9(CPU->memory[CPU->PC]);
  Rs = INSN_8_6(CPU->memory[CPU->PC]);
  Rt = INSN_2_0(CPU->memory[CPU->PC]);

  subop = INSN_5(CPU->memory[CPU->PC]);
  if (subop == 0x1) { // sub-opcode: 1 [ADD IMM]
    short int IMM5 = 0;
    IMM5 = sign_extender(CPU, 5);
    CPU->R[Rd] = CPU->R[Rs] + IMM5;
  } else {
    subop = INSN_5_3(CPU->memory[CPU->PC]);
    switch(subop) {
      case 0x0: // sub-opcode: 000 [ADD]
      //printf("ADD\n");
        CPU->R[Rd] = CPU->R[Rs] + CPU->R[Rt];
        break;
      case 0x1: // sub-opcode: 001 [MUL]
      //printf("MUL\n");
        CPU->R[Rd] = CPU->R[Rs] * CPU->R[Rt];
        break;
      case 0x2: // sub-opcode: 110 [SUB]
      //printf("SUB\n");
        CPU->R[Rd] = CPU->R[Rs] - CPU->R[Rt];
        break;
      case 0x3: // sub-opcode: 101 [DIV]
      //printf("DIV\n");
        CPU->R[Rd] = CPU->R[Rs] / CPU->R[Rt];
        break;
    }
  }
  SetNZP(CPU, CPU->R[Rd]);
  CPU->rsMux_CTL = 0;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->regFile_WE = 1;
  CPU->NZP_WE = 1;
  CPU->DATA_WE = 0;

  newPC = CPU->PC + 1;
  CPU->regInputVal = CPU->R[Rd];
}

/*
 * Parses rest of comparative operation and prints out.
 */
void ComparativeOp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: Comparative>");
  short int IMM7 = 0;
  unsigned short int UIMM7 = 0;
  short int result = 0;

  subop = INSN_8_7(CPU->memory[CPU->PC]);
  Rs = INSN_11_9(CPU->memory[CPU->PC]);
  Rt = INSN_2_0(CPU->memory[CPU->PC]);
  IMM7 = sign_extender(CPU, 7);
  UIMM7 = INSN_6_0(CPU->memory[CPU->PC]);

  switch(subop) {
    case 0x0: // sub-opcode: 00 [CMP]
    //printf("CMP\n");
      result = CPU->R[Rs] - CPU->R[Rt];
      SetNZP(CPU, result);
      CPU->rtMux_CTL = 0;
      break;
    case 0x1: // sub-opcode: 01 [CMPU]
    //printf("CMPU\n");
    //printf("R%d = %d\n", Rs, CPU->R[Rs]);
    //printf("R%d = %d\n", Rt, CPU->R[Rt]);
      result = CPU->R[Rs] - CPU->R[Rt];
      SetNZP(CPU, result);
      CPU->rtMux_CTL = 0;
      break;
    case 0x2: // sub-opcode: 10 [CMPI]
    //printf("CMPI\n");
      result = CPU->R[Rs] - IMM7;
      SetNZP(CPU, result);
      break;
    case 0x3: // sub-opcode: 11 [CMPIU]
    //printf("CMPIU\n");
      result = (short int)CPU->R[Rs] - (short int)UIMM7;
      SetNZP(CPU, result);
      break;
  } 
  CPU->rsMux_CTL = 2;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->regFile_WE = 0;
  CPU->NZP_WE = 1;
  CPU->DATA_WE = 0;

  newPC = CPU->PC + 1;
}

/*
 * Parses rest of logical operation and prints out.
 */
void LogicalOp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: Logical>");
  subop = INSN_5_3(CPU->memory[CPU->PC]);
  Rd = INSN_11_9(CPU->memory[CPU->PC]);
  Rs = INSN_8_6(CPU->memory[CPU->PC]);
  Rt = INSN_2_0(CPU->memory[CPU->PC]);

  switch(subop) {
    case 0x0: // sub-opcode: 000 [AND]
    //printf("AND\n");
      CPU->R[Rd] = ((CPU->R[Rs]) & (CPU->R[Rt]));
      break;
    case 0x1: // sub-opcode: 001 [NOT]
    ///printf("NOT\n");
      CPU->R[Rd] = ~(CPU->R[Rs]);
      break;
    case 0x2: // sub-opcode: 110 [OR]
    //printf("OR\n");
      CPU->R[Rd] = ((CPU->R[Rs]) | (CPU->R[Rt]));
      break;
    case 0x3: // sub-opcode: 101 [XOR]
    //printf("XOR\n");
      CPU->R[Rd] = ((CPU->R[Rs]) ^ (CPU->R[Rt]));
      break;
  }
  subop = INSN_5(CPU->memory[CPU->PC]);
  if (subop == 0x1) { // sub-opcode: 1 [AND IMM]
  //printf("AND IMM\n");
    short int IMM5 = 0;
    IMM5 = sign_extender(CPU, 5);
    CPU->R[Rd] = ((CPU->R[Rs]) & (IMM5));
  }
  SetNZP(CPU, CPU->R[Rd]);
  CPU->rsMux_CTL = 0;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->regFile_WE = 1;
  CPU->NZP_WE = 1;
  CPU->DATA_WE = 0;

  newPC = CPU->PC + 1;
  CPU->regInputVal = CPU->R[Rd];
}

/*
 * Parses rest of jump operation and prints out.
 */
void JumpOp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: Jump>");
  short int IMM11 = 0;
  subop = INSN_11(CPU->memory[CPU->PC]);
  Rs = INSN_8_6(CPU->memory[CPU->PC]);
  IMM11 = sign_extender(CPU, 11);

  switch(subop) {
    case 0x0: // sub-opcode: 00 [JMPR]
    //printf("JMPR\n");
      newPC = CPU->R[Rs];
      break;
    case 0x1: // sub-opcode: 01 [JMP]
    //printf("JMP\n");
      newPC = CPU->PC + 1 + IMM11;
      break;
  }

  CPU->rsMux_CTL = 0;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->regFile_WE = 0;
  CPU->NZP_WE = 0;
  CPU->DATA_WE = 0;
}

/*
 * Parses rest of JSR operation and prints out.
 */
void JSROp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: JSR>");
  short int IMM11 = 0;
  subop = INSN_11(CPU->memory[CPU->PC]);
  Rs = INSN_8_6(CPU->memory[CPU->PC]);
  IMM11 = sign_extender(CPU, 11);

  switch(subop) {
    case 0x0: // sub-opcode: 0 [JSRR]
    // printf("JSRR\n");
    //   printf("Rs = %d\n", Rs);
    //   printf("R7 = %d\n", CPU->R[7]);
      newPC = CPU->R[Rs];
      CPU->R[7] = CPU->PC + 1;
      //newPC = CPU->R[Rs];
      // printf("new PC: %d\n", CPU->R[Rs]);
      break;
    case 0x1: // sub-opcode: 1 [JSR]
    // printf("JSR\n");
      CPU->R[7] = CPU->PC + 1;
      newPC = (((CPU->PC) & 0x8000) | (IMM11 << 4));
      break;
  }
  SetNZP(CPU, CPU->R[7]);
 
  CPU->rsMux_CTL = 0;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 1;
  CPU->regFile_WE = 1;
  CPU->NZP_WE = 1;
  CPU->DATA_WE = 0;
  CPU->regInputVal = CPU->R[7];
  Rd = 7;
}

/*
 * Parses rest of shift/mod operations and prints out.
 */
void ShiftModOp(MachineState* CPU, FILE* output) {
  //printf("\nCurrent Instruction: ShiftMod>");
  unsigned short int UIMM4 = 0;

  subop = INSN_5_4(CPU->memory[CPU->PC]);
  Rd = INSN_11_9(CPU->memory[CPU->PC]);
  Rs = INSN_8_6(CPU->memory[CPU->PC]);
  Rt = INSN_2_0(CPU->memory[CPU->PC]);
  UIMM4 = INSN_3_0(CPU->memory[CPU->PC]);

  switch(subop) {
    case 0x0: // sub-opcode: 00 [SLL]
    printf("SLL\n");
      CPU->R[Rd] = CPU->R[Rs] << UIMM4;
      break;
    case 0x1: // sub-opcode: 01 [SRA]
    printf("SRA\n");
      CPU->R[Rs] = (short int)CPU->R[Rs] >> UIMM4;
      break;
    case 0x2: // sub-opcode: 10 [SRL]
    printf("SRL\n");
      CPU->R[Rd] = CPU->R[Rs] >> UIMM4;
      break;
    case 0x3: // sub-opcode: 11 [MOD]
    printf("MOD\n");
      CPU->R[Rd] = CPU->R[Rs] % CPU->R[Rt];
      break;
  }
  SetNZP(CPU, CPU->R[Rd]);
  CPU->rsMux_CTL = 0;
  CPU->rtMux_CTL = 0;
  CPU->rdMux_CTL = 0;
  CPU->regFile_WE = 1;
  CPU->NZP_WE = 1;
  CPU->DATA_WE = 0;
  CPU->regInputVal = CPU->R[Rd];
  newPC = CPU->PC + 1;
}

/*
 * Set the NZP bits in the PSR.
 */
void SetNZP(MachineState* CPU, short result) {

  CPU->PSR = (CPU->PSR >> 3);
  CPU->PSR = (CPU->PSR << 3);
  //CPU->PSR = (CPU->PSR & 0x8000);

  if (result == 0) {
    CPU->NZPVal = 0x2;
    CPU->PSR = (CPU->PSR | 0x2);
  } else if (result > 0) {
    CPU->NZPVal = 0x1;
    CPU->PSR = (CPU->PSR | 0x1);
  } else if (result < 0) {
    CPU->NZPVal = 0x4;
    CPU->PSR = (CPU->PSR | 0x4);
  }
}