%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>


int yylex();
FILE *yyin, *yyout,*yyStx;
int lineCounter;

int yyparse();
extern int cnt_line, cnt_column, yyleng;
char* yytext;
const char* src;
void printError(const char * fmt, ...);



%}

/*                    TOKENS                 */
%token  ID
%token  NUM 
%left ADDOP MULOP RELOP LOGOP

%token START DO ELSE IF ENDI INT PUT PROG
%token GET REAL THEN VAR LOOP ENDL UNTIL ENDP
%token DOT SEMICOLON COLON COMMA LPAR RPAR
%left ASSIGNOP



%%

Program: PROG ID SEMICOLON Declarations START StmtList ENDP DOT		{fprintf(yyStx,"Program: PROG ID SEMICOLON Declarations START StmtList ENDP DOT\n"); return 0;}
	|error 															{return 0;}
;
Declarations: VAR DecList SEMICOLON	 								{fprintf(yyStx,"Declarations: VAR DecList SEMICOLON\n");}
	|error															{return 0;}
;
DecList: DecList COMMA ID COLON Type								{fprintf(yyStx,"DecList: DecList COMMA ID COLON Type\n");}
	|ID COLON Type													{fprintf(yyStx,"DecList: ID COLON Type\n");}
	|error															{return 0;}
;
Type: INT 															{fprintf(yyStx,"Type: INT\n");}
	|REAL															{fprintf(yyStx,"Type: REAL\n");}
	|error															{return 0;}
;
StmtList: StmtList Statment SEMICOLON 								{fprintf(yyStx,"StmtList: StmtList Statment SEMICOLON\n");}
	| 																{fprintf(yyStx,"StmtList: \'epsilon\'\n");}
;
Statment: ID ASSIGNOP Expression									{fprintf(yyStx,"Statment: ID ASSIGNOP Expression\n");}
	|PUT Expression													{fprintf(yyStx,"Statment: PUT Expression\n");}
	|GET ID															{fprintf(yyStx,"Statment: GET ID\n");}
	|IF BoolExp THEN StmtList ELSE StmtList ENDI					{fprintf(yyStx,"Statment: IF BoolExp THEN StmtList ELSE StmtList ENDI\n");}
	|IF BoolExp THEN StmtList ENDI									{fprintf(yyStx,"Statment: IF BoolExp THEN StmtList ENDI\n");}
	|LOOP BoolExp DO StmtList ENDL									{fprintf(yyStx,"Statment: LOOP BoolExp DO StmtList ENDL\n");}
	|DO StmtList UNTIL BoolExp ENDL									{fprintf(yyStx,"Statment: DO StmtList UNTIL BoolExp ENDL\n");}
	|error															{return 0;}
;
BoolExp: Expression Case Expression									{fprintf(yyStx,"BoolExp: Expression Case Expression\n");}
;
Case: RELOP 														{fprintf(yyStx,"Case: RELOP\n");}
	|LOGOP															{fprintf(yyStx,"Case: LOGOP\n");}
	|error 															{return 0;}
;
Expression: Expression ADDOP Term 									{fprintf(yyStx,"Expression: Expression ADDOP Term\n");}
	|Term															{fprintf(yyStx,"Expression: Term\n");}
;
Term: Term MULOP Factor												{fprintf(yyStx,"Term: Term MULOP Factor\n");}
	|Factor															{fprintf(yyStx,"Term: Factor\n");}
;
Factor: ID 															{fprintf(yyStx,"Factor: ID\n");}
	|NUM 															{fprintf(yyStx,"Factor: NUM\n");}
	|LPAR Expression RPAR											{fprintf(yyStx,"Factor: LPAR Expression RPAR\n");}
	|error {return 0;}
;


%%


int main(int argc, char** argv){
	src = argv[1];
	char lstFile[20] = "";
	char stxFile[20] = "";
	int result;

	if(argc >= 2){
		if(strchr(argv[1],'.') != NULL){ // makesure file has an extension
			char * ext = strchr(argv[1],'.')+1;
			if(!strcmp("sle",ext) && !strcmp("SLE",ext))
			{
				perror("File must be of type '.sle' or '.SLE'\n");
				exit(1);
			}
		}
		else {
			perror("File must be of type '.sle' or '.SLE'\n");
			exit(1);
		}

		if((yyin = fopen(argv[1],"r")) == NULL){ // use file as yyin
			perror("Error openning file!");
			exit(1);
		}
		char* fileName = strtok(argv[1], ".");
		strcat(lstFile, fileName);
		strcat(lstFile, ".lst");
		strcat(stxFile, fileName);
		strcat(stxFile, ".stx");
		


		if(!(yyout = fopen(lstFile,"w")) || !(yyStx = fopen(stxFile, "w"))){
			perror("Error openning file");
		}
		


		int err = yyparse();
		if(err){
			fprintf(stdout,"parse was not successful\n",cnt_line);
		}else{
			fprintf(stdout,"parse was successful\n");
		}
		fclose(yyStx);
		fclose(yyin);
		fclose(yyout);
	}else{
		perror("arguments not valid");
	}
	return 0;
}

void printError(const char * fmt, ...){
	va_list arglist;
	va_start( arglist, fmt );
	vfprintf(yyout,fmt,arglist);
	vfprintf(stdout,fmt,arglist);
}

int yyerror(const char * err){
	fprintf(yyout,"\n%s.sle:%d:%d:parser error: unexpected token %s \n", src, cnt_line, cnt_column-yyleng, yytext);
	fprintf(stdout,"\n%s.sle:%d:%d:parser error: unexpected token %s \n", src, cnt_line, cnt_column-yyleng, yytext);
	exit(1);
}