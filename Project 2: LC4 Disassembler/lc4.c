/************************************************************************/
/* File Name : lc4.c 													*/
/* Purpose   : This file contains the main() for this project			*/
/*             main() will call the loader and disassembler functions	*/
/*             															*/
/* Author(s) : tjf and you												*/
/************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lc4_memory.h"
#include "lc4_hash.h"
#include "lc4_loader.h"
#include "lc4_disassembler.h"

/* program to mimic pennsim loader and disassemble object files */
int hasher(void* table, void* key) {
    if (table == NULL) {
        fprintf(stderr, "HASHER error: table is null\n");
        return -1;
    }
    unsigned short int* address = key;
    if (address == NULL) {
        fprintf(stderr, "HASHER error: key is null\n");
        return -1;
    }
    if (*address >= 0x000 && *address <= 0x1FFF) {
        return 0;
    }
    else if (*address >= 0x2000 && *address <= 0x7FFF) {
        return 1;
    }
    else if (*address >= 0x8000 && *address <= 0x9FFF) {
        return 2;
    }
    else if (*address >= 0xA000 && *address <= 0xFFFF) {
        return 3;
    } else {
        fprintf(stderr, "HASHER error: invalid memory address\n");
        return -1;
    }
}
int main (int argc, char** argv) {

	/**
	 * main() holds the hashtable &
	 * only calls functions in other files
	 */

	/* step 1: create a pointer to the hashtable: memory 	*/
	lc4_memory_segmented* memory = NULL ;

	/* step 2: call create_hash_table() and create 4 buckets 	*/
	memory = create_hash_table(4, hasher);

	/* step 3: determine filename, then open it		*/
	/*   TODO: extract filename from argv, pass it to open_file() */
	FILE* output_file = open_file(argv[1]);
    if (output_file == NULL) {
        fprintf(stderr, "Unable to open %s\n", argv[1]);
        delete_table(memory);
        return -1;
    }

	/* step 4: call function: parse_file() in lc4_loader.c 	*/
	/*   TODO: call function & check for errors		*/
	/* step 5: repeat steps 3 and 4 for each .OBJ file in argv[] 	*/
	for (int i = 2; i < argc; i++) { 
        FILE* obj_file = open_file(argv[i]);
        if (obj_file == NULL) {
            fprintf(stderr, "error: unable to open %s\n", argv[i]);
        }
        parse_file(obj_file, memory);
    }

	/* step 6: call function: reverse_assemble() in lc4_disassembler.c */
	/*   TODO: call function & check for errors		*/
    reverse_assemble(memory);

	/* step 7: call function: print out the hashtable to output file */
	/*   TODO: call function 				*/
    print_table(memory, output_file);

	/* step 8: call function: delete_table() in lc4_hash.c */
	/*   TODO: call function & check for errors		*/
    delete_table(memory);

	/* only return 0 if everything works properly */
    int close = fclose(output_file);
	if (close != 0) {
		fprintf(stderr, "error: unable to close object file\n");
		return -1;
	}
	return 0 ;
}
