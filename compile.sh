#!/bin/bash

lex jucompiler.l
clang -o jucompiler lex.yy.c