/************************************************************************/
/* File Name : lc4_hash.c		 										*/
/* Purpose   : This file contains the definitions for the hash table  	*/
/*																		*/
/* Author(s) : tjf 														*/
/************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "lc4_hash.h"

/*
 * creates a new hash table with num_of_buckets requested
 */
lc4_memory_segmented* create_hash_table (int num_of_buckets, int (*hash_function)(void* table, void *key)) {
	// allocate a single hash table struct
	lc4_memory_segmented* hash_table = malloc(sizeof(lc4_memory_segmented));

	// allocate memory for the buckets (head pointers)
	hash_table->buckets = malloc(sizeof(row_of_memory*) * num_of_buckets);
	hash_table->num_of_buckets = num_of_buckets;

    for (int i = 0; i < num_of_buckets; i++) {
        hash_table->buckets[i] = NULL;
    }

	// assign function pointer to call back hashing function
	hash_table->hash_function = hash_function;
	
	// return 0 for success, -1 for failure
	return hash_table;
}


/*
 * adds a new entry to the table
 */
int add_entry_to_tbl (lc4_memory_segmented* table, unsigned short int address, unsigned short int contents) {
	if (table == NULL) {
		return -1;
	}
	// apply hashing function to determine proper bucket #
	int bucket = table->hash_function(table, &address);

	// add to bucket's linked list using linked list add_to_list() helper function
	switch (bucket) {
		case 0:
			add_to_list(&table->buckets[0], address, contents);
			return 0;
		case 1:
			add_to_list(&table->buckets[1], address, contents);
			return 0;
		case 2:
			add_to_list(&table->buckets[2], address, contents);
			return 0;
		case 3:
			add_to_list(&table->buckets[3], address, contents);
			return 0;
		default:
			return -1;
	}
	return 0;
}

/*
 * search for an address in the hash table
 */
row_of_memory* search_tbl_by_address(lc4_memory_segmented* table, unsigned short int address ) {
	// apply hashing function to determine bucket # item must be located in
	int bucket = table->hash_function(table, &address);

	// invoked linked_lists helper function, search_by_address() to return return proper node
	switch (bucket) {
		case 0:
			// return search_address(user_program_memory, address);
			return search_address(table->buckets[0], address);
		case 1:
			return search_address(table->buckets[1], address);
		case 2:
			// return search_address(os_program_memory, address);
			return search_address(table->buckets[2], address);
		case 3:
			return search_address(table->buckets[3], address);
	}
	return NULL;
}

/*
 * prints the linked list in a particular bucket
 */

void print_bucket (lc4_memory_segmented* table, int bucket_number, FILE* output_file ) {
	// call the linked list helper function to print linked list
	print_list(table->buckets[bucket_number], output_file);
	return;
}

/*
 * print the entire table (all buckets)
 */
void print_table (lc4_memory_segmented* table, FILE* output_file ) {
    if (table == NULL) {
        return;
    }
	// call the linked list helper function to print linked list to output file for each bucket
	print_list(table->buckets[0], output_file);
	print_list(table->buckets[1], output_file);
	print_list(table->buckets[2], output_file);
	print_list(table->buckets[3], output_file);
	return ;
}

/*
 * delete the entire table and underlying linked lists
 */

void delete_table (lc4_memory_segmented* table ) {
	// call linked list delete_list() on each bucket in hash table
    for (int i = 0; i < table->num_of_buckets; i++) {
        delete_list(&table->buckets[i]);
    }

	// then delete the table itself
	free(table->buckets);
	free(table);
	table = NULL;
	return ;
}
