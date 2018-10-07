/* scanner for a toy Pascal-like language */

%{
/* need this for the call to atof() below */
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


LITERAL_ENTERO {MASMENOS}?{DIGIT}+({EXPONENCIAL}{DIGIT}+)?
LITERAL_REAL {MASMENOS}?{DIGIT}+(\.{DIGIT}+)?({EXPONENCIAL}{DIGIT}+)?
LITERAL_CARACTER \"[^"]\"
LITERAL_CADENA {CADENA_COMILLA}[^']*{CADENA_COMILLA}
OPERADOR_LOGICO (?i:(y|o|no))

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

OPERADOR_CALCULO (?i:(div|mod|+|-|*))

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



{LITERAL_ENTERO}	{
            printf( "Literal Entero: %s (%d)\n", yytext,
                    atoi( yytext ) );
            }

{LITERAL_REAL}   {
            printf( "Literal Real: %s (%f)\n", yytext,
                    atoi( yytext ) );
            }
{LITERAL_BOOLEANO}	{
	printf ("Literal Booleano: %s (%s)\n", yytext,
                    atoi( yytext ) );
}

{LITERAL_CARACTER}	{
	printf ("Literal Caracter: %s (%c)\n", yytext,
                    atoi( yytext ) );
}

{LITERAL_CADENA}	{
	printf ("Literal Cadena: %s (%s)\n", yytext,
                    atoi( yytext ) );
}

{TIPO}	{
	printf( "Un Tipo: %s\n", yytext );
}

{IDENTIFICADOR}	{
	printf( "An identifier: %s\n", yytext );
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
