    /************************************************************************/
/* File Name : lc4_loader.c		 										*/
/* Purpose   : This file implements the loader (ld) from PennSim		*/
/*             It will be called by main()								*/
/*             															*/
/* Author(s) : tjf and you												*/
/************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lc4_memory.h"
#include "lc4_hash.h"

/* declarations of functions that must defined in lc4_loader.c */

FILE* open_file(char* file_name) {
	if (file_name == NULL) {
		fprintf(stderr, "error: NULL command-line argument %s\n", file_name);
		return NULL;
	}
    int len = strlen(file_name);
    if (file_name[len - 1] == 't' && file_name[len - 2] == 'x' && file_name[len - 3] == 't' && file_name[len - 4] == '.') {
        FILE* output_file = fopen(file_name, "w");
        return output_file;
    }
    if (file_name[len - 1] == 'j' && file_name[len - 2] == 'b' && file_name[len - 3] == 'o' && file_name[len - 4] == '.') {
        FILE* obj_file = fopen(file_name, "rb");
        return obj_file;
    }
    return NULL;
}

int parse_file (FILE* my_obj_file, lc4_memory_segmented* memory) {
	unsigned short int header[3];
	unsigned short int type;
	unsigned short int address;
	unsigned short int n;

	while (fread(header, sizeof(unsigned short int), 3, my_obj_file) == 3) {
		type = header[0];
		address = header[1];
		n = header[2];
        
        type = (type >> 8) | (type << 8);
		address = (address >> 8) | (address << 8);
		n = (n >> 8) | (n << 8);

		if (type == 0xCADE) {
			for (int i = 0; i < n; i++) {
				unsigned short int word;
				fread(&word, sizeof(unsigned short int), 1, my_obj_file);
				word = (word >> 8) | (word << 8);
				add_entry_to_tbl(memory, address, word);
				address++;
			}
		} else if (type == 0xDADA) {
			for (int i = 0; i < n; i++) {
				unsigned short int word;
				fread(&word, sizeof(unsigned short int), 1, my_obj_file);
				word = (word >> 8) | (word << 8);
				add_entry_to_tbl(memory, address, word);
				address++;
			}
		} else if (type == 0xC3B7) {
			row_of_memory* node = search_tbl_by_address(memory, address);
			node->label = malloc(sizeof(char) * (n + 1));
			for (int i = 0; i < n; i++) {
				unsigned short int word;
				fread(&word, 1, 1, my_obj_file);
				char letter = (char)word;
				node->label[i] = letter;
			}
			node->label[n] = (char)NULL;
		}
	}
	
	int close = fclose(my_obj_file);
	if (close != 0) {
		fprintf(stderr, "error: unable to close object file\n");
		delete_table(memory);
		return -1;
	}
	return 0 ;
}
