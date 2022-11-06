#!/bin/bash

# lex jucompiler.l
# clang -o jucompiler lex.yy.c

lex jucompiler.l
yacc jucompiler.y -d --debug --verbose
cc -o jucompiler lex.yy.c y.tab.c
zip -r jucompiler.zip jucompiler.l jucompiler.y