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
EXPONENCIAL [Ee]
DOSPUNTOS :
COMPSEC ;
SEPARADOR ,

LITERAL_BOOLEANO (?i:(verdadero|falso))
TIPO (?i:(booleano|cadena|caracter|entero|real))
TABLA (?i:tabla)

DE (?i:de)

DIVMOD (?i:(div|mod))


/* Literales para entero, real, carácter y cadena */
LITERAL_ENTERO {DIGIT}+({EXPONENCIAL}{DIGIT}+)?
LITERAL_REAL {DIGIT}+(\.{DIGIT}+)?({EXPONENCIAL}{DIGIT}+)?
LITERAL_CARACTER \"[^"]\"
LITERAL_CADENA '[^']*'

/* Operadores lógicos, relacionales y de cálculo */
OPERADOR_LOGICO (?i:(y|o|no))
OPERADOR_RELACIONAL <|>|>=|<=|=|!=
OPERADOR_CALCULO {DIVMOD}|[+\-*]

/* Precondición, postcondición y comentarios */
PREC \{Prec[^}]*\}
POST \{Post[^}]*\}
COMENTARIO \{[^}]*\}


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
/* Declaración Constantes */
CONST (?i:const)
FCONST (?i:fconst)

/* Declaración de tipos */
CTIPO (?i:tipo)
CFTIPO (?i:ftipo)

/* Declaración de tuplas */
TUPLA (?i:tupla)
FTUPLA (?i:ftupla)

/* Declaración de variables */
VAR (?i:var)
FVAR (?i:fvar)

/* Si o If */
SI (?i:si)
FSI (?i:fsi)
SINO \[\]
ENTONCES ->
 
/* Devolución en funciones */
DEV (?i:dev)
/* Tipos de variables, entrada, salida o e/s */
ENT (?i:ent)
SAL (?i:sal)
ENTSAL (?i:e\/s)

/* Tipo variable puntero */
REF (?i:ref)

/* Tokens de ayuda */
ASIGNACION :=
SUBRANGO \.\.

/* Son los accesos a elementos de tabla y se utilizan también para su declaración
 *	Ejemplo: tabla de entero[1..10]
 *		tabla[5]
 */
ACCESO \[
FACCESO \]

/* Inicio y final de paréntesis, se usan para agrupar operaciones
 * y para los parámetros de las funciones/acciones
 */
APARENTESIS \(
CPARENTESIS \)

%%

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

    /* En la posición 1 de yytext extará el carácter, 
     * puesto que en la posición 0 estará la primera doble comilla 
    */
{LITERAL_CARACTER}	{
	printf ("Literal Caracter: %s (%c)\n", yytext, yytext[1]);
}

{LITERAL_CADENA}	{
	printf ("Literal Cadena: %s\n", yytext);
}


{TIPO}	{
	printf( "Tipo: %s\n", yytext );
}

{ACCESO}	{
	printf( "Inicio de acceso: %s\n", yytext );
}

{FACCESO}	{
	printf( "Final de acceso: %s\n", yytext );
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

{SINO}	{
	printf("Si no: %s\n", yytext);
}

{ENTONCES}	{
	printf("Entonces: %s\n", yytext);
}

{DE}	{
	printf("De: %s\n", yytext);
}


{CONST}  {
	printf("Inicio declaración Constantes: %s\n", yytext);
}

{FCONST}  {
	printf("Final declaración Constantes: %s\n", yytext);
}

{CTIPO}  {
	printf("Inicio declaración Tipo: %s\n", yytext);
}

{CFTIPO}  {
	printf("Final declaración Tipo: %s\n", yytext);
}
{TUPLA}  {
	printf("Inicio declaración Tupla: %s\n", yytext);
}

{FTUPLA}  {
	printf("Final declaración Tupla: %s\n", yytext);
}
{VAR}  {
	printf("Inicio declaración Variables: %s\n", yytext);
}

{FVAR}  {
	printf("Final declaración Variables: %s\n", yytext);
}
{DEV}  {
	printf("Devolver: %s\n", yytext);
}

{ENT}  {
	printf("Variable entrada: %s\n", yytext);
}
{SAL}  {
	printf("Variable salida: %s\n", yytext);
}

{ENTSAL}  {
	printf("Variable entrada/salida: %s\n", yytext);
}

{REF}  {
	printf("Variable referenciada(puntero): %s\n", yytext);
}

{DOSPUNTOS}  {
	printf("Declaración: %s\n", yytext);
}

{COMPSEC}  {
	printf("Composición Secuencial: %s\n", yytext);
}

{SEPARADOR}  {
	printf("Separador: %s\n", yytext);
}

{OPERADOR_LOGICO}  {
	printf("Operador Lógico: %s\n", yytext);
}

{SUBRANGO}  {
	printf("Subrango: %s\n", yytext);
}

{APARENTESIS}  {
	printf("Abrir paréntesis: %s\n", yytext);
}

{CPARENTESIS}  {
	printf("Cerrar paréntesis: %s\n", yytext);
}

{TABLA}  {
	printf("Tabla: %s\n", yytext);
}

{IDENTIFICADOR}	{
	printf( "Identificador: %s\n", yytext );
}

{ASIGNACION} {
	printf("Asignación: %s\n", yytext);   
}

{OPERADOR_RELACIONAL} {
	printf( "Operador Relacional: %s\n", yytext );
}

{PREC}	{
	printf ("Precondición: %s \n", yytext);
}

{POST}	{
	printf ("Postcondición: %s \n", yytext);
}

	/* Comentario */
{COMENTARIO}	{
	printf ("Comentario: %s \n", yytext);
}

[ \t\n]+          /* eat up whitespace */

.           printf( "Carácter desconocido: %s\n", yytext );

%%

int main( argc, argv )
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
