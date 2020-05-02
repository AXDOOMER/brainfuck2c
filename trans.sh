#!/bin/bash

if [ $# -eq 0 ]; then
	echo "please specify the brainfuck file to compile"
	exit
fi

TARGET="$1.bin"

echo "transcompiler for brainfuck"

echo "creating file..."

echo "#include <stdio.h>" > main.c
echo "char array[30000] = {0}; char *ptr = array; int main() {" >> main.c

echo "translating..."

cat $1 | sed 's/[^][,.<>+-]//g'| sed 's/+/++*ptr;/g' | sed 's/-/--*ptr;/g' | sed 's/>/++ptr;/g' | sed 's/</--ptr;/g' | sed 's/\./putchar(*ptr);/g' | sed 's/,/*ptr=getchar();/g' | sed 's/\[/while (*ptr) {/g' | sed 's/\]/}/g' >> main.c

echo "return 0;}" >> main.c

echo "compiling with gcc..."

which gcc && gcc -O3 main.c -o $TARGET

[ -f $TARGET ] && echo "done!"
[ ! -f $TARGET ] && echo "could not complete"
