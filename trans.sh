#!/bin/bash

if [ $# -eq 0 ]; then
	echo "please specify the brainfuck file to compile"
	exit
fi

TARGET="$1.bin"
TEMP_FILE=$(mktemp XXXXXXX.c)

echo "transcompiler for brainfuck"

echo "creating file..."

echo "#include <stdio.h>" > $TEMP_FILE
echo "char array[30000] = {0}; char *ptr = array; int main() {" >> $TEMP_FILE

echo "translating..."

cat $1 | sed -e 's/[^][,.<>+-]//g' -e 's/+/++*ptr;/g' -e 's/-/--*ptr;/g' -e 's/>/++ptr;/g' -e 's/</--ptr;/g' -e 's/\./putchar(*ptr);/g' -e 's/,/*ptr=getchar();/g' -e 's/\[/while (*ptr) {/g' -e 's/\]/}/g' >> $TEMP_FILE

echo "return 0;}" >> $TEMP_FILE

echo "compiling with gcc..."

which gcc && gcc -O3 $TEMP_FILE -o $TARGET

[ -f $TARGET ] && echo "done!"
[ ! -f $TARGET ] && echo "could not complete"

rm $TEMP_FILE
