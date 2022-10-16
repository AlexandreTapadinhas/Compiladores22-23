%{
    //Diogo Ferreira Sobreira   2018294861
    //Rui Alexandre Coelho Tapadinhas   2018283200
    #include <stdio.h>

    int line = 1;
    int col = 1;
    int auxLine = 1;
    int auxCol = 1;
    int strlit_error = 0;
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

%X COMMENT MULTIPLECOMMENT STRLIT
%%

{intlit}								{if(!debugMode)printf("INTLIT(%s)\n",yytext);col+=yyleng;}

{REALIT}				{if(!debugMode)printf("REALLIT(%s)\n",yytext);col+=yyleng;}


"true"|"false"					    {if(!debugMode)printf("BOOLLIT(%s)\n",yytext);col+=yyleng;}
"&&"							          {if(!debugMode)printf("AND\n");col+=yyleng;}
"="								          {if(!debugMode)printf("ASSIGN\n");col+=yyleng;}
"*"							            {if(!debugMode)printf("STAR\n");col+=yyleng;}
","								          {if(!debugMode)printf("COMMA\n");col+=yyleng;}
"/"								          {if(!debugMode)printf("DIV\n");col+=yyleng;}
"=="							          {if(!debugMode)printf("EQ\n");col+=yyleng;}
">="							          {if(!debugMode)printf("GE\n");col+=yyleng;}
">"								          {if(!debugMode)printf("GT\n");col+=yyleng;}
"{"								          {if(!debugMode)printf("LBRACE\n");col+=yyleng;}
"<="							          {if(!debugMode)printf("LE\n");col+=yyleng;}
"("								          {if(!debugMode)printf("LPAR\n");col+=yyleng;}
"["								          {if(!debugMode)printf("LSQ\n");col+=yyleng;}
"<"								          {if(!debugMode)printf("LT\n");col+=yyleng;}
"-"								          {if(!debugMode)printf("MINUS\n");col+=yyleng;}
"%"								          {if(!debugMode)printf("MOD\n");col+=yyleng;}
"!="							          {if(!debugMode)printf("NE\n");col+=yyleng;}
"!"								          {if(!debugMode)printf("NOT\n");col+=yyleng;}
"||"							          {if(!debugMode)printf("OR\n");col+=yyleng;}
"+"								          {if(!debugMode)printf("PLUS\n");col+=yyleng;}
"}"							            {if(!debugMode)printf("RBRACE\n");col+=yyleng;}
")"								          {if(!debugMode)printf("RPAR\n");col+=yyleng;}
"]"							            {if(!debugMode)printf("RSQ\n");col+=yyleng;}
";"								          {if(!debugMode)printf("SEMICOLON\n");col+=yyleng;}
"->"							          {if(!debugMode)printf("ARROW\n");col+=yyleng;}
"<<"							          {if(!debugMode)printf("LSHIFT\n");col+=yyleng;}
">>"							          {if(!debugMode)printf("RSHIFT\n");col+=yyleng;}
"^"								          {if(!debugMode)printf("XOR\n");col+=yyleng;}
"boolean"						        {if(!debugMode)printf("BOOL\n");col+=yyleng;}
"class"							        {if(!debugMode)printf("CLASS\n");col+=yyleng;}
".length"						        {if(!debugMode)printf("DOTLENGTH\n");col+=yyleng;}
"double"						        {if(!debugMode)printf("DOUBLE\n");col+=yyleng;}
"else"							        {if(!debugMode)printf("ELSE\n");col+=yyleng;}
"if"							          {if(!debugMode)printf("IF\n");col+=yyleng;}
"int"							          {if(!debugMode)printf("INT\n");col+=yyleng;}
"System.out.print"				  {if(!debugMode)printf("PRINT\n");col+=yyleng;}
"Integer.parseInt"				  {if(!debugMode)printf("PARSEINT\n");col+=yyleng;}
"public"						        {if(!debugMode)printf("PUBLIC\n");col+=yyleng;}
"return"						        {if(!debugMode)printf("RETURN\n");col+=yyleng;}
"static"						        {if(!debugMode)printf("STATIC\n");col+=yyleng;}
"String"						        {if(!debugMode)printf("STRING\n");col+=yyleng;}
"void"							        {if(!debugMode)printf("VOID\n");col+=yyleng;}
"while"							        {if(!debugMode)printf("WHILE\n");col+=yyleng;}

{reserved}						      {if(!debugMode)printf("RESERVED(%s)\n",yytext);col+=yyleng;}


" "|"\t"|"\f"               {col+=yyleng;}
"\n"|"\r"|"\r\n"            {col=1;line++;}

{id}									      {if(!debugMode)printf("ID(%s)\n",yytext);col+=yyleng;}




"//"									      {BEGIN COMMENT;col+=yyleng;}
<COMMENT>\n|\r|(\r\n)				{BEGIN 0;col=1;line++;}
<COMMENT>.								  {;}

"/*"									          {BEGIN MULTIPLECOMMENT; auxCol=col; auxLine=line; col+=yyleng;}
<MULTIPLECOMMENT>\n|\r|(\r\n)		{col=1;line++;}
<MULTIPLECOMMENT>"*/"				    {col+=yyleng;BEGIN 0;}
<MULTIPLECOMMENT>.						  {col+=yyleng;}
<MULTIPLECOMMENT><<EOF>>				{printf("Line %d, col %d: unterminated comment\n", auxLine, auxCol);col+=yyleng;BEGIN 0;}

\"										      {BEGIN STRLIT; strlit_error = 0; strlit = yytext; col+=yyleng; auxCol=col-1;}
<STRLIT>\"								  {if(!debugMode && !strlit_error)printf("STRLIT(%s)\n",strlit);col+=yyleng; BEGIN 0;}
<STRLIT><<EOF>>							{printf("Line %d, col %d: unterminated string literal\n",line,auxCol); col+=yyleng; BEGIN 0;}
<STRLIT>\n|\r|(\r\n)				{col= 1; printf("Line %d, col %d: unterminated string literal\n",line,auxCol); line++; BEGIN 0;}
<STRLIT>\\[^nfr\\t\r\n\"]?	{printf("Line %d, col %d: invalid escape sequence (%s)\n",line,col, yytext); col += yyleng;strlit_error = 1;}
<STRLIT>{strlit}						{col+=yyleng;}

.									        {printf("Line %d, col %d: illegal character (%s)\n", line, col, yytext); col+=yyleng;}

%%

int main(int argc, char *argv[]){
  if (argc > 1) {
		if (strcmp(argv[1],"-l") == 0) {
			debugMode = 0;
		}
		else if(strcmp(argv[1],"-e1") == 0) {
			debugMode = 1;
		}
	}
	else if (argc == 1){
		debugMode = 1;
	}
  yylex();
  return 0;
}

int yywrap() {
  return 1;
}
