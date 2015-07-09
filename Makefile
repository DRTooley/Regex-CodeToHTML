#CS441 Fall 2014 handout for pa1  UK-CS-JWJ
CC         = gcc -Wall
OPTIONS    = -lfl
FLEX       = /usr/bin/flex
BIN_NAME   = pa1cs441f14

all: hash $(BIN_NAME)

hash: hash.h hash.c
	$(CC) -c hash.c

lex.yy.o:  pascal.lex
	$(FLEX)  pascal.lex
	$(CC) -c lex.yy.c

$(BIN_NAME): hash.o lex.yy.o
	$(CC) -o $(BIN_NAME) hash.o lex.yy.o $(OPTIONS)

clean:
	rm -f *~ *.o lex.yy.c 
