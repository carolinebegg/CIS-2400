/*
 * loader.c : Defines loader functions for opening and loading object files
 */

#include "loader.h"

// memory array location
unsigned short memoryAddress;

/*
 * Read an object file and modify the machine state as described in the writeup
 */
int ReadObjectFile(char* filename, MachineState* CPU) {

  FILE* obj_file = fopen(filename, "rb");

  if (obj_file == NULL) {
      fprintf(stderr, "\nerror: cannot open file %s [ReadObjectFile]\n", filename);
      return -1;
  }
  printf("\nSuccessfully opened file %s [ReadObjectFile]\n", filename);

  unsigned short int header[3];
    // header[0] = heading indicator
    // header[1] = starting memory
    // header[2] = body of length n

  while (fread(header, sizeof(unsigned short int), 3, obj_file) == 3) {
    // printf("Content at address 00000: 0x%04X\n", CPU->memory[0]);
    if (header[0] == 0xdeca) {
      unsigned short int address = header[1];
      unsigned short int n = header[2];
      address = (address >> 8) | (address << 8);
      n = (n >> 8) | (n << 8);
      //printf("\nCODE Address: %05d\n", address);
      for (int i = 0; i < n; i++) {
        //printf("Inner Loop Address: %05d\n", address);
        unsigned short int data;
        fread(&data, sizeof(unsigned short int), 1, obj_file);
        data = (data >> 8) | (data << 8);
        CPU->memory[address] = data;
        //printf("Data: 0x%04X\n", data);
        address++;
      }
    } else if (header[0] == 0xdada) {
      unsigned short int address = header[1];
      unsigned short int n = header[2];
      address = (address >> 8) | (address << 8);
      n = (n >> 8) | (n << 8);
      for (int i = 0; i < n; i++) {
        unsigned short int data;
        fread(&data, sizeof(unsigned short int), 1, obj_file);
        data = (data >> 8) | (data << 8);
        CPU->memory[address] = data;
        address++;
      }
    } else if (header[0] == 0xb7c3) {
      unsigned short int address = header[1];
      unsigned short int n = header[2];
      address = (address >> 8) | (address << 8);
      n = (n >> 8) | (n << 8);
      fseek(obj_file, n, SEEK_CUR);
    } else if (header[0] == 0xF17E) {
      unsigned short int n = header[1];
      unsigned short int data;
      fseek(obj_file, n, SEEK_CUR); // does this work for skipping over the right data?
      data = (data >> 8) | (data << 8);
      // * need to switch en for this too, find rows and do fgetc n times
    } else if (header[0] == 0x715E) {
      // how to skip over this data? 3 bytes
    } 
  }
  fclose(obj_file);

  return 0;
}
