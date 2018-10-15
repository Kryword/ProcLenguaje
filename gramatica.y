%{
#include <stdio.h>
#define YYSTYPE char const *
int yylex(void);
void yyerror(char const *);
%}
/* Comienzo y final de Algoritmo */
%token T_BALGORITMO
%token T_FALGORITMO
%token T_IDENTIFICADOR
%token T_SEC
%token T_BTIPO
%token T_FTIPO
%token T_CONST
%token T_FCONST
%token T_PREC
%%
desc_algoritmo:T_BALGORITMO T_IDENTIFICADOR T_SEC cabecera_alg T_FALGORITMO{printf ("Algoritmo\n");};
cabecera_alg:decl_globales T_PREC{
	printf ("Cabecera Algoritmo\n");
}; 
decl_globales:decl_tipo decl_globales |decl_const decl_globales | %empty
;
decl_tipo:T_BTIPO T_FTIPO;
decl_const:T_CONST T_FCONST;
%%
void yyerror(char const * error)
{
    printf("ERROR\n");
}
int main(void)
{
	yyparse();
}
