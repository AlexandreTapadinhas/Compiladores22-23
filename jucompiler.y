%{
	
	#include <stdio.h>
	#include <string.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <unistd.h>

	#define YYDEBUG 1

	struct node * root = NULL;
	struct node * aux = NULL;
	int yylex(void);
	int yylex_destroy();
	void yyerror(const char *s);
	extern int debugMode;
	int flag_erro = 0;
	


	typedef struct node
	{
		struct node *children; // list of children of this node
		int number_children;                 // to access the next empty child
		struct node *bro;
		struct node *parent;
		char *type;
		char *value;
	} node;

		// function to create a new node of type "type" and value "value"
	struct node *create_node(char *type, char *value)
	{

		struct node *new = (struct node *)malloc(sizeof(struct node));

		//printf("%s\n",type);

		new->value = value;
		new->type = type;
		new->number_children = 0;
		new->parent = NULL;
		new->children = NULL;
		new->bro = NULL;

		//printf("created new node %s(%s)\n\n", type, value);
		return new;
	}

	// function to add a new child to the node parent, with type "type" and value "value"
	struct node *add_child(struct node *parent, struct node *child)
	{
		struct node *aux;

		if (child == NULL || parent == NULL)
			return NULL;

		parent->children= child;
		parent->number_children++;
		child->parent = parent;

		return parent;
	}

	struct node *add_sibling(struct node *s1, struct node *s2)
	{
		struct node *aux = s1;

		if (aux != NULL && s2 != NULL)
		{
			while (aux->bro != NULL)
			{
				aux = aux->bro;
			}
			aux->bro = s2;
			if (s1->parent != NULL) {
			s2->parent = s1->parent;
			s2->parent->number_children++;
		}
		}
		
		//if(s1!=NULL && s2!=NULL) printf("added %s(%s) and %s(%s) as siblings\n", s1->type, s1->value,s2->type, s2->value);
		return s1;
	}

	// function to get the number of siblings of a given node
	int get_number_siblings(struct node *node)
	{
		int count = 0;
		while (node != NULL) {
			node = node->bro;
			count++;
		}
		return count;
	}

	// function to print the tree in order
	void print_node(struct node *root, int depth)
	{if (root == NULL) {
			return ;
		}
		int i = 0;
		struct node *  aux;
		
			while (i < depth) {
				printf("..");
				i++;
			}
			if (strcmp(root->value,"") != 0) {
				printf("%s(%s)\n", root->type, root->value);
			}
			else {
				printf("%s\n", root->type);
			}
		
		aux = root->children;
		while (aux != NULL) {
			struct node * aux_free = aux;
			print_node(aux, depth+1);
			aux = aux->bro;
		}

	}		

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

																	root = create_node("Program","");
																	aux = create_node("Id",$2);
																	add_child (root, aux);
																	add_sibling (aux, $4);
																	$$ = root;
																	if (debugMode == 2 && flag_erro == 0) {
																		print_node($$, 0);
																	}
																	}
		;

ProgramScript: 	/* empty */											{$$ = NULL;}
			|	MethodDecl ProgramScript							{$$ = $1;
																	add_sibling($$, $2);}
			|	FieldDecl ProgramScript								{$$ = $1;
																	add_sibling($$, $2);}
			|	SEMICOLON ProgramScript								{$$ = $2;}
			;

MethodDecl:	PUBLIC STATIC MethodHeader MethodBody					{$$ = create_node( "MethodDecl","");
																	add_child($$, $3);
																	add_sibling($3, $4);
																	}
		;

FieldDecl:	PUBLIC STATIC Type ID FieldDecl2 SEMICOLON				{$$ = create_node( "FieldDecl", "");
																	add_child($$, $3);
																	add_sibling($3, create_node("Id",$4));
																	if ($5 != NULL){
																		aux = $5;
																		while (aux != NULL) {
																			struct node * aux1 = create_node("FieldDecl","");
																			struct node * aux2 = create_node($3->type, $3->value);
																			add_child(aux1, aux2);
																			add_sibling(aux2, create_node("Id", aux->value));
																			add_sibling($$, aux1);
																			aux = aux->bro;
																		}
																		free(aux);
																	}
																	}
		|	error SEMICOLON											{$$ = NULL; flag_erro = 1;}
		;

FieldDecl2:	/* empty */												{$$ = NULL;}
		|	COMMA ID FieldDecl2										{$$ = create_node("Id", $2);
																	add_sibling($$, $3);}
		;

Type:	BOOL														{$$ = create_node("Bool","");}
	|	INT															{$$ = create_node("Int","");}
	|	DOUBLE														{$$ = create_node("Double","");}
	;

MethodHeader:	Type ID LPAR MethodHeader2 RPAR						{$$ = create_node("MethodHeader", "");
																	add_child($$,$1);
																	add_sibling($1, create_node("Id", $2));
																	aux = create_node("MethodParams", "");
																	add_sibling($1, aux);
																	add_child(aux, $4);}
			|	VOID ID LPAR MethodHeader2 RPAR						{$$ = create_node("MethodHeader", "");
																	aux = create_node("Void", "");
																	add_child($$, aux);
																	add_sibling(aux, create_node("Id", $2));
																	struct node * aux2 = create_node("MethodParams", "");
																	add_sibling(aux, aux2);
																	add_child(aux2, $4);}
			;

MethodHeader2:	/* empty */											{$$ = NULL;}
			|	FormalParams										{$$ = $1;}
			;


FormalParams:	Type ID FormalParams2								{$$ = create_node("ParamDecl","");
																	add_child($$, $1);
																	aux = create_node("Id",$2);
																	add_sibling($1, aux);
																	add_sibling($$, $3);}
			|	STRING LSQ RSQ ID									{$$ = create_node("ParamDecl","");
																	aux = create_node("StringArray","");
																	add_child($$, aux);
																	add_sibling(aux, create_node("Id",$4));}
			;

FormalParams2:	/* empty */											{$$ = NULL;}
			|	COMMA Type ID FormalParams2 						{$$ = create_node("ParamDecl","");
																	aux = create_node("Id",$3);
																	add_child($$, $2);
																	add_sibling($2, aux);
																	add_sibling($$, $4);}
			;

MethodBody:	LBRACE MethodBody2 RBRACE								{$$ = create_node("MethodBody","");
																	add_child($$, $2);}
		;

MethodBody2: 	/* empty */											{$$ = NULL;}
			|	Statement MethodBody2								{if ($1 != NULL){
																		$$ = $1;
																		add_sibling($$, $2);
																		}
																	else {
																		$$ = $2;
																	}}
			|	VarDecl MethodBody2									{$$ = $1;
																	add_sibling($$, $2);}
			;

VarDecl:	Type ID VarDecl2 SEMICOLON								{$$ = create_node("VarDecl", "");
																	add_child($$, $1);
																	add_sibling($1, create_node("Id", $2));
																	if ($3 != NULL){
																		aux = $3;
																		while (aux != NULL) {
																			struct node * aux1 = create_node("VarDecl", "");
																			struct node * aux2 = create_node($1->type, $1->value);
																			add_child(aux1, aux2);
																			add_sibling(aux2, create_node("Id", aux->value));
																			add_sibling($$, aux1);
																			aux = aux->bro;
																		}
																		free(aux);
																	}}
		;

VarDecl2:	/* empty */												{$$ = NULL;}
		|	COMMA ID VarDecl2										{$$ = create_node("Id",$2);
																	add_sibling($$, $3);}
		;

Statement:	LBRACE Statement2 RBRACE								{if ($2 != NULL && get_number_siblings($2) > 1) {
																		aux = create_node("Block","");
																		$$ = aux;
																		add_child(aux, $2);
																	}
																	else {
																		$$ = $2;
																	}}
		|	IF LPAR Expr RPAR Statement %prec ELSE					{$$ = create_node("If","");
																	add_child($$,$3);
																	aux = create_node("Block","");
																	if ($5 != NULL && get_number_siblings($5) == 1 ) {
																		add_sibling($3, $5);
																		add_sibling($5, aux);
																	}
																	else {
																		add_sibling($3, aux);
																		add_child(aux, $5);
																		add_sibling(aux, create_node("Block",""));
																	}}
		|	IF LPAR Expr RPAR Statement ELSE Statement				{$$ = create_node("If","");
																	add_child($$,$3);
																	aux = create_node("Block","");
																	if ($5 != NULL && get_number_siblings($5) == 1 ) {
																		add_sibling($3, $5);
																		if ($7 != NULL && get_number_siblings($7) == 1) {
																			add_sibling($5, $7);
																		}
																		else {
																			add_sibling($5, aux);
																			add_child(aux, $7);
																		}
																	}
																	else {
																		add_sibling($3, aux);
																		add_child(aux, $5);
																		if ($7 != NULL && get_number_siblings($7) == 1 ) {
																			add_sibling(aux, $7);
																		}
																		else {
																			struct node * aux2 = create_node("Block","");
																			add_sibling(aux, aux2);
																			add_child(aux2, $7);
																		}
																	}}
		|	WHILE LPAR Expr RPAR Statement							{$$ = create_node("While","");
																	add_child($$, $3);
																	if ($5 != NULL && get_number_siblings($5) == 1)  {
																		add_sibling($3, $5);
																	}
																	else {
																		aux = create_node("Block","");
																		add_sibling($3, aux);
																		add_child(aux, $5);
																	}}
		|	RETURN ExprReturn SEMICOLON								{$$ = create_node("Return","");
																	add_child($$, $2);}
		|	Statement3 SEMICOLON									{$$ = $1;}
		|	PRINT LPAR StatementPrint RPAR SEMICOLON				{$$ = create_node("Print","");
																	add_child($$, $3);}
		|	error SEMICOLON											{$$ = NULL; flag_erro = 1;}
		;

Statement2:	/* empty */												{$$ = NULL;}
		|	Statement Statement2									{if ($1 != NULL) {
																		$$ = $1;
																		add_sibling($$, $2);
																	}
																	else {
																		$$ = $2;
																	}}
		;

ExprReturn:	/* empty */												{$$ = NULL;}
		|	Expr													{$$ = $1;}
		;

Statement3:	/* empty */												{$$ = NULL;}
		|	MethodInvocation										{$$ = $1;}
		|	Assignment												{$$ = $1;}
		|	ParseArgs												{$$ = $1;}
		;

StatementPrint:	Expr												{$$ = $1;}
			|	STRLIT												{$$ = create_node( "StrLit", $1);}
			;

MethodInvocation:	ID LPAR MethodInvocation2 RPAR					{$$ = create_node("Call","");
																	aux = create_node("Id",$1);
																	add_child($$, aux);
																	if($3 != NULL)add_sibling(aux, $3);}
				|	ID LPAR error RPAR								{$$ = NULL;
																	flag_erro = 1;}
				;

MethodInvocation2:	/* empty */										{$$ = NULL;}
				|	Expr MethodInvocationExpr						{$$ = $1;
																	add_sibling($$, $2);}
				;

MethodInvocationExpr:	/* empty */									{$$ = NULL;}
					|	COMMA Expr MethodInvocationExpr				{if($2!=NULL) {
																		$$=$2;
																		add_sibling($$, $3);
																	}
																	else {
																		$$=$2;
																	}}
					;

Assignment:	ID ASSIGN Expr											{$$ = create_node("Assign","");
																	aux = create_node("Id",$1);
																	add_child($$, aux);
																	add_sibling(aux, $3);}
		;

ParseArgs:	PARSEINT LPAR ID LSQ Expr RSQ RPAR						{$$ = create_node("ParseArgs","");
																	aux = create_node("Id",$3);
																	add_child($$, aux);
																	add_sibling(aux, $5);}
		|	PARSEINT LPAR error RPAR								{$$ = NULL;
																	flag_erro = 1;}
		;

Expr:	Assignment													{$$ = $1;}
	|	ExprOperations												{$$ = $1;}
	;

ExprOperations:	ExprOperations PLUS ExprOperations					{$$ = create_node("Add", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations MINUS ExprOperations					{$$ = create_node("Sub", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations STAR ExprOperations					{$$ = create_node("Mul", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations DIV ExprOperations					{$$ = create_node("Div", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations MOD ExprOperations					{$$ = create_node("Mod", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations AND ExprOperations					{$$ = create_node("And", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations OR ExprOperations					{$$ = create_node("Or", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations XOR ExprOperations					{$$ = create_node("Xor", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations LSHIFT ExprOperations				{$$ = create_node("Lshift", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations RSHIFT ExprOperations				{$$ = create_node("Rshift", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations EQ ExprOperations					{$$ = create_node("Eq", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations GE ExprOperations					{$$ = create_node("Ge", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations GT ExprOperations					{$$ = create_node("Gt", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations LE ExprOperations					{$$ = create_node("Le", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations LT ExprOperations					{$$ = create_node("Lt", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	ExprOperations NE ExprOperations					{$$ = create_node("Ne", "");
																	add_child($$, $1);
																	add_sibling($1, $3);}
			|	PLUS ExprOperations %prec NOT						{$$ = create_node("Plus", "");
																	add_child($$, $2);}
			|	MINUS ExprOperations %prec NOT						{$$ = create_node("Minus", "");
																	add_child($$, $2);}
			|	NOT ExprOperations									{$$ = create_node("Not", "");
																	add_child($$, $2);}
			|	LPAR Expr RPAR										{$$ = $2;}
			|	LPAR error RPAR										{$$ = NULL;
																	flag_erro = 1;}
			|	Expr2												{$$ = $1;}
			|	ID													{$$ = create_node("Id", $1);}
			|	ID DOTLENGTH										{$$ = create_node("Length", "");
																	add_child($$, create_node("Id", $1));}
			|	ExprLit												{$$ = $1;}
	;

Expr2:	MethodInvocation											{$$ = $1;}
	|	ParseArgs													{$$ = $1;}
	;

ExprLit:	INTLIT													{$$ = create_node("DecLit", $1);}
		|	REALLIT													{$$ = create_node("RealLit", $1);}
		|	BOOLLIT													{$$ = create_node("BoolLit", $1);}
		;

%%
