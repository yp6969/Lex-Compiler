# Lex-Compiler

compiling lex :  .\flex <FILE>.l       
compiling c:  g++ <C_FILE> -o <EXE_FILE>
  
  Built in vars:
  - yyin
  - yyout

  built in func:
  - yylex()
  - yywrap() :calls when EOF!!! 
  
  Conditions: activate with BEGIN <NAME> and write for every line to consider the condition
  End with BEGIN INITIAL
  - specific: %x <NAME>
  - general: %s <NAME>
