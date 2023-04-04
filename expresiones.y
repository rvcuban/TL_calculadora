%{
#include <iostream>
#include <math.h>
#include <set>
#include <map>
#include <utility>
using namespace std;

//elementos externos al analizador sintácticos por haber sido declarados en el analizador léxico      			
extern int n_lineas;
extern int yylex();
set<pair<float,char*>> identificadores; 
map<float,char*> mi_mapa; 

//definición de procedimientos auxiliares
void yyerror(const char* s){         /*    llamada por cada error sintactico de yacc */
	cout << "Error en la línea "<< n_lineas<<endl;	
} 

void prompt(){
  	cout << "LISTO> ";
}

%}
%union{
	int c_entero;
	float c_real;
	char c_cadena[25];
}

%start entrada
%token <c_entero> NUMERO 
%token <c_real> REAL
%token <c_cadena> ID

%type <c_real> expr
%token SALIR

%left '+' '-'   /* asociativo por la izquierda, misma prioridad */
%left '*' '/' '%'  /* asociativo por la izquierda, prioridad alta */
%left '^'
%left menos
%left '='
%%
entrada: 		{prompt();}
      |entrada linea
      ;
linea: ID ':''=' expr '\n' { cout<< "La variable " << $1 << " tendrá guardado el valor de " << $4 << endl;
        		identificadores.insert(make_pair($4,$1));
                        mi_mapa.insert(make_pair($4,$1));
                        prompt();}
		
	|SALIR 	'\n'			{return(0);}         //comprobar los errores semanticos tanto la division y el modulo por 0 y el modulo con números reales
	|error  '\n'  {prompt();}
	;

expr:    NUMERO 		      {$$=$1;} 
       | REAL  		{$$=$1;}
       | '(' expr ')'  		{$$=$2;}                   
       | expr '+' expr 		{$$=$1+$3;}              
       | expr '-' expr    	{$$=$1-$3;}            
       | expr '*' expr        {$$=$1*$3;} 
       | expr '%' expr        {$$=int($1)%int($3);}
       | expr '^' expr        {$$=pow($1,$3);}
       | expr '/' expr        {$$=$1/$3;} 
       |'-' expr %prec menos  {$$= -$2;}
       |error '\n'  {yyerrok;}
       ;
%%

int main(){
     
     n_lineas = 0;
     
     cout <<endl<<"******************************************************"<<endl;
     cout <<"*      Calculadora de expresiones aritméticas        *"<<endl;
     cout <<"*                                                    *"<<endl;
     cout <<"*      1)con el prompt LISTO>                        *"<<endl;
     cout <<"*        teclea una expresión, por ej. 1+2<ENTER>    *"<<endl;
     cout <<"*        Este programa indicará                      *"<<endl;
     cout <<"*        si es gramaticalmente correcto              *"<<endl;
     cout <<"*      2)para terminar el programa                   *"<<endl;
     cout <<"*        teclear SALIR<ENTER>                        *"<<endl;
     cout <<"*      3)si se comete algun error en la expresión    *"<<endl;
     cout <<"*        se mostrará un mensaje y la ejecución       *"<<endl;
     cout <<"*        del programa finaliza                       *"<<endl;
     cout <<"******************************************************"<<endl<<endl<<endl;
     yyparse();
     cout <<"****************************************************"<<endl;
     cout <<"*                                                  *"<<endl;
     cout <<"*                 ADIOS!!!!                        *"<<endl;
     cout <<"****************************************************"<<endl;
     
     cout<<"Lista de resultados: \n\n";
    for(const auto& pareja : mi_mapa){
    cout<<pareja.first << "  " << pareja.second<<endl;
    }
     return 0;
}
