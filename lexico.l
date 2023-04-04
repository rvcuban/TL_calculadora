%{
#include "expresiones.h"
#include <math.h>
int n_lineas;
%}

%option noyywrap
 

%%
[sS][aA][Ll][Ii][Rr]	return SALIR;
[0-9]+			yylval.c_entero = atoi(yytext);return NUMERO;
[0-9]+[.][0-9]*|[0-9]*[.][0-9]+			yylval.c_real = atof(yytext); return REAL;
[A-Za-zñÑ][A-Za-zñÑ_0-9]* 	strcpy(yylval.c_cadena, yytext); return ID;
\n				n_lineas++; return (yytext[0]);
[\t ]			;	
. 				return (yytext[0]);
%%


