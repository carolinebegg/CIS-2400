/*
 * trace.c: location of main() to start the simulator
 */

#include "loader.h"

// Global variable defining the current state of the machine
MachineState* CPU;

int main(int argc, char** argv) {
  MachineState myCPU;
  CPU = &myCPU;
  Reset(&myCPU);
  ClearSignals(&myCPU);

  if (argc < 3 || argc > 5) {
  fprintf(stderr, "\nerror: %d command line arguments\n", argc);
  return -1;
  }
  
  for (int count = 1; count < argc; count++) {
    char* file = argv[count];
    int len = strlen(file);
    if (count == 1) {
      if (file[len - 1] != 't' || file[len - 2] != 'x' || file[len - 3] != 't' || file[len - 4] != '.') {
        fprintf(stderr, "\nerror: incorrect file format [%s]\n", file);
        return -1;
      }
    }
    if (count > 2) {
      if (file[len - 1] != 'j' || file[len - 2] != 'b' || file[len - 3] != 'o' || file[len - 4] != '.') {
        fprintf(stderr, "\nerror: incorrect file format [%s]\n", file);
        return -1;
      }
    }
  }

  printf("\nOutput File: %s\n", argv[1]); // PRINT STATEMENT FOR TESTING
  for (int c = 2; c < argc; c++) {
    printf("\nParsing %s...\n", argv[c]);
    if (ReadObjectFile(argv[c], &myCPU) == 0) {
      printf("\n%s parsed sucessfully\n", argv[c]);  // PRINT STATEMENT FOR TESTING
    } else {
      printf("\nerror: unable to parse %s\n", argv[c]);  // PRINT STATEMENT FOR TESTING
    }
  }
  
  FILE* output_file = fopen(argv[1], "w");
  if (output_file == NULL) {
    fprintf(stderr, "\nerror: unable to open %s", argv[1]);
    return -1;
  }

  while (1) {
    if (UpdateMachineState(&myCPU, output_file) != 2) {
      break;
    }
  }

  fclose(output_file);
  return 0;
}