#!/bin/bash

rm Comp2022/jucompiler
lex jucompiler.l
clang -o jucompiler lex.yy.c
cp jucompiler Comp2022/
cd Comp2022/
bash test.sh ./jucompiler