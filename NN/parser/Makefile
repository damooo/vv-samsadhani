SHELL = /bin/sh

.PHONY: all clean

TARGETS: nneparse.out mk_tree.out

all: $(TARGETS)

LIBPATH = LPATH
FLEX = lex
CC = gcc
CFLAGS = -L$(LIBPATH) -g -Wall -o

nneparse.out:  nneparse.lex nneparse.y
	lex nneparse.lex
	bison -d -v nneparse.y
	$(CC) $(CFLAGS) nneparse.out -DDEBUG=0 nneparse.tab.c lex.yy.c -ll
	rm lex.yy.c

mk_tree.out:  mk_tree.lex
	lex mk_tree.lex
	$(CC) $(CFLAGS) mk_tree.out lex.yy.c -ll
	rm lex.yy.c
