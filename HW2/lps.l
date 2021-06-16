%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lps_tab.h"

#define FILE_CHEK(file){\
        if(file == NULL){\
            fprintf(stderr, "%s", "File open failed!\n");\
            exit(1);\
        }\
    }

void printTok(int token, FILE* yyout_tok);
int fileNameCheck(char* fileName);
char* modifyFileName(char* fileName, char* change);


int cnt_line = 1;
int cnt_column = 1;

// typedef enum{START=1, DO, ELSE, IF, ENDI, INT,PUT, PROG,                    // Built in tokens
//             GET, REAL, THEN, VAR, LOOP ,ENDL, UNTIL, ENDP,
// 			DOT, SEMICOL, COLON, COMMA, LBAR, RBAR,                            // Seperators
//             ID, NUM, RELOP, LOGOP, ADDOP, MULOP, ASSIGNOP, LETTER, DIGIT    // Regular tokens
//             } tok;

%}

LETTER          [a-zA-Z]
DIGIT           [0-9]
ID              {LETTER}({LETTER}|{DIGIT})*
NUM             ({DIGIT}+)|({DIGIT}*("."{DIGIT}+))
WS              [ \t]+
LINE 			\n
%x comment


%%

"/*"		                BEGIN comment;
<comment>"*/"	            BEGIN INITIAL;
<comment>.|\n	            ;
start                       {ECHO; cnt_column+=yyleng; return START;}
do                          {ECHO; cnt_column+=yyleng; return DO;}
else                        {ECHO; cnt_column+=yyleng; return ELSE;}
if                          {ECHO; cnt_column+=yyleng; return IF;}
endi                        {ECHO; cnt_column+=yyleng; return ENDI;}
int                         {ECHO; cnt_column+=yyleng; return INT;}
put                         {ECHO; cnt_column+=yyleng; return PUT;}
prog                        {ECHO; cnt_column+=yyleng; return PROG;}
get                         {ECHO; cnt_column+=yyleng; return GET;}
real                        {ECHO; cnt_column+=yyleng; return REAL;}
then                        {ECHO; cnt_column+=yyleng; return THEN;}
var                         {ECHO; cnt_column+=yyleng; return VAR;}
loop                        {ECHO; cnt_column+=yyleng; return LOOP;}
endl                        {ECHO; cnt_column+=yyleng; return ENDL;}
until                       {ECHO; cnt_column+=yyleng; return UNTIL;}
endp                        {ECHO; cnt_column+=yyleng; return ENDP;}

"."                         {ECHO; cnt_column+=yyleng; return DOT;}
";"                         {ECHO; cnt_column+=yyleng; return SEMICOLON;}
":"		                    {ECHO; cnt_column+=yyleng; return COLON;}
","                         {ECHO; cnt_column+=yyleng; return COMMA;}
"("                         {ECHO; cnt_column+=yyleng; return LPAR;}
")"                         {ECHO; cnt_column+=yyleng; return RPAR;}

"<"|">"|"<>"|"="            {ECHO; cnt_column+=yyleng; return RELOP;}
"&"|"~"|"!"                 {ECHO; cnt_column+=yyleng; return LOGOP;}
"+"|"-"                     {ECHO; cnt_column+=yyleng; return ADDOP;}
"*"|"/"|"mod"               {ECHO; cnt_column+=yyleng; return MULOP;}
"<="                        {ECHO; cnt_column+=yyleng; return ASSIGNOP;}

{ID}                        {ECHO; cnt_column+=yyleng; return ID;}
{NUM}                       {ECHO; cnt_column+=yyleng; return NUM;}
{WS}						{ECHO; cnt_column+=yyleng; }
{LINE}						{ECHO; fprintf(yyout,"%d ", ++cnt_line); cnt_column = 1;}
.							{fprintf(yyout,"Error: in line %d \"%s\" is not a valid token\n",cnt_line, yytext); exit(3);}

%%


int yywrap(){return 1;}

// int main(int argc, char** argv){
//     int token;
//     FILE* yyout_tok;
//     if(argc < 2){
//         fprintf(stderr, "%s", "Not enough arguments, Exit\n");
//         exit(0);
//     }

//     if(fileNameCheck(argv[1])){
//         yyin = fopen(argv[1], "r");
//         FILE_CHEK(yyin);

//         yyout = fopen( modifyFileName(argv[1], "lst"), "w");
//         fprintf(yyout,"%d ",++cnt_line);
//         yyout_tok = fopen( modifyFileName(argv[1], "tok"), "w");

//     }else{
//       fprintf(stderr, "%s", "File name os not Valid!\n");
//       exit(2);
//     }

//     while(token = yylex()){
//       printTok(token, yyout_tok);
//     }
// }


// void printTok(int token, FILE* yyout_tok){
//     char* attr;
//     switch(token){

//         /* no attributes tokens */
//         case START:
// 		    fprintf(yyout_tok, "%s\tSTART\n", yytext);
// 		    break;
//         case DO:
//             fprintf(yyout_tok, "%s\tDO\n", yytext);
//             break;
//         case ELSE:
//             fprintf(yyout_tok, "%s\tELSE\n", yytext);
//             break;
//         case IF:
//             fprintf(yyout_tok, "%s\tIF\n", yytext);
//             break;
//         case ENDI:
//             fprintf(yyout_tok, "%s\tENDI\n", yytext);
//             break;
//         case INT:
//             fprintf(yyout_tok, "%s\tINT\n", yytext);
//             break;
//         case PUT:
//             fprintf(yyout_tok, "%s\tPUT\n", yytext);
//             break;
//         case PROG:
//             fprintf(yyout_tok, "%s\tPROG\n", yytext);
//             break;
//         case GET:
//             fprintf(yyout_tok, "%s\tGET\n", yytext);
//             break;
//         case REAL:
//             fprintf(yyout_tok, "%s\tREAL\n", yytext);
//             break;
//         case THEN:
//             fprintf(yyout_tok, "%s\tTHEN\n", yytext);
//             break;
//         case VAR:
//             fprintf(yyout_tok, "%s\tVAR\n", yytext);
//             break;
//         case LOOP:
//             fprintf(yyout_tok, "%s\tLOOP\n", yytext);
//             break;
//         case ENDL:
//             fprintf(yyout_tok, "%s\tENDL\n", yytext);
//             break;
//         case UNTIL:
//             fprintf(yyout_tok, "%s\tUNTIL\n", yytext);
//             break;
//         case ENDP:
//             fprintf(yyout_tok, "%s\tENDP\n", yytext);
//             break;
//         case DOT:
//             fprintf(yyout_tok, "%s\tDOT\n", yytext);
//             break;
//         case SEMICOL:
//             fprintf(yyout_tok, "%s\tSEMICOL\n", yytext);
//             break;
//         case COLON:
//             fprintf(yyout_tok, "%s\tCOLON\n", yytext);
//             break;
//         case COMMA:
//             fprintf(yyout_tok, "%s\tCOMMA\n", yytext);
//             break;
//         case LBAR:
//             fprintf(yyout_tok, "%s\tLBAR\n", yytext);
//             break;
//         case RBAR:
//             fprintf(yyout_tok, "%s\tRBAR\n", yytext);
//             break;
        
          
//         /* with attribute tokens */
//         case ID:
//             fprintf(yyout_tok, "%s\tID\tID=%s, Length=%d\n",yytext, yytext, yyleng);
//             break;
//         case NUM:
//             fprintf(yyout_tok, "%s\tNUM\tVal=%s\n",yytext, yytext);
//             break;
//         case RELOP:
//             if(!strcmp(yytext, "<")) {attr = "LT";}
//             else if(!strcmp(yytext, ">")){attr = "GT";}
//             else if(!strcmp(yytext, "<>")){attr = "NE";}
//             else if(!strcmp(yytext, "=")){attr = "EQ";}
//             fprintf(yyout_tok, "%s\tRELOP\t%s\n",yytext, attr);
//             break;
//         case LOGOP:
//             if(!strcmp(yytext, "&")) {attr = "AND";}
//             else if(!strcmp(yytext, "~")){attr = "OR";}
//             else if(!strcmp(yytext, "!")){attr = "NOT";}
//             fprintf(yyout_tok, "%s\tLOGOP\t%s\n",yytext, attr);
//             break;
//         case ADDOP:
//             if(!strcmp(yytext, "+")) {attr = "ADD";}
//             else if(!strcmp(yytext, ">")){attr = "SUB";}
//             fprintf(yyout_tok, "%s\tADDOP\t%s\n",yytext, attr);
//             break;
//         case MULOP:
//             if(!strcmp(yytext, "*")) {attr = "MUL";}
//             else if(!strcmp(yytext, "/")){attr = "DEV";}
//             else if(!strcmp(yytext, "mod")){attr = "MOD";}
//             fprintf(yyout_tok, "%s\tMULOP\t%s\n",yytext, attr);
//             break;
//         case ASSIGNOP:
//             fprintf(yyout_tok, "%s\tASSIGNOP\tASSIGN\n",yytext);
//             break;
//     }
// }


// /* Check if the file name is correct */
// int fileNameCheck(char* fileName){
//     return (strlen(fileName) > 4 && !strcmp(fileName + strlen(fileName) - 4, ".sle"));
// }

// /* change the ending of file*/
// char* modifyFileName(char* fileName, char* change){
//     char* newName = strdup(fileName);
//     int corsur = strlen(fileName) - 3;
//     int i;
//     for(i=0 ; i < 3 ; i++, corsur++){
//         newName[corsur] = change[i];
//     }

//     return newName;
// }

// int yyerror(){return 0;}