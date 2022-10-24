#!/bin/sh

# run lex and compile the resulting C analyser
lex $1
yacc $2 -d --debug --verbose
clang -o $3 lex.yy.c y.tab.c


# $1 = file.l
# $2 = file.y
# $3 = executable_name