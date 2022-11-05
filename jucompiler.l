%{
    //Diogo Ferreira Sobreira   2018294861
    //Rui Alexandre Coelho Tapadinhas   2018283200
    #include "y.tab.h"
	#include <stdio.h>
	YYSTYPE yylval;
	//int yylex(void);
  	void yyerror(const char* s);


    int line = 1;
    int col = 1;
    int auxLine = 1;
    int auxCol = 1;
    int strlit_error = 0;
	extern int flag_erro;
    int debugMode;
    char * strlit;

%}

id					"_"|"$"|("_"|"$"|[a-z]|[A-Z])([a-z]|[A-Z]|[0-9]|"$"|"_")*

intlit				0|([1-9]+("_"*[0-9]|[0-9])*)
num           [0-9]
under         {num}([{num}"_"]*{num})*
expo          ["e""E"]("+"|"-")?{under}+ 
REALIT        ({under}"."({under}|{expo}|{under}{expo})?)|{under}{expo}|"."{under}{expo}?

strlit				([^\n\r\"\\]|\\f|\\n|\\r|\\t|\\\\|\\\")*

reserved			"++"|"--"|"null"|"Integer"|"System"|"abstract"|"continue"|"new"|"switch"|"assert"|"default"|"package"|"synchronized"|"do"|"goto"|"private"|"this"|"break"|"implements"|"protected"|"throw"|"byte"|"import"|"throws"|"case"|"enum"|"instanceof"|"transient"|"catch"|"extends"|"short"|"try"|"char"|"final"|"interface"|"finally"|"long"|"strictfp"|"volatile"|"const"|"float"|"native"|"super"|"for"

%X COMMENT MULTIPLECOMMENT STRLIT_ST
%%

{intlit}								{if(!debugMode)printf("INTLIT(%s)\n",yytext);col+=yyleng; if(debugMode != 1){yylval.intlit = strdup(yytext); return INTLIT;}}

{REALIT}				{if(!debugMode)printf("REALLIT(%s)\n",yytext);col+=yyleng; if(debugMode != 1){yylval.reallit = strdup(yytext); return REALLIT;}}


"true"|"false"					    {if(!debugMode)printf("BOOLLIT(%s)\n",yytext);col+=yyleng; if(debugMode != 1){yylval.boollit = strdup(yytext); return BOOLLIT;}}
"&&"							          {if(!debugMode)printf("AND\n");col+=yyleng; if(debugMode != 1)return AND;}
"="								          {if(!debugMode)printf("ASSIGN\n");col+=yyleng; if(debugMode != 1)return ASSIGN;}
"*"							            {if(!debugMode)printf("STAR\n");col+=yyleng; if(debugMode != 1)return STAR;}
","								          {if(!debugMode)printf("COMMA\n");col+=yyleng; if(debugMode != 1)return COMMA;}
"/"								          {if(!debugMode)printf("DIV\n");col+=yyleng; if(debugMode != 1)return DIV;}
"=="							          {if(!debugMode)printf("EQ\n");col+=yyleng; if(debugMode != 1)return EQ;}
">="							          {if(!debugMode)printf("GE\n");col+=yyleng; if(debugMode != 1)return GE;}
">"								          {if(!debugMode)printf("GT\n");col+=yyleng; if(debugMode != 1)return GT;}
"{"								          {if(!debugMode)printf("LBRACE\n");col+=yyleng; if(debugMode != 1)return LBRACE;}
"<="							          {if(!debugMode)printf("LE\n");col+=yyleng; if(debugMode != 1)return LE;}
"("								          {if(!debugMode)printf("LPAR\n");col+=yyleng; if(debugMode != 1)return LPAR;}
"["								          {if(!debugMode)printf("LSQ\n");col+=yyleng; if(debugMode != 1)return LSQ;}
"<"								          {if(!debugMode)printf("LT\n");col+=yyleng;  if(debugMode != 1)return LT;}
"-"								          {if(!debugMode)printf("MINUS\n");col+=yyleng; if(debugMode != 1)return MINUS;}
"%"								          {if(!debugMode)printf("MOD\n");col+=yyleng; if(debugMode != 1)return MOD;}
"!="							          {if(!debugMode)printf("NE\n");col+=yyleng;  if(debugMode != 1)return NE;}
"!"								          {if(!debugMode)printf("NOT\n");col+=yyleng; if(debugMode != 1)return NOT;}
"||"							          {if(!debugMode)printf("OR\n");col+=yyleng; if(debugMode != 1)return OR;}
"+"								          {if(!debugMode)printf("PLUS\n");col+=yyleng; if(debugMode != 1)return PLUS;}
"}"							            {if(!debugMode)printf("RBRACE\n");col+=yyleng; if(debugMode != 1)return RBRACE;}
")"								          {if(!debugMode)printf("RPAR\n");col+=yyleng; if(debugMode != 1)return RPAR;}
"]"							            {if(!debugMode)printf("RSQ\n");col+=yyleng; if(debugMode != 1)return RSQ;}
";"								          {if(!debugMode)printf("SEMICOLON\n");col+=yyleng; if(debugMode != 1)return SEMICOLON;}
"->"							          {if(!debugMode)printf("ARROW\n");col+=yyleng; if(debugMode != 1)return ARROW;}
"<<"							          {if(!debugMode)printf("LSHIFT\n");col+=yyleng; if(debugMode != 1)return LSHIFT;}
">>"							          {if(!debugMode)printf("RSHIFT\n");col+=yyleng; if(debugMode != 1)return RSHIFT;}
"^"								          {if(!debugMode)printf("XOR\n");col+=yyleng;  if(debugMode != 1)return XOR;}
"boolean"						        {if(!debugMode)printf("BOOL\n");col+=yyleng; if(debugMode != 1)return BOOL;}
"class"							        {if(!debugMode)printf("CLASS\n");col+=yyleng; if(debugMode != 1)return CLASS;}
".length"						        {if(!debugMode)printf("DOTLENGTH\n");col+=yyleng; if(debugMode != 1)return DOTLENGTH;}
"double"						        {if(!debugMode)printf("DOUBLE\n");col+=yyleng; if(debugMode != 1)return DOUBLE;}
"else"							        {if(!debugMode)printf("ELSE\n");col+=yyleng; if(debugMode != 1)return ELSE;}
"if"							          {if(!debugMode)printf("IF\n");col+=yyleng; if(debugMode != 1)return IF;}
"int"							          {if(!debugMode)printf("INT\n");col+=yyleng; if(debugMode != 1)return INT;}
"System.out.print"				  {if(!debugMode)printf("PRINT\n");col+=yyleng; if(debugMode != 1)return PRINT;}
"Integer.parseInt"				  {if(!debugMode)printf("PARSEINT\n");col+=yyleng; if(debugMode != 1)return PARSEINT;}
"public"						        {if(!debugMode)printf("PUBLIC\n");col+=yyleng; if(debugMode != 1)return PUBLIC;}
"return"						        {if(!debugMode)printf("RETURN\n");col+=yyleng; if(debugMode != 1)return RETURN;}
"static"						        {if(!debugMode)printf("STATIC\n");col+=yyleng; if(debugMode != 1)return STATIC;}
"String"						        {if(!debugMode)printf("STRING\n");col+=yyleng; if(debugMode != 1)return STRING;}
"void"							        {if(!debugMode)printf("VOID\n");col+=yyleng; if(debugMode != 1)return VOID;}
"while"							        {if(!debugMode)printf("WHILE\n");col+=yyleng; if(debugMode != 1)return WHILE;}

{reserved}						      {if(!debugMode)printf("RESERVED(%s)\n",yytext);col+=yyleng; if(debugMode != 1)return RESERVED;}


" "|"\t"|"\f"               {col+=yyleng;}
"\n"|"\r"|"\r\n"            {col=1;line++;}

{id}									      {if(!debugMode)printf("ID(%s)\n",yytext);col+=yyleng; if(debugMode != 1){yylval.id = strdup(yytext); return ID;}}




"//"									      {BEGIN COMMENT;col+=yyleng;}
<COMMENT>\n|\r|(\r\n)				{BEGIN 0;col=1;line++;}
<COMMENT>.								  {;}

"/*"									          {BEGIN MULTIPLECOMMENT; auxCol=col; auxLine=line; col+=yyleng;}
<MULTIPLECOMMENT>\n|\r|(\r\n)		{col=1;line++;}
<MULTIPLECOMMENT>"*/"				    {col+=yyleng;BEGIN 0;}
<MULTIPLECOMMENT>.						  {col+=yyleng;}
<MULTIPLECOMMENT><<EOF>>				{printf("Line %d, col %d: unterminated comment\n", auxLine, auxCol);col+=yyleng;BEGIN 0;}

\"										      {BEGIN STRLIT_ST; strlit_error = 0; strlit = yytext; col+=yyleng; auxCol=col-1;}
<STRLIT_ST>\"								  {if(!debugMode && !strlit_error)printf("STRLIT(%s)\n",strlit);col+=yyleng; BEGIN 0; if(debugMode != 1){yylval.strlit = strdup(yytext); return STRLIT;}}
<STRLIT_ST><<EOF>>							{printf("Line %d, col %d: unterminated string literal\n",line,auxCol); col+=yyleng; BEGIN 0;}
<STRLIT_ST>\n|\r|(\r\n)				{col= 1; printf("Line %d, col %d: unterminated string literal\n",line,auxCol); line++; BEGIN 0;}
<STRLIT_ST>\\[^nfr\\t\r\n\"]?	{printf("Line %d, col %d: invalid escape sequence (%s)\n",line,col, yytext); col += yyleng;strlit_error = 1;}
<STRLIT_ST>{strlit}						{col+=yyleng;}

.									        {printf("Line %d, col %d: illegal character (%s)\n", line, col, yytext); col+=yyleng;}

%%

int main(int argc, char *argv[]){
    if (argc > 1) {
		if (strcmp(argv[1],"-l") == 0) {
			debugMode = 1;
			yylex();
		}
		else if (strcmp(argv[1],"-t") == 0) {
			debugMode = 2;
			yyparse();
		}
		else if (strcmp(argv[1], "-e1") == 0) {
			debugMode = 0;
			while (yylex() != 0) {
				;
			}
		}
		else if (strcmp(argv[1], "-e2") == 0) {
			debugMode = 0;
			yyparse();
			yylex();
		}
	}
	else {
		debugMode = 0;
		yyparse();
		yylex();
	}
}

int yywrap() {
    return 1;
}

void yyerror (const char* s) { 
	printf ("%s: %s\n", s, yytext);
}