
#include "hash.h"
#include <stdio.h>

#define poon

void init_table() {
	for (my_index = 0; my_index < 256; my_index++)
		hash_table[my_index].next = NULL;
}
// parse through, printing and deleting
void output_and_delete_table() {
	int iden_count = 0;
	int prev_line_num = 0;//added so that a variable would not be added twice for the same line
	struct identifier_node *iden_deleter, *iden_place;
	struct occurance_node *occur_deleter, *occur_place, *occur_counter;
	fprintf(fout, "<table border=0 cellpadding=0 cellspacing=0>\n");
	for (my_index = 0; my_index < 256; my_index++) {
		iden_place = hash_table[my_index].next;
		while (iden_place != NULL) {
			iden_deleter = iden_place;
			iden_place = iden_place->next;
			occur_place = iden_deleter->place;
			occur_deleter = occur_place;

			//The following variable and loop were added so that the total number of the 
			//variable in the file could be counted and displayed
			occur_counter = occur_place;
			while(occur_counter != NULL){
				occur_counter=occur_counter->next;
				iden_count++;
			}
			fprintf(fout, "<tr valign=top><td>[%d] %s</td><td width=8></td><td><a href=\"#%d\">%d</a>", iden_count, iden_deleter->data, occur_deleter->data, occur_deleter->data);
			iden_count = 0;
			occur_place = occur_place->next;
			free(occur_deleter);
			while (occur_place != NULL) {
				occur_deleter = occur_place;
				if(prev_line_num != occur_deleter->data){//checks to ensure that the same line number is not output twice
					prev_line_num = occur_deleter->data;
					fprintf(fout, ", <a href=\"#%d\">%d</a>", occur_deleter->data, occur_deleter->data);
				}
				occur_place = occur_place->next;
				free(occur_deleter);
			}
			fprintf(fout, "</td></tr><tr height=1 bgcolor=#000000><td height=1 colspan=3></td></tr>\n");
			free(iden_deleter->data);
			free(iden_deleter);
		}	
	}
	fprintf(fout, "</table>");
	
}
// simple hashing function, better than random
int get_key(char *target) {
	int counter = strlen(target);
	unsigned int ret = 1;
	for (; counter > 0;)
		if (counter % 2 == 0)
			ret *= (int)target[counter--];
	    else
			ret += (int)target[counter--];

	return ret % 256;
	
}

// and an occurance at linecount
void add_occurance(struct identifier_node *node) {
	struct occurance_node *place = node->place;
	
	for (; place->next != NULL; place = place->next);
		
	place->next = (struct occurance_node *) malloc(8);
	place->next->next = NULL;
	place->next->data = linecount - 1;
	
	
}

// find the place in the list and add an occurrence
// if this key doesn't have one yet create it
void insert_identifier_node(int key, char *data) {
	struct identifier_node *place = &hash_table[key];
	
	for (; place->next != NULL; place = place->next)
		if (strcmp(data, place->next->data) == 0) {
			add_occurance(place->next);
		    return;
		
	}
	
	place->next = (struct identifier_node *) malloc(12);
	place->next->next = NULL;
	place->next->data = (char *)strdup(data);
	place->next->place = (struct occurance_node *) malloc(8);
	place->next->place->data = linecount - 1; // added the -1 here so that the line number would be corrent
	place->next->place->next = NULL;
	
}

// first find the key, then add to the list
void add_identifier(char *target) {
	int key = get_key(target);
	insert_identifier_node(key, target);	
}
