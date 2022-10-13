%{
    //Diogo Ferreira Sobreira   2018294861
    //Rui Alexandre Coelho Tapadinhas   2018283200
%}

id					"_"|"$"|("_"|"$"|[a-z]|[A-Z])([a-z]|[A-Z]|[0-9]|"$"|"_")*

intlit				0|([1-9]+("_"*[0-9]|[0-9])*)
real				([0-9]+("_"*[0-9]|[0-9])*"."[0-9]*("_"*[0-9]|[0-9])*)|([0-9]*("_"*[0-9]|[0-9])*"."[0-9]+("_"*[0-9]|[0-9])*)
expint				[0-9]+("_"*[0-9]|[0-9])*[eE][+-]*[0-9]+("_"*[0-9]|[0-9])*
expreal				([0-9]+("_"*[0-9]|[0-9])*"."([0-9]*("_"*[0-9]|[0-9])*)*)|([0-9]*("_"*[0-9]|[0-9])*"."([0-9]+("_"*[0-9]|[0-9])*)*)[eE][+-]*[0-9]+("_"*[0-9]|[0-9])*

reserved			"++"|"--"|"null"|"Integer"|"System"|"abstract"|"continue"|"new"|"switch"|"assert"|"default"|"package"|"synchronized"|"do"|"goto"|"private"|"this"|"break"|"implements"|"protected"|"throw"|"byte"|"import"|"throws"|"case"|"enum"|"instanceof"|"transient"|"catch"|"extends"|"short"|"try"|"char"|"final"|"interface"|"finally"|"long"|"strictfp"|"volatile"|"const"|"float"|"native"|"super"|"for"

%X COMMENT MULTIPLECOMMENT
%%

{intlit}								{printf("INTLIT(%s)\n",yytext);}

{real}|{expint}|{expreal}				{printf("REALLIT(%s)\n",yytext);}

"true"|"false"					        {printf("BOOLLIT(%s)\n",yytext);}
"&&"							        {printf("AND\n");}
"="								        {printf("ASSIGN\n");}
"*"							            {printf("STAR\n");}
","								        {printf("COMMA\n");}
"/"								        {printf("DIV\n");}
"=="							        {printf("EQ\n");}
">="							        {printf("GE\n");}
">"								        {printf("GT\n");}
"{"								        {printf("LBRACE\n");}
"<="							        {printf("LE\n");}
"("								        {printf("LPAR\n");}
"["								        {printf("LSQ\n");}
"<"								        {printf("LT\n");}
"-"								        {printf("MINUS\n");}
"%"								        {printf("MOD\n");}
"!="							        {printf("NE\n");}
"!"								        {printf("NOT\n");}
"||"							        {printf("OR\n");}
"+"								        {printf("PLUS\n");}
"}"							            {printf("RBRACE\n");}
")"								        {printf("RPAR\n");}
"]"							            {printf("RSQ\n");}
";"								        {printf("SEMICOLON\n");}
"->"							        {printf("ARROW\n");}
"<<"							        {printf("LSHIFT\n");}
">>"							        {printf("RSHIFT\n");}
"^"								        {printf("XOR\n");}
"boolean"						        {printf("BOOL\n");}
"class"							        {printf("CLASS\n");}
".length"						        {printf("DOTLENGTH\n");}
"double"						        {printf("DOUBLE\n");}
"else"							        {printf("ELSE\n");}
"if"							        {printf("IF\n");}
"int"							        {printf("INT\n");}
"System.out.print"				        {printf("PRINT\n");}
"Integer.parseInt"				        {printf("PARSEINT\n");}
"public"						        {printf("PUBLIC\n");}
"return"						        {printf("RETURN\n");}
"static"						        {printf("STATIC\n");}
"String"						        {printf("STRING\n");}
"void"							        {printf("VOID\n");}
"while"							        {printf("WHILE\n");}

{reserved}						        {printf("RESERVED(%s)\n",yytext);}

{id}									{printf("ID(%s)\n",yytext);}

"//"									{BEGIN COMMENT;}
<COMMENT>\n|\r|(\r\n)					{BEGIN 0;}
<COMMENT>.								{;}

"/*"									{BEGIN MULTIPLECOMMENT;}
<MULTIPLECOMMENT>"*/"				    {BEGIN 0;}
<MULTIPLECOMMENT>\n|\r|(\r\n)			{;}
<MULTIPLECOMMENT>.						{;}
<MULTIPLECOMMENT><<EOF>>				{BEGIN 0;}


" "|"\t"|"\f"                           {;}
"\n"|"\r"|"\r""\n"                      {;}
.                                       {;}
%%

int main(int argc, char *argv[]){
  yylex();
  return 0;
}

int yywrap() {
  return 1;
}
