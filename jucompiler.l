%{
    //Diogo Ferreira Sobreira   2018294861
    //Rui Alexandre Coelho Tapadinhas   2018283200

    #include <string.h>
    
    int line = 1;
    int col = 1;
    int error_line = 1;
    int error_col = 1;
    int strlit_error = 0;
    char strlit[1024];

%}

id					"_"|"$"|("_"|"$"|[a-z]|[A-Z])([a-z]|[A-Z]|[0-9]|"$"|"_")*

intlit				0|([1-9]+("_"*[0-9]|[0-9])*)
real				([0-9]+("_"*[0-9]|[0-9])*"."[0-9]*("_"*[0-9]|[0-9])*)|([0-9]*("_"*[0-9]|[0-9])*"."[0-9]+("_"*[0-9]|[0-9])*)
expint				[0-9]+("_"*[0-9]|[0-9])*[eE][+-]*[0-9]+("_"*[0-9]|[0-9])*
expreal				([0-9]+("_"*[0-9]|[0-9])*"."([0-9]*("_"*[0-9]|[0-9])*)*)|([0-9]*("_"*[0-9]|[0-9])*"."([0-9]+("_"*[0-9]|[0-9])*)*)[eE][+-]*[0-9]+("_"*[0-9]|[0-9])*

strlit				([^\n\r\\"]|\\f|\\n|\\r|\\t|\\\\|\\\")*

reserved			"++"|"--"|"null"|"Integer"|"System"|"abstract"|"continue"|"new"|"switch"|"assert"|"default"|"package"|"synchronized"|"do"|"goto"|"private"|"this"|"break"|"implements"|"protected"|"throw"|"byte"|"import"|"throws"|"case"|"enum"|"instanceof"|"transient"|"catch"|"extends"|"short"|"try"|"char"|"final"|"interface"|"finally"|"long"|"strictfp"|"volatile"|"const"|"float"|"native"|"super"|"for"
illegal				"."|"#"

%X COMMENT MULTIPLECOMMENT STRLIT
%%

{intlit}								{printf("INTLIT(%s)\n",yytext);col+=yyleng;}

{real}|{expint}|{expreal}				{printf("REALLIT(%s)\n",yytext);col+=yyleng;}

{illegal}								{printf("Line %d, col %d: illegal character (%s)\n", line, col, yytext); col+=yyleng;}

"true"|"false"					    {printf("BOOLLIT(%s)\n",yytext);col+=yyleng;}
"&&"							          {printf("AND\n");col+=yyleng;}
"="								          {printf("ASSIGN\n");col+=yyleng;}
"*"							            {printf("STAR\n");col+=yyleng;}
","								          {printf("COMMA\n");col+=yyleng;}
"/"								          {printf("DIV\n");col+=yyleng;}
"=="							          {printf("EQ\n");col+=yyleng;}
">="							          {printf("GE\n");col+=yyleng;}
">"								          {printf("GT\n");col+=yyleng;}
"{"								          {printf("LBRACE\n");col+=yyleng;}
"<="							          {printf("LE\n");col+=yyleng;}
"("								          {printf("LPAR\n");col+=yyleng;}
"["								          {printf("LSQ\n");col+=yyleng;}
"<"								          {printf("LT\n");col+=yyleng;}
"-"								          {printf("MINUS\n");col+=yyleng;}
"%"								          {printf("MOD\n");col+=yyleng;}
"!="							          {printf("NE\n");col+=yyleng;}
"!"								          {printf("NOT\n");col+=yyleng;}
"||"							          {printf("OR\n");col+=yyleng;}
"+"								          {printf("PLUS\n");col+=yyleng;}
"}"							            {printf("RBRACE\n");col+=yyleng;}
")"								          {printf("RPAR\n");col+=yyleng;}
"]"							            {printf("RSQ\n");}
";"								          {printf("SEMICOLON\n");col+=yyleng;}
"->"							          {printf("ARROW\n");col+=yyleng;}
"<<"							          {printf("LSHIFT\n");col+=yyleng;}
">>"							          {printf("RSHIFT\n");col+=yyleng;}
"^"								          {printf("XOR\n");col+=yyleng;}
"boolean"						        {printf("BOOL\n");col+=yyleng;}
"class"							        {printf("CLASS\n");col+=yyleng;}
".length"						        {printf("DOTLENGTH\n");col+=yyleng;}
"double"						        {printf("DOUBLE\n");col+=yyleng;}
"else"							        {printf("ELSE\n");col+=yyleng;}
"if"							          {printf("IF\n");col+=yyleng;}
"int"							          {printf("INT\n");col+=yyleng;}
"System.out.print"				  {printf("PRINT\n");col+=yyleng;}
"Integer.parseInt"				  {printf("PARSEINT\n");col+=yyleng;}
"public"						        {printf("PUBLIC\n");col+=yyleng;}
"return"						        {printf("RETURN\n");col+=yyleng;}
"static"						        {printf("STATIC\n");col+=yyleng;}
"String"						        {printf("STRING\n");col+=yyleng;}
"void"							        {printf("VOID\n");col+=yyleng;}
"while"							        {printf("WHILE\n");col+=yyleng;}

{reserved}						      {printf("RESERVED(%s)\n",yytext);col+=yyleng;}

{id}									      {printf("ID(%s)\n",yytext);col+=yyleng;}

"//"									      {BEGIN COMMENT; error_col=col; error_line=line; col+=yyleng;}
<COMMENT>\n|\r|(\r\n)				{BEGIN 0;col=1;line++;}
<COMMENT><<EOF>>				    {BEGIN 0;col+=yyleng;}
<COMMENT>.								  {col+=yyleng;}

"/*"									          {BEGIN MULTIPLECOMMENT; error_col=col; error_line=line; col+=yyleng;}
<MULTIPLECOMMENT>"*/"				    {BEGIN 0;col+=yyleng;}
<MULTIPLECOMMENT>\n|\r|(\r\n)		{col=1;line++;}
<MULTIPLECOMMENT>.						  {col+=yyleng;}
<MULTIPLECOMMENT><<EOF>>				{printf("Line %d, col %d: unterminated comment\n", error_line, error_col); BEGIN 0;col+=yyleng;}

"\""									      {BEGIN STRLIT; error_col=col; error_line=line; col+=yyleng;}
<STRLIT>{strlit}						{strcpy(strlit, yytext); col+=yyleng;}
<STRLIT>\\(.?)							{printf("Line %d, col %d: invalid escape sequence (%s)\n",error_line, col, yytext); strlit_error = 1; col+=yyleng;}
<STRLIT>\"								  {BEGIN 0; if (!strlit_error) {strcat(strlit, yytext); printf("STRLIT(\"%s)\n", strlit);} strlit_error = 0; col+=yyleng;}



" "|"\t"|"\f"               {col+=yyleng;}
"\n"|"\r"|"\r\n"            {col=1;line++;}
.                           {col+=yyleng;}
%%

int main(int argc, char *argv[]){
  yylex();
  return 0;
}

int yywrap() {
  return 1;
}
