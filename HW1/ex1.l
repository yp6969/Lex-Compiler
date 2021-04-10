
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
num	[1-9]{gidit}*("."{digit}+)?
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
	yylex();
	return 0;
}

int yywrap(){
	printf("number of char %d");
	printf("number of numbers %d");
	printf("number of words %d");
	printf("number of lines %d");
	return 0;
}



