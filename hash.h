#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// node in occurrence list
struct occurance_node {
  struct occurance_node *next;
  int data;
};

// main node, contains identifiers and
// occurrence list
struct identifier_node {
  struct identifier_node *next;
  struct occurance_node *place;
  char *data;
};

// variable to interact with the main prog
// and a scratch int
extern int linecount;
extern FILE *fout;
int my_index; 

// the table
struct identifier_node hash_table[256]; 

// prepares the table
void init_table();

// self explanator
int get_key(char *target);
void add_occurance(struct identifier_node *node);
void insert_identifier_node(int key, char *data);
void add_identifier(char *target);
void output_and_delete_table();
