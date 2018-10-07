/* Scanner para lenguaje de pseudocódigo */

/*
 *	Grupo:		25
 *	Autores:	Cristian Berner y Andrea Zaratiegui
 *	Lenguaje:	Flex v2.6
 */

%{
/* Zona para incluir las librerías necesarias */
#include <math.h>
%}
LETRA	 [a-zA-Z]
DIGIT    [0-9]
IDENTIFICADOR       [a-zA-Z][a-zA-Z0-9]*
MASMENOS [+-]
EXPONENCIAL [Ee]
CARACTER_COMILLA \"
CADENA_COMILLA '

LITERAL_BOOLEANO verdadero|falso
TIPO (?i:(booleano|cadena|caracter|entero|real|tabla))

DIVMOD (?i:(div|mod))
OPERADOR_CALCULO {DIVMOD}|[+\-*]

LITERAL_ENTERO {MASMENOS}?{DIGIT}+({EXPONENCIAL}{DIGIT}+)?
LITERAL_REAL {MASMENOS}?{DIGIT}+(\.{DIGIT}+)?({EXPONENCIAL}{DIGIT}+)?
LITERAL_CARACTER \"[^"]\"
LITERAL_CADENA {CADENA_COMILLA}[^']*{CADENA_COMILLA}
OPERADOR_LOGICO (?i:(y|o|no))
OPERADOR_RELACIONAL <|>|>=|<=|=|!=

/* Comienzos y finales de bucles */
/* Mientras */
MIENTRAS (?i:mientras)
FMIENTRAS (?i:fmientras)
/* Para o FOR */
PARA (?i:para)
FPARA (?i:fpara)
HASTA (?i:hasta)

HACER (?i:hacer)

CONTINUAR (?i:continuar)

/* Comienzo y final del programa */
ALGORITMO (?i:algoritmo)
FALGORITMO (?i:falgoritmo)

/* Comienzo y final de acciones y funciones */
ACCION (?i:accion)
FACCION (?i:faccion)
/* Implementar solo funcion en vez de accion */
FUNCION (?i:funcion)
FFUNCION (?i:ffuncion)

CONST (?i:const)
FCONST (?i:fconst)

CTIPO (?i:tipo)
CFTIPO (?i:ftipo)

TUPLA (?i:tupla)
FTUPLA (?i:ftupla)

VAR (?i:var)
FVAR (?i:fvar)

SI (?i:si)
FSI (?i:fsi)
 
DEV (?i:dev)
ENT (?i:ent)
SAL (?i:sal)
ENTSAL (?i:e\/s)

REF (?i:ref)

ASIGNACION :=
COMP_SECUENCIAL ;
SUBRANGO ..

/* A mirar más adelante
    TIPO_TABLA (?i:(tabla de {TIPO}\[{DIGIT}..{DIGIT}\]))
*/
SINO \[\]

%%
    /* TODO: El operador de Cálculo no funciona siempre, hay que verificar porque */

{OPERADOR_CALCULO}  {
	    printf("Operador de Cálculo: %s\n", yytext);
}

{LITERAL_ENTERO}	{
            printf( "Literal Entero: %s (%d)\n", yytext,
                    atoi( yytext ) );
            }

{LITERAL_REAL}   {
            printf( "Literal Real: %s (%f)\n", yytext,
                    atof( yytext ) );
            }
{LITERAL_BOOLEANO}	{
	printf ("Literal Booleano: %s\n", yytext);
}

{LITERAL_CARACTER}	{
	printf ("Literal Caracter: %s\n", yytext);
}

{LITERAL_CADENA}	{
	printf ("Literal Cadena: %s\n", yytext);
}


{TIPO}	{
	printf( "Un Tipo: %s\n", yytext );
}

{MIENTRAS}  {
	printf("Inicio de Mientras: %s\n", yytext);
}

{FMIENTRAS}  {
	printf("Final de Mientras: %s\n", yytext);
}

{PARA}  {
	printf("Inicio de Para: %s\n", yytext);
}

{FPARA}  {
	printf("Final de Para: %s\n", yytext);
}

{HASTA}  {
	printf("Hasta: %s\n", yytext);
}

{CONTINUAR}  {
	printf("Continuar: %s\n", yytext);
}

{HACER}  {
	printf("Hacer: %s\n", yytext);
}

{ALGORITMO}  {
	printf("Inicio de Algoritmo: %s\n", yytext);
}

{FALGORITMO}  {
	printf("Final de Algoritmo: %s\n", yytext);
}

{ACCION}  {
	printf("Inicio de Acción: %s\n", yytext);
}

{FACCION}  {
	printf("Final de Acción: %s\n", yytext);
}

{FUNCION}  {
	printf("Inicio de Función: %s\n", yytext);
}

{FFUNCION}  {
	printf("Final de Función: %s\n", yytext);
}

{SI}  {
	printf("Inicio de SI(If): %s\n", yytext);
}

{FSI}  {
	printf("Final de SI(If): %s\n", yytext);
}

{IDENTIFICADOR}	{
	printf( "An identifier: %s\n", yytext );
}

{ASIGNACION} {
	printf("Asignación: %s\n", yytext);   
}

{OPERADOR_RELACIONAL} {
	printf( "Operador Relacional: %s\n", yytext );
}


	/* Comentario */
"{"[^}]*"}"	{
	printf ("Comentario: %s \n", yytext);
}

[ \t\n]+          /* eat up whitespace */

.           printf( "Unrecognized character: %s\n", yytext );

%%

main( argc, argv )
int argc;
char **argv;
    {
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
            yyin = fopen( argv[0], "r" );
    else
            yyin = stdin;

    yylex();
    }
