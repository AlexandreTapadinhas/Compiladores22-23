all: 
	lex jucompiler.l
	yacc jucompiler.y -d --debug --verbose
	cc -o jucompiler lex.yy.c y.tab.c
	zip -r jucompiler.zip jucompiler.l jucompiler.y

img: jucompiler.y y.dot
	bison --graph jucompiler.y
	dot -Tpng y.dot -o automaton.png

clean:
	rm jucompiler

zip: jucompiler.l jucompiler.y *.c *.h
	zip jucompiler.zip jucompiler.l jucompiler.y symtab.* semantics.* functions.* structures.h