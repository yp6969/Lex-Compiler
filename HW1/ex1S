%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void printTok(int token, FILE* yyout2);
char* changeEnding(char* filename,char* newend);
int sleTypeCheck(const char* str);

int countLine = 0;
typedef enum{START=1, DO, ELSE, IF, ENDI, INT,PUT, PROG, 
            GET, REAL, THEN, VAR, LOOP ,ENDL, UNTIL, ENDP,
			SEP, ID, NUM, RELOP, LOGOP, ADDOP, MULOP, ASSIGNOP,
            LETTER, DIGIT} tok; 

%}
LETTER          [a-zA-Z]
DIGIT           [0-9]
ID              [{LETTER}][{LETTER}|{DIGIT}]*
NUM             [{DIGIT}]+|[{DIGIT}]*("."[{DIGIT}]+)
LINE 			\n
%x comment
%%

"/*"		                BEGIN comment;
<comment>"*/"	            BEGIN INITIAL;
<comment>.|\n	            ;
start                       {ECHO;return START;}
do                          {ECHO;return DO;}
else                        {ECHO;return ELSE;}
if                          {ECHO;return IF;}
endi                        {ECHO;return ENDI;}
int                         {ECHO;return INT;}
put                         {ECHO;return PUT;}
prog                        {ECHO;return PROG;}
get                         {ECHO;return GET;}
real                        {ECHO;return REAL;}
then                        {ECHO;return THEN;}
var                         {ECHO;return VAR;}
loop                        {ECHO;return LOOP;}
endl                        {ECHO;return ENDL;}
until                       {ECHO;return UNTIL;}
endp                        {ECHO;return ENDP;}
","|";"|"."|"("|")"|":"		{ECHO;return SEP;}
"<"|">"|"<>"|"="            {ECHO;return RELOP;}
"&"|"~"|"!"                 {ECHO;return LOGOP;}
"+"|"-"                     {ECHO;return ADDOP;}
"*"|"/"|"mod"               {ECHO;return MULOP;}
"<="                        {ECHO;return ASSIGNOP;}
^{LETTER}                   {fprintf(yyout,"%d: ",countLine);countLine++;ECHO;return LETTER;}
{LETTER}                    {ECHO;return LETTER;}
^{DIGIT}                    {fprintf(yyout,"%d: ",countLine);countLine++;ECHO;return DIGIT;}
{DIGIT}                     {ECHO;return DIGIT;}
^{ID}                       {fprintf(yyout,"%d: ",countLine);countLine++;ECHO;return ID;}
{ID}                        {ECHO;return ID;}
^{NUM}                      {fprintf(yyout,"%d: ",countLine);countLine++;ECHO;return NUM;}
{NUM}                       {ECHO;return NUM;}
{LINE}						{ ECHO;fprintf(yyout,"%d ",++countLine);}
" "|\t						{ECHO;}
.							{fprintf(yyout,"Error: %s not defined\n",yytext);}

%%

int main(int argc, char** argv)
{
  int token;
  FILE* yyout2;
    if(argc < 1){
      fprintf(stderr, "%s", "No file received!\n");
      exit(0);
    }

    if(sleTypeCheck(argv[1])){
        yyin = fopen(argv[1],"r");
        if(yyin == NULL){
          fprintf(stderr, "%s", "File open failed!\n");
          exit(1);
        }
        yyout = fopen(changeEnding(argv[1],"lst"),"w");
		fprintf(yyout,"%d ",++countLine);
        yyout2 = fopen(changeEnding(argv[1], "tok"),"w");
    }
    else{
      fprintf(stderr, "%s", "The file type needs to be .sle!\n");
      exit(2);
    }

    while( token = yylex()){
      printTok(token, yyout2);
    }
  return 0;
}

void printTok(int token, FILE* yyout2) 
{
  switch(token)
  {
  case START:
		fprintf(yyout2,"%s\t\tSTART\n",yytext);
		break;
  case DO:
		fprintf(yyout2,"%s\t\tDO\n",yytext);
		break;
	case ELSE:
		fprintf(yyout2,"%s\t\tELSE\n",yytext);
		break;
	case IF:
		fprintf(yyout2,"%s\t\tIF\n",yytext);
		break;
	case ENDI:
		fprintf(yyout2,"%s\t\tENDI\n",yytext);
		break;
	case INT:
		fprintf(yyout2,"%s\t\tINT\n",yytext);
		break;
  case PUT:
		fprintf(yyout2,"%s\t\tPUT\n",yytext);
		break;
	case PROG:
		fprintf(yyout2,"%s\t\tPROG\n",yytext);
		break;
  case GET:
		fprintf(yyout2,"%s\t\tGET\n",yytext);
		break;
  case REAL:
		fprintf(yyout2,"%s\t\tREAL\n",yytext);
		break;
	case THEN:
		fprintf(yyout2,"%s\t\tTHEN\n",yytext);
		break;
	case VAR:
		fprintf(yyout2,"%s\t\tVAR\n",yytext);
		break;
	case LOOP:
		fprintf(yyout2,"%s\t\tLOOP\n",yytext);
		break;
	case ENDL:
		fprintf(yyout2,"%s\t\tENDL\n",yytext);
		break;
  case UNTIL:
		fprintf(yyout2,"%s\t\tUNTIL\n",yytext);
		break;
	case ENDP:
		fprintf(yyout2,"%s\t\tENDP\n",yytext);
		break;
  case SEP:
		fprintf(yyout2,"%s\t\tSEP\n",yytext);
		break;
	case ID:
		fprintf(yyout2,"%s\t\tID\n",yytext);
		break;
  case NUM:
		fprintf(yyout2,"%s\t\tNUM\n",yytext);
		break;
  case RELOP:
		fprintf(yyout2,"%s\t\tRELOP\n",yytext);
		break;
	case LOGOP:
		fprintf(yyout2,"%s\t\tLOGOP\n",yytext);
		break;
	case ADDOP:
		fprintf(yyout2,"%s\t\tADDOP\n",yytext);
		break;
	case MULOP:
		fprintf(yyout2,"%s\t\tMULOP\n",yytext);
		break;
	case ASSIGNOP:
		fprintf(yyout2,"%s\t\tASSIGNOP\n",yytext);
		break;
  case LETTER:
		fprintf(yyout2,"%s\t\tLETTER\n",yytext);
		break;
	case DIGIT:
		fprintf(yyout2,"%s\t\tDIGIT\n",yytext);
		break;
  }
}

char* changeEnding(char* filename,char* newend)
{
  int length = strlen(filename);
  char* str = malloc(sizeof(char)*length);
  str = strdup(filename);
  str[length-3] = newend[0];
  str[length-2] = newend[1];
  str[length-1] = newend[2];

  return str;
}

int sleTypeCheck(const char* str)
{
    int length = strlen(str);

    if(str[length-3] == 'S' && str[length-2] == 'L' && str[length-1] == 'E'){
      return 1;
    }

    if(str[length-3] == 's' && str[length-2] == 'l' && str[length-1] == 'e'){
      return 1;
    }
    return 0;
}

int yywrap()
{
	return 1;
}
