SHELL = /bin/sh
LIBPATH = LPATH
all:
	rm -f Heritage_anusaaraka.gdbm
	cut -f2,3,5,7 rt_rtiw_gana_avAnwara_gana_Heritage_rt.txt | ./create_dbm.pl Heritage_anusaaraka.gdbm 
	chmod 755 Heritage_anusaaraka.gdbm
	lex Heritage_anusaaraka_morph.lex
	gcc -g -L$(LIBPATH) -Wall -Wextra -o Heritage_anusaaraka_morph.out lex.yy.c -ll
	rm lex.yy.c
