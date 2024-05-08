/************************************************************************/
/* File Name : lc4_memory.c		 										*/
/* Purpose   : This file implements the linked_list helper functions	*/
/* 			   to manage the LC4 memory									*/
/*             															*/
/* Author(s) : tjf, Caroline Begg										*/
/************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "lc4_memory.h"

#define INSN_OP(I) ((I) >> 12); // extract 4-bit opcode [15:12]

// void print_row (row_of_memory* curr, FILE* output_file ) {
// 	if (curr == NULL) {
//         fprintf(stderr, "   LC4_MEMORY.C: error: attempted to print list with null head\n");
// 		return;
// 	}
//     printf("LC4_MEMORY.C: address = 0x%04X, ", curr->address); // print to terminal
//     printf("contents = 0x%04X, ", curr->contents); // print to terminal
//     if (curr->label == NULL) {
//         printf("label = nil, "); // print to terminal
//     } else {
//         printf("label = %s, ", curr->label); // print to terminal
//     }
//     if (curr->assembly == NULL) {
//         printf("assembly = nil\n"); // print to terminal
//     } else {
//         printf("assembly = %s\n", curr->assembly); // print to terminal
//     }
// 	return;
// }

/*
 * adds a new node to linked list pointed to by head
 */
int add_to_list (row_of_memory** head, unsigned short int address, unsigned short int contents) {
	/* allocate memory for a single node */
    row_of_memory* new_row = malloc(sizeof(row_of_memory));
	if (new_row == NULL) {
		return -1;
	}

	/* populate fields in newly allocated node with arguments: address/contents */
	new_row->address = address;
	new_row->contents = contents;

    /* make certain to set other fields in structure to NULL */
	new_row->label = NULL;
	new_row->assembly = NULL;
	new_row->next = NULL;

	/* if head==NULL, node created is the new head of the list! */
	if (*head == NULL) {
        *head = new_row;
		return 0;
	}

	/* otherwise, insert the node into the linked list keeping it in order of ascending addresses */
    row_of_memory* curr = *head;
    if (new_row->address < curr->address) {
        new_row->next = curr;
        *head = new_row;
        return 0;
    }
    while (curr->next != NULL) {
        if (new_row->address < curr->next->address) {
            row_of_memory* after = curr->next;
            curr->next = new_row;
            new_row->next = after;
            return 0;
        }
        curr = curr->next;
    }
    curr->next = new_row;

	/* return 0 for success, -1 if malloc fails */
	return 0;
}


/*
 * search linked list by address field, returns node if found
 */
row_of_memory* search_address (row_of_memory* head, unsigned short int address ) {
	/* traverse linked list, searching each node for "address"  */
    if (head == NULL) {
		return NULL;
	}
    while (head != NULL) {
        if (head->address == address) {
            return head;
        }
        head = head->next;
    }
	/* return NULL if list is empty or if "address" isn't found */
	return NULL;
}

/*
 * search linked list by opcode field, returns node if found
 */
row_of_memory* search_opcode (row_of_memory* head, unsigned short int opcode) {
    if (head == NULL) { /* return NULL if list is empty */
		return NULL;
	}
    unsigned short int code;
	/* traverse linked list until node is found with matching opcode
	   AND "assembly" field of node is empty */
    while (head != NULL) {
        code = INSN_OP(head->contents);
        // print_row(head, stdout);
        if (code == opcode && head->assembly == NULL) {
            // print_row(head, stdout);
            return head; /* return pointer to node in the list if item is found */
        }
        head = head->next;
    }

	/* return NULL if there are no matching nodes */
	return NULL ;
}

/*
 * delete the node from the linked list with matching address
 */
int delete_from_list (row_of_memory** head, unsigned short int address ) {
	if (head == NULL) {
		return -1; /* return -1 if the list is empty */
	}
    /* if head isn't NULL, traverse linked list until node is found with matching address */
    row_of_memory* curr = *head;
    if (address == curr->address) {
        row_of_memory* after = curr->next;
        free(curr->label);
        free(curr->assembly);
        free(curr);
        /* make certain to update the head pointer if original was deleted */
        *head = after; 
        /* return 0 if successfully deleted the node from list */
        return 0;
    }
    while (curr->next != NULL) {
        if (address == curr->next->address) {
            row_of_memory* after = curr->next->next;
            free(curr->next->label);
            free(curr->next->assembly);
            free(curr->next);
            curr->next = after;
            return 0;
        }
        curr = curr->next;
    }
    /* return -1 if node wasn't found */
    return -1;
}

void print_list (row_of_memory* head, FILE* output_file ) {
	/* make sure head isn't NULL */
	if (head == NULL) {
		return;
	}

	/* print out a header to output_file */
    fprintf(output_file, "<label>   <address>   <contents>  <assembly>\n"); // print to output file

	/* traverse linked list, print contents of each node to output_file */
    row_of_memory* curr = head;
    int count = 0;
    while (curr != NULL) {
        /** NEW PRINT_LIST FUNCTION **/
        if (curr->label == NULL) {
            fprintf(output_file, "          "); // print to output file
        } else {
            fprintf(output_file, "%s        ", curr->label); // print to output file
        }
        fprintf(output_file, "%04X      ", curr->address); // print to output file
        fprintf(output_file, "%04X      ", curr->contents); // print to output file
        if (curr->assembly == NULL) {
            fprintf(output_file, "\n"); // print to output file
        } else {
            fprintf(output_file, "%s\n", curr->assembly); // print to output file
        }
        curr = curr->next;
    }
	return;
}

/*
 * delete entire linked list
 */
void delete_list (row_of_memory** head) {
    if (head == NULL) {
	    return; /* return if the list is empty */
	}
    row_of_memory* curr = *head;
    row_of_memory* temp = NULL;
    /* delete entire list node by node */
    while (curr != NULL) {
        temp = curr->next;
        free(curr->label);
        free(curr->assembly);
        free(curr);
        curr = temp;
    }
    /* set head = NULL upon deletion */
    *head = NULL;
	return;
}