
%{
	#include<stdio.h>
	#include<stdlib.h>
	
	int char_cnt = 0;
	int num_cnt = 0;
	int word_cnt = 0;
	int ws_cnt = 0;
	int line_cnt = 0;
%}

digit [0-9]
num	[1-9]{digit}*("."{digit}+)?
letter[a-zA-Z]
word {letter}+
ws [ \t]+

%%
^{num}		{fprintf(yyout,"%d:", line_cnt); num_cnt++; char_cnt += yyleng; ECHO;}
{num}		{num_cnt++; char_cnt += yyleng; ECHO;}
^{word}		{fprintf(yyout,"%d:", line_cnt); word_cnt++ ;char_cnt += yyleng; ECHO;}
{word}		{word_cnt++; char_cnt += yyleng; ECHO;}
^{ws}		{fprintf(yyout,"%d:", line_cnt); char_cnt += yyleng; ECHO;}
{ws}		{char_cnt += yyleng; ECHO;}
^\n			{fprintf(yyout,"%d:", line_cnt); line_cnt++; char_cnt += yyleng; ECHO;}
\n			{line_cnt++; char_cnt += yyleng; ECHO;}
^.			{fprintf(yyout,"%d:", line_cnt); char_cnt += yyleng; ECHO;}
.			{char_cnt += yyleng; ECHO;}
%%

int main(int argc, char** argv){
	
	if(argc > 1)
		yyin = fopen(argv[1],"r");
  	if(argc > 2)
		yyout = fopen(argv[2],"w");
	yylex();
	return 0;
}

int yywrap(){
	printf("number of char %d\n", char_cnt);
	printf("number of numbers %d\n", num_cnt);
	printf("number of words %d\n", word_cnt);
	printf("number of lines %d\n", line_cnt);
	return 0;
}



