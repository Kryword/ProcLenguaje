%{
#include <stdio.h>
#include "TablaSimbolos.h"
#include <string.h>
int yylex(void);
void yyerror(char const *);
%}
%union{
	int entero;
	double real;
	char* union_cadena;
	char** union_cadenas;
}
/* Comienzo y final de Algoritmo */
%token T_BALGORITMO
%token T_FALGORITMO
%token<union_cadena> T_IDENTIFICADOR
%token T_SEC
%token T_BTIPO
%token T_FTIPO
%token T_CONST
%token T_FCONST
%token T_PREC
%token T_POST
%token T_VAR
%token T_FVAR
%token T_IGUAL
%token T_TUPLA
%token T_FTUPLA
%token T_FACCESO
%token T_SUBRANGO
%token T_DE
%token<union_cadena> T_TIPOBASE;
%token T_LITERAL;
%token T_SEPARADOR;
%token T_DOSPUNTOS;
%token T_ENT;
%token T_SAL;

%left T_PLUS T_MINUS T_BOOLY T_BOOLO;
%left T_POR T_DIV T_DIVE T_MOD;
%left T_OPREL;

%left T_NO;
%right T_AUXMINUS

%left T_ACCESO T_REF;
%left T_PUNTO;

%token T_APARENTESIS;
%token T_CPARENTESIS;
%token T_LITERAL_NUMERICO;

%token T_VERDADERO;
%token T_FALSO;

%token T_CONTINUAR;
%token T_SI;
%token T_FSI;
%token T_ENTONCES;
%token T_SINO;
%token T_MIENTRAS;
%token T_HACER;
%token T_HASTA;
%token T_FMIENTRAS;
%token T_PARA;
%token T_FPARA;
%token T_ACCION;
%token T_FACCION;
%token T_FUNCION;
%token T_FFUNCION;
%token T_DEV;
%token T_ASIGNACION;
%token T_ENTSAL;
%token T_LITERAL_CARACTER;
%token T_TABLA;

%type<union_cadena>d_tipo
%type<union_cadena>lista_id
%type<union_cadena>lista_campos

%%
/* Comienzo de algoritmo y definición del axioma */ 
desc_algoritmo:T_BALGORITMO T_IDENTIFICADOR T_SEC cabecera_alg bloque_alg T_FALGORITMO{printf ("\tALGORITMO OK\n");};
cabecera_alg:decl_globales decl_a_f decl_ent_sal T_PREC{
		printf("\tCabecera de algoritmo\n");
	};
bloque_alg: bloque T_POST{
		printf("\tBloque de algoritmo\n");
	};
decl_globales:declaracion_tipo decl_globales{
		printf("\tDeclaraciones Globales de tipo\n");
	}
	| declaracion_const decl_globales {
		printf("\tDeclaraciones Globales de constantes\n");
	}
	| %empty;
decl_a_f:accion_d decl_a_f {
		printf("\tDeclaración de Acción\n");
		}
	| funcion_d decl_a_f {
		printf("\tDeclaración de Función\n");
		}
	| %empty{
		};
bloque: declaraciones instrucciones{
		};
declaraciones: declaracion_tipo declaraciones {
		printf("\tDeclaración de tipo\n");
		}
	| declaracion_const declaraciones {
		printf("\tDeclaración de constantes\n");
		}
	| declaracion_var declaraciones {
		printf("\tDeclaración de variables\n");
	}
	| %empty{
		};
/* Declaraciones */
declaracion_tipo:T_BTIPO lista_d_tipo T_FTIPO{
		};
declaracion_const:T_CONST lista_d_cte T_FCONST{
		};
declaracion_var:T_VAR lista_d_var T_FVAR{
		};

/* Declaración de Tipos*/
lista_d_tipo: T_IDENTIFICADOR T_IGUAL d_tipo T_SEC lista_d_tipo{
		} 
	| %empty{
		};
d_tipo: T_TUPLA lista_campos T_FTUPLA {
		$$ = "TUPLA";
		}
	| T_TABLA T_ACCESO expresion_t T_SUBRANGO expresion_t T_FACCESO T_DE d_tipo{
		$$ = "TABLA";
		}
	| T_IDENTIFICADOR {
		$$ = $1;
		}
	| expresion_t T_SUBRANGO expresion_t{
		$$ = "EXPRESION";
		} 
	| T_REF d_tipo {
		$$ = "REF";
		}
	| T_TIPOBASE{
		$$ = $1;
		};
expresion_t: expresion {
		}
	| T_LITERAL_CARACTER{
		};
lista_campos: T_IDENTIFICADOR T_DOSPUNTOS d_tipo T_SEC lista_campos{
		} 
	| %empty{
		};

/* Declaración de constantes y variables */
lista_d_cte: T_IDENTIFICADOR T_IGUAL T_LITERAL T_SEC lista_d_cte {
		}
	| %empty{
		};

lista_d_var:lista_id T_DOSPUNTOS d_tipo T_SEC lista_d_var{
		printf("\tLista de variables: %s de tipo %s\n", $1, $3);
		} 
	| %empty{
		};
lista_id: T_IDENTIFICADOR T_SEPARADOR lista_id {
		//printf("\t%d\n", $1);
		char * aux = strdup($1);
		strcat(aux, ", ");
		strcat(aux, $3);
		$$ = strdup(aux);
		}
	| T_IDENTIFICADOR{
		$$ = $1;
		};

decl_ent_sal: decl_ent {
		printf("\tDeclaración entrada\n");
	}
	| decl_ent decl_sal{
		printf("\tDeclaración entrada salida\n");
	} 
	| decl_sal{
		printf("\tDeclaración salida\n");
	};
decl_ent: T_ENT lista_d_var{
		};
decl_sal: T_SAL lista_d_var{
		};

/* Expresiones */

exp: exp T_PLUS exp {
		}
	| exp T_MINUS exp{
		}
	| exp T_POR exp{
		} 
	| exp T_DIV exp{
		} 
	| exp T_MOD exp {
		}
	| exp T_DIVE exp {
		}
	| T_APARENTESIS exp T_CPARENTESIS {
		}
	| operando{
		}
	| T_LITERAL_NUMERICO {
		}
	| T_MINUS exp %prec T_AUXMINUS{
		}
	| exp T_BOOLY exp {
		}
	| exp T_BOOLO exp { 
		}
	| T_NO exp {
		}
	| T_VERDADERO {
		}
	| T_FALSO {
		}
	| expresion T_OPREL expresion {
		};
expresion: exp{
		} 
	| funcion_ll{
		};

operando: T_IDENTIFICADOR{
		} 
	| operando T_PUNTO operando {
		}
	| operando T_ACCESO expresion T_FACCESO {
		}
	| operando T_REF{
		};

/* Instrucciones */
instrucciones: instruccion T_SEC instrucciones {
		}
	| instruccion{
		};
instruccion: T_CONTINUAR{
		} 
	| asignacion {
		printf("\tInstrucción de asignación \n");
	}
	| alternativa {
		printf("\tInstrucción alternativa\n");
	}
	| iteracion {
		printf("\tInstrucción de iteracion\n");
	}
	| accion_ll{
		};
asignacion: operando T_ASIGNACION expresion{
		};
alternativa: T_SI expresion T_ENTONCES instrucciones lista_opciones T_FSI{
		};
lista_opciones: T_SINO expresion T_ENTONCES instrucciones lista_opciones {
		}
	| %empty{
		};
iteracion: it_cota_fija {
		} 
	| it_cota_exp{
		};
it_cota_exp: T_MIENTRAS expresion T_HACER instrucciones T_FMIENTRAS{
		};
it_cota_fija: T_PARA T_IDENTIFICADOR T_ASIGNACION expresion T_HASTA expresion T_HACER instrucciones T_FPARA{
		};

/* Funciones y Acciones */
accion_d: T_ACCION a_cabecera bloque T_FACCION{
		printf("\tDeclaración de acción\n");
		};
funcion_d: T_FUNCION f_cabecera bloque T_DEV expresion T_FFUNCION{
		printf("\tDeclaración de función\n");
		};
a_cabecera: T_IDENTIFICADOR T_APARENTESIS d_par_form T_CPARENTESIS T_SEC{
		};
f_cabecera: T_IDENTIFICADOR T_APARENTESIS lista_d_var T_CPARENTESIS T_DEV d_tipo T_SEC{
		};
d_par_form: d_p_form T_SEC d_par_form {
		}
	| %empty{
		};
d_p_form: T_ENT lista_id T_DOSPUNTOS d_tipo{
		} 
	| T_SAL lista_id T_DOSPUNTOS d_tipo {
		}
	| T_ENTSAL lista_id T_DOSPUNTOS d_tipo{
		};

accion_ll: T_IDENTIFICADOR T_APARENTESIS l_ll T_CPARENTESIS{
		printf("\tLlamada a una acción\n");
		};
funcion_ll: T_IDENTIFICADOR T_APARENTESIS l_ll T_CPARENTESIS{
		printf("\tLlamada a una función\n");
		};
l_ll: expresion T_SEPARADOR l_ll {
		}
	| expresion{
		};
%%
void yyerror(char const * error)
{
    printf("ERROR: %s\n", error);
}
int main(void)
{
	Simbolo * tablaSimbolos = NULL;
	yyparse();
}
