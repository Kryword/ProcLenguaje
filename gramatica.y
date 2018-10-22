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
%token T_POST
%token T_VAR
%token T_FVAR
%token T_IGUAL
%token T_TUPLA
%token T_FTUPLA
%token T_ACCESO
%token T_FACCESO
%token T_SUBRANGO
%token T_DE
%token T_TIPOBASE;
%token T_LITERAL;
%token T_SEPARADOR;
%token T_DOSPUNTOS;
%token T_ENT;
%token T_SAL;
%token T_PLUS;
%token T_MINUS;
%token T_POR;
%token T_DIV;
%token T_DIVE;
%token T_MOD;
%token T_APARENTESIS;
%token T_CPARENTESIS;
%token T_LITERAL_NUMERICO;
%token T_BOOLY;
%token T_BOOLO;
%token T_NO;
%token T_VERDADERO;
%token T_FALSO;
%token T_OPREL;
%token T_PUNTO;
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
%token T_REF;
%token T_TABLA;
%%
/* Comienzo de algoritmo y definición del axioma */ 
desc_algoritmo:T_BALGORITMO T_IDENTIFICADOR T_SEC cabecera_alg bloque_alg T_FALGORITMO{printf ("\tAlgoritmo\n");};
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
		}
	| funcion_d decl_a_f {
		}
	| %empty{
		};
bloque: declaraciones instrucciones{
		};
declaraciones: declaracion_tipo declaraciones {
		}
	| declaracion_const declaraciones {
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
		}
	| T_TABLA T_ACCESO expresion_t T_SUBRANGO expresion_t T_FACCESO T_DE d_tipo{
		printf("\tDeclaración de tipo Tabla\n");
	}
	| T_IDENTIFICADOR {
		}
	| expresion_t T_SUBRANGO expresion_t{
		} 
	| T_REF d_tipo {
		}
	| T_TIPOBASE{
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

lista_d_var: lista_id T_DOSPUNTOS T_IDENTIFICADOR T_SEC  lista_d_var {
		}
	| lista_id T_DOSPUNTOS d_tipo T_SEC lista_d_var{
		} 
	| %empty{
		};
lista_id: T_IDENTIFICADOR T_SEPARADOR lista_id {
		}
	| T_IDENTIFICADOR{
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
expresion: exp_a{
		} 
	| exp_b{
		} 
	| funcion_ll{
		};

exp_a: exp_a T_PLUS exp_a {
		}
	| exp_a T_MINUS exp_a{
		}
	| exp_a T_POR exp_a{
		} 
	| exp_a T_DIV exp_a{
		} 
	| exp_a T_MOD exp_a {
		}
	| exp_a T_DIVE exp_a {
		}
	| T_APARENTESIS exp_a T_CPARENTESIS {
		}
	| operando{
		}
	| T_LITERAL_NUMERICO {
		}
	| T_MINUS exp_a{
		};

exp_b: exp_b T_BOOLY exp_b {
		}
	| exp_b T_BOOLO exp_b { 
		}
	| T_NO exp_b {
		}
	/*| operando  {
		}*/
	| T_VERDADERO {
		}
	| T_FALSO {
		}
	| expresion T_OPREL expresion {
		}
	| T_APARENTESIS exp_b T_CPARENTESIS{
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
		printf("\tInstrucción de asignación\n");
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
		};
funcion_d: T_FUNCION f_cabecera bloque T_DEV expresion T_FFUNCION{
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
		};
funcion_ll: T_IDENTIFICADOR T_APARENTESIS l_ll T_CPARENTESIS{
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
	yyparse();
}
