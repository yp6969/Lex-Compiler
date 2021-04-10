
%{
	#include<stdio.h>
	#include<stdlib.h>
	
	int counter = 0 ;
%}


%%

"hello world"  {counter++;};
.|\n ;  /* dont do nothing */

%%

int main(int argc, char** argv){
	
	if(argc > 1){
		yyin = fopen(argv[1], "r");
		yylex();
	}else{
		printf("no input\n");
	}
	return 0;
}

int yywrap(){
	printf("thr number is %d", counter);
	return 1;
}