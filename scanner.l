/* Scanner para lenguaje de pseudocódigo */

/*
 *	Grupo:		21
 *	Autores:	Cristian Berner y Andrea Zaratiegui
 *	Lenguaje:	Flex v2.6
 */

%{
/* Zona para incluir las librerías necesarias */
#include <math.h>
#include "gramatica.tab.h"
%}

    /*
    *	Hemos decidido permitir que se utilicen también
    *	carácteres del alfabeto español para el lenguaje.
    *	De ahí la necesidad de incluirlos en LETRA
    */
LETRA	 [a-zA-ZñÑáéíóúÁÉÍÓÚüÜ]
DIGIT    [0-9]
IDENTIFICADOR       ({LETRA}|_)({LETRA}|{DIGIT}|_)*
EXPONENCIAL [Ee]
DOSPUNTOS :
COMPSEC ;
SEPARADOR ,


TIPO (?i:(booleano|cadena|caracter|entero|real))
TABLA (?i:tabla)

DE (?i:de)

/* Literales para entero, real, carácter y cadena */
LITERAL_ENTERO {DIGIT}+({EXPONENCIAL}{DIGIT}+)?
LITERAL_REAL {DIGIT}+(\.{DIGIT}+)?({EXPONENCIAL}{DIGIT}+)?
LITERAL_CARACTER \"[^"]\"
LITERAL_CADENA '[^']*'

/* Operadores lógicos, relacionales y de cálculo */
BOOLY (?i:y)
BOOLO (?i:o)
NO (?i:no)
OPERADOR_RELACIONAL <|>|>=|<=|=|!=
VERDADERO (?i:verdadero)
FALSO (?i:falso)


/* Separo los operadores de cálculo para que bison los entienda */
OPERADOR_CALCULO [+\-*]
PLUS \+
MINUS \-
POR \*
DIV \/
DIVE (?i:div)
MOD (?i:mod)

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

PUNTO \.

%%

{PLUS} {
	printf("PLUS: %s\n", yytext);
		return T_PLUS;
}
{MINUS} {
	printf("MINUS: %s\n", yytext);
		return T_MINUS;
}
{POR} {
	printf("POR: %s\n", yytext);
		return T_POR;
}
{DIV} {
	printf("DIV: %s\n", yytext);
		return T_DIV;
}
{DIVE} {
	printf("División entera: %s\n", yytext);
		return T_DIVE;
}
{MOD} {
	printf("Módulo: %s\n", yytext);
		return T_MOD;
}

{LITERAL_ENTERO}	{
            printf( "Literal Entero: %s (%d)\n", yytext,
                    atoi( yytext ) );
		return T_LITERAL_NUMERICO;
            }

{LITERAL_REAL}   {
            printf( "Literal Real: %s (%f)\n", yytext,
                    atof( yytext ) );
		return T_LITERAL_NUMERICO;
            }
{VERDADERO}	{
	printf ("Literal Booleano: %s\n", yytext);
	return T_VERDADERO;
}

{FALSO}	{
	printf ("Literal Booleano: %s\n", yytext);
	return T_FALSO;
}

    /* En la posición 1 de yytext extará el carácter, 
     * puesto que en la posición 0 estará la primera doble comilla 
    */
{LITERAL_CARACTER}	{
	printf ("Literal Caracter: %s (%c)\n", yytext, yytext[1]);
	return T_LITERAL_CARACTER;
}

{LITERAL_CADENA}	{
	printf ("Literal Cadena: %s\n", yytext);
}


{TIPO}	{
	printf( "Tipo: %s\n", yytext );
	/**yylval = "Testing";*/
	yylval.union_cadena = strdup(yytext);
	return T_TIPOBASE;
}

{ACCESO}	{
	printf( "Inicio de acceso: %s\n", yytext );
	return T_ACCESO;
}

{FACCESO}	{
	printf( "Final de acceso: %s\n", yytext );
	return T_FACCESO;
}

{MIENTRAS}  {
	printf("Inicio de Mientras: %s\n", yytext);
	return T_MIENTRAS;
}

{FMIENTRAS}  {
	printf("Final de Mientras: %s\n", yytext);
	return T_FMIENTRAS;
}

{PARA}  {
	printf("Inicio de Para: %s\n", yytext);
	return T_PARA;
}

{FPARA}  {
	printf("Final de Para: %s\n", yytext);
	return T_FPARA;
}

{HASTA}  {
	printf("Hasta: %s\n", yytext);
	return T_HASTA;
}

{CONTINUAR}  {
	printf("Continuar: %s\n", yytext);
	return T_CONTINUAR;
}

{HACER}  {
	printf("Hacer: %s\n", yytext);
	return T_HACER;
}

{ALGORITMO}  {
	printf("Inicio de Algoritmo: %s\n", yytext);
	return T_BALGORITMO;
}

{FALGORITMO}  {
	printf("Final de Algoritmo: %s\n", yytext);
	return T_FALGORITMO;
}

{ACCION}  {
	printf("Inicio de Acción: %s\n", yytext);
	return T_ACCION;
}

{FACCION}  {
	printf("Final de Acción: %s\n", yytext);
	return T_FACCION;
}

{FUNCION}  {
	printf("Inicio de Función: %s\n", yytext);
	return T_FUNCION;
}

{FFUNCION}  {
	printf("Final de Función: %s\n", yytext);
	return T_FFUNCION;
}

{SI}  {
	printf("Inicio de SI(If): %s\n", yytext);
	return T_SI;
}

{FSI}  {
	printf("Final de SI(If): %s\n", yytext);
	return T_FSI;
}

{SINO}	{
	printf("Si no: %s\n", yytext);
	return T_SINO;
}

{ENTONCES}	{
	printf("Entonces: %s\n", yytext);
	return T_ENTONCES;
}

{DE}	{
	printf("De: %s\n", yytext);
	return T_DE;
}


{CONST}  {
	printf("Inicio declaración Constantes: %s\n", yytext);
	return T_CONST;
}

{FCONST}  {
	printf("Final declaración Constantes: %s\n", yytext);
	return T_FCONST;
}

{CTIPO}  {
	printf("Inicio declaración Tipo: %s\n", yytext);
	return T_BTIPO;
}

{CFTIPO}  {
	printf("Final declaración Tipo: %s\n", yytext);
	return T_FTIPO;
}
{TUPLA}  {
	printf("Inicio declaración Tupla: %s\n", yytext);
	return T_TUPLA;
}

{FTUPLA}  {
	printf("Final declaración Tupla: %s\n", yytext);
	return T_FTUPLA;
}
{VAR}  {
	printf("Inicio declaración Variables: %s\n", yytext);
	return T_VAR;
}

{FVAR}  {
	printf("Final declaración Variables: %s\n", yytext);
	return T_FVAR;
}
{DEV}  {
	printf("Devolver: %s\n", yytext);
	return T_DEV;
}

{ENT}  {
	printf("Variable entrada: %s\n", yytext);
	return T_ENT;
}
{SAL}  {
	printf("Variable salida: %s\n", yytext);
	return T_SAL;
}

{ENTSAL}  {
	printf("Variable entrada/salida: %s\n", yytext);
	return T_ENTSAL;
}

{REF}  {
	printf("Variable referenciada(puntero): %s\n", yytext);
	return T_REF;
}

{DOSPUNTOS}  {
	printf("Declaración: %s\n", yytext);
	return T_DOSPUNTOS;
}

{COMPSEC}  {
	printf("Composición Secuencial: %s\n", yytext);
	return T_SEC;
}

{SEPARADOR}  {
	printf("Separador: %s\n", yytext);
	return T_SEPARADOR;
}

{PUNTO} {
	printf("Punto: %s\n", yytext);
	return T_PUNTO;
}

{BOOLY}  {
	printf("Operador Lógico: %s\n", yytext);
	return T_BOOLY;
}
{BOOLO}  {
	printf("Operador Lógico: %s\n", yytext);
	return T_BOOLO;
}
{NO}  {
	printf("Operador Lógico: %s\n", yytext);
	return T_NO;
}

{SUBRANGO}  {
	printf("Subrango: %s\n", yytext);
	return T_SUBRANGO;
}

{APARENTESIS}  {
	printf("Abrir paréntesis: %s\n", yytext);
	return T_APARENTESIS;
}

{CPARENTESIS}  {
	printf("Cerrar paréntesis: %s\n", yytext);
	return T_CPARENTESIS;
}

{TABLA}  {
	printf("Tabla: %s\n", yytext);
	return T_TABLA;
}

{IDENTIFICADOR}	{
	printf( "Identificador: %s\n", yytext );
	/**yylval = (char *) malloc(sizeof(char)*strlen(yytext));
	*yylval = strdup(yytext);*/
	yylval.union_cadena = strdup(yytext);
	return T_IDENTIFICADOR;
}

{ASIGNACION} {
	printf("Asignación: %s\n", yytext);
	return T_ASIGNACION;
}

{OPERADOR_RELACIONAL} {
	printf( "Operador Relacional: %s\n", yytext );
	return T_OPREL;
}

{PREC}	{
	printf ("Precondición: %s \n", yytext);
	return T_PREC;
}

{POST}	{
	printf ("Postcondición: %s \n", yytext);
	return T_POST;
}

	/* Comentario */
{COMENTARIO}	{
	printf ("Comentario: %s \n", yytext);
}

[ \t\n]+          /* Quitar espacios en blanco */

.           printf( "Carácter desconocido: %s\n", yytext );

%%

