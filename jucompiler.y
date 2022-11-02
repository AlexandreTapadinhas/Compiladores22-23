%{
	
	#include <stdio.h>
	#include <string.h>
	#include "structures.h"

	#define YYDEBUG 1

	struct node * root = NULL;
	int yylex(void);
	int yylex_destroy();
	void yyerror(const char *s);
	int errortag = 0, printflag = 0;
	int stmtcount = 0;
%}

%union {
	char * id;
	char * strlit;
	char * boollit;
	char * intlit;
	char * reallit;
	struct node * node;
}

%token AND ASSIGN STAR COMMA DIV EQ GE GT LBRACE LE LPAR LSQ LT MINUS MOD NE NOT OR PLUS RBRACE RPAR RSQ SEMICOLON ARROW LSHIFT RSHIFT XOR CLASS DOTLENGTH ELSE IF PRINT PARSEINT PUBLIC RETURN STATIC STRING VOID WHILE INT DOUBLE BOOL RESERVED

%token <id> ID
%token <intlit> INTLIT
%token <reallit> REALLIT
%token <boollit> BOOLLIT
%token <strlit> STRLIT

%type <node> Program ProgramScript MethodDecl FieldDecl FieldDecl2 Type MethodHeader MethodHeader2 FormalParams FormalParams2 MethodBody MethodBody2 VarDecl VarDecl2 Statement Statement2 ExprReturn Statement3 StatementPrint MethodInvocation MethodInvocation2 MethodInvocationExpr Assignment ParseArgs Expr ExprOperations Expr2 ExprLit

%right ASSIGN
%left OR
%left AND
%left XOR
%left EQ NE
%left GE GT LE LT
%left LSHIFT RSHIFT
%left PLUS MINUS
%left STAR DIV MOD
%right NOT
%left LPAR RPAR LSQ RSQ

%right ELSE

%%

Program:	CLASS ID LBRACE ProgramScript RBRACE					{
	
																	}
		;

ProgramScript: 	/* empty */											{}
			|	MethodDecl ProgramScript							{}
			|	FieldDecl ProgramScript								{}
			|	SEMICOLON ProgramScript								{}
			;

MethodDecl:	PUBLIC STATIC MethodHeader MethodBody					{}
		;

FieldDecl:	PUBLIC STATIC Type ID FieldDecl2 SEMICOLON				{}
		|	error SEMICOLON											{}
		;

FieldDecl2:	/* empty */												{}
		|	COMMA ID FieldDecl2										{}
		;

Type:	BOOL														{}
	|	INT															{}
	|	DOUBLE														{}
	;

MethodHeader:	Type ID LPAR MethodHeader2 RPAR						{}
			|	VOID ID LPAR MethodHeader2 RPAR						{}
			;

MethodHeader2:	/* empty */											{}
			|	FormalParams										{}
			;

FormalParams:	Type ID FormalParams2								{}
			|	STRING LSQ RSQ ID									{}
			;

FormalParams2:	/* empty */											{}
			|	COMMA Type ID FormalParams2 						{}
			;

MethodBody:	LBRACE MethodBody2 RBRACE								{}
		;

MethodBody2: 	/* empty */											{}
			|	Statement MethodBody2								{}
			|	VarDecl MethodBody2									{}
			;

VarDecl:	Type ID VarDecl2 SEMICOLON								{}
		;

VarDecl2:	/* empty */												{}
		|	COMMA ID VarDecl2										{}
		;

Statement:	LBRACE Statement2 RBRACE								{}
		|	IF LPAR Expr RPAR Statement %prec ELSE					{}
		|	IF LPAR Expr RPAR Statement ELSE Statement				{}
		|	WHILE LPAR Expr RPAR Statement							{}
		|	RETURN ExprReturn SEMICOLON								{}
		|	Statement3 SEMICOLON									{}
		|	PRINT LPAR StatementPrint RPAR SEMICOLON				{}
		|	error SEMICOLON											{}
		;

Statement2:	/* empty */												{}
		|	Statement Statement2									{}
		;

ExprReturn:	/* empty */												{}
		|	Expr													{}
		;

Statement3:	/* empty */												{}
		|	MethodInvocation										{}
		|	Assignment												{}
		|	ParseArgs												{}
		;

StatementPrint:	Expr												{}
			|	STRLIT												{}
			;

MethodInvocation:	ID LPAR MethodInvocation2 RPAR					{}
				|	ID LPAR error RPAR								{}
				;

MethodInvocation2:	/* empty */										{}
				|	Expr MethodInvocationExpr						{}
				;

MethodInvocationExpr:	/* empty */									{}
					|	COMMA Expr MethodInvocationExpr				{}
					;

Assignment:	ID ASSIGN Expr											{}
		;

ParseArgs:	PARSEINT LPAR ID LSQ Expr RSQ RPAR						{}
		|	PARSEINT LPAR error RPAR								{}
		;

Expr:	Assignment													{}
	|	ExprOperations												{}
	;

ExprOperations:	ExprOperations PLUS ExprOperations					{}
			|	ExprOperations MINUS ExprOperations					{}
			|	ExprOperations STAR ExprOperations					{}
			|	ExprOperations DIV ExprOperations					{}
			|	ExprOperations MOD ExprOperations					{}
			|	ExprOperations AND ExprOperations					{}
			|	ExprOperations OR ExprOperations					{}
			|	ExprOperations XOR ExprOperations					{}
			|	ExprOperations LSHIFT ExprOperations				{}
			|	ExprOperations RSHIFT ExprOperations				{}
			|	ExprOperations EQ ExprOperations					{}
			|	ExprOperations GE ExprOperations					{}
			|	ExprOperations GT ExprOperations					{}
			|	ExprOperations LE ExprOperations					{}
			|	ExprOperations LT ExprOperations					{}
			|	ExprOperations NE ExprOperations					{}
			|	PLUS ExprOperations %prec NOT						{}
			|	MINUS ExprOperations %prec NOT						{}
			|	NOT ExprOperations									{}
			|	LPAR Expr RPAR										{}
			|	LPAR error RPAR										{}
			|	Expr2												{}
			|	ID													{}
			|	ID DOTLENGTH										{}
			|	ExprLit												{}
	;

Expr2:	MethodInvocation											{}
	|	ParseArgs													{}
	;

ExprLit:	INTLIT													{}
		|	REALLIT													{}
		|	BOOLLIT													{}
		;

%%
