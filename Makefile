all: interface

test1: test1.leg
	leg test1.leg > test1.c && \
	gcc -std=c99 test1.c -o test1

interface: interface.ooc interface.glade
	ooc interface.ooc
