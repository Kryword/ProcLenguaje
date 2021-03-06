%{
#include <stdio.h>
#include "TablaSimbolos.h"
#include "TablaCuadruplas.h"
#include <string.h>

/* defines */
#define VACIO -1

/* Declaración de tipos */
typedef struct Cola{
	char* nombre;
	struct Cola* siguiente;
}Cola;
typedef struct ListaEnteros{
	int* lista;
	int length;
}ListaEnteros;

typedef struct Expresion{
	int place;
	char* code;
	char* tipo;
	ListaEnteros* trueExpresion;
	ListaEnteros* falseExpresion;
	ListaEnteros* next;
}Expresion;

/* Declaración de variables */
TablaSimbolos* tablaSimbolos;
TablaCuadruplas* tablaCuadruplas;

/* Declaración de funciones */
int yylex(void);
void yyerror(char const *);
void backpatch(ListaEnteros* listaQuads, int quad);
Cuadrupla* buscarCuadrupla(int id);

ListaEnteros* merge(ListaEnteros* lista1, ListaEnteros* lista2);
ListaEnteros* makelist(int nextquad);
ListaEnteros* makeEmptyList();
%}
%union{
	int entero;
	double real;
	char* union_cadena;
	char** union_cadenas;
	struct Cola* union_cola;
	struct Expresion* union_expresion;
	struct ListaEnteros* union_lista;
	int quad;
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
%type<union_cola>lista_id
%type<union_cola>lista_d_var
%type<union_cadena>lista_campos
%type<entero>operando
%type<union_expresion>expresion
%type<union_expresion>exp
%type<quad>M
%type<union_lista>instrucciones
%type<union_lista>instruccion
%type<union_expresion>alternativa
%type<union_expresion>iteracion
%type<union_expresion>it_cota_exp
%type<union_expresion>lista_opciones
%type<union_expresion>N

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
	| /* empty */;
decl_a_f:accion_d decl_a_f {
		printf("\tDeclaración de Acción\n");
		}
	| funcion_d decl_a_f {
		printf("\tDeclaración de Función\n");
		}
	| /* empty */{
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
	| /* empty */{
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
	| /* empty */{
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
	| /* empty */{
		};

/* Declaración de constantes y variables */
lista_d_cte: T_IDENTIFICADOR T_IGUAL T_LITERAL T_SEC lista_d_cte {
		}
	| /* empty */{
		};

lista_d_var:lista_id T_DOSPUNTOS d_tipo T_SEC lista_d_var{
		Cola* auxCola = $1;
		printf("\tLista de variables: ");
		while (auxCola->siguiente != NULL){
		    printf("%s, ", auxCola->nombre);
		    Simbolo* variable = nuevoSimbolo();
		    variable->nombre = strdup(auxCola->nombre);
		    variable->tipo = strdup($3);
		    variable->entradaSalida = 0;
		    Simbolo* buscado = buscar(auxCola->nombre, tablaSimbolos->primero);
		    if (buscado == NULL){
			insertar(tablaSimbolos, variable);
		    }
		    auxCola = auxCola->siguiente;
		}
		// Obtengo la última variable
		Simbolo* variable = nuevoSimbolo();
		variable->nombre = strdup(auxCola->nombre);
		variable->tipo = strdup($3);
		variable->entradaSalida = 0;
		Simbolo* buscado = buscar(auxCola->nombre, tablaSimbolos->primero);
		if (buscado == NULL){
		    insertar(tablaSimbolos, variable);
		}
		printf(" de tipo %s\n", $3);
		$$ = $1;
		}
	| /* empty */{
		};
lista_id: T_IDENTIFICADOR T_SEPARADOR lista_id {
		char * aux = strdup($1);

		Cola* auxCola = $3;
		while (auxCola->siguiente != NULL){
			auxCola = auxCola->siguiente;
		}
		Cola * sig = (Cola*)malloc(sizeof(Cola));
		sig->siguiente = NULL;
		sig->nombre = strdup($1);
		auxCola->siguiente = sig;
		$$ = $3;
		}
	| T_IDENTIFICADOR{
		$$ = (Cola*)malloc(sizeof(Cola));
		$$->nombre = strdup($1);
		$$->siguiente = NULL;
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
	    // Recorro la lista de variables y las pongo en entrada
	    // Aquí debería generar las cuadruplas correspondientes a la entrada
	    Cola* auxCola = $2;
	    do{
		Simbolo* simbolo = buscar(auxCola->nombre, tablaSimbolos->primero);
		if(simbolo != NULL){
		    simbolo->entradaSalida++;
		    generaCuadrupla("input", simbolo->id, VACIO, VACIO, tablaCuadruplas);
		}
		auxCola = auxCola->siguiente;
	    }while(auxCola!=NULL);
		};
decl_sal: T_SAL lista_d_var{
	    // Recorro la lista de variables y las pongo en salida
	    Cola* auxCola = $2;
	    do{
		Simbolo* simbolo = buscar(auxCola->nombre, tablaSimbolos->primero);
		if(simbolo != NULL){
		    simbolo->entradaSalida+=2;
		}
		auxCola = auxCola->siguiente;
	    }while(auxCola!=NULL);
		};

/* Expresiones */
M: {
	$$ = tablaCuadruplas->nextquad;
};

exp: exp T_PLUS exp {
		Simbolo* t = newTemp(tablaSimbolos);
		$$->place = t->id;
		if (strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "entero")==0){
		    modifica_tipo_TS(t, "entero");
		    generaCuadrupla("+Entero", $1->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "entero";
		}else if(strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "real")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("inttoreal", $1->place, VACIO, $$->place, tablaCuadruplas);
		    generaCuadrupla("+Real", $$->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "entero")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("inttoreal", $3->place, VACIO, $$->place, tablaCuadruplas);
		    generaCuadrupla("+Real", $$->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "real")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("+Real", $1->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}
		}
	| exp T_MINUS exp{
		Simbolo* t = newTemp(tablaSimbolos);
		$$->place = t->id;
		if (strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "entero")==0){
		    modifica_tipo_TS(t, "entero");
		    generaCuadrupla("-Entero", $1->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "entero";
		}else if(strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "real")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("inttoreal", $1->place, VACIO, $$->place, tablaCuadruplas);
		    generaCuadrupla("-Real", $$->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "entero")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("inttoreal", $3->place, VACIO, $$->place, tablaCuadruplas);
		    generaCuadrupla("-Real", $$->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "real")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("-Real", $1->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}
		}
	| exp T_POR exp{
		Simbolo* t = newTemp(tablaSimbolos);
		$$->place = t->id;
		if (strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "entero")==0){
		    modifica_tipo_TS(t, "entero");
		    generaCuadrupla("*Entero", $1->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "entero";
		}else if(strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "real")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("inttoreal", $1->place, VACIO, $$->place, tablaCuadruplas);
		    generaCuadrupla("*Real", $$->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "entero")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("inttoreal", $3->place, VACIO, $$->place, tablaCuadruplas);
		    generaCuadrupla("*Real", $$->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "real")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("*Real", $1->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}
		} 
	| exp T_DIV exp{
		Simbolo* t = newTemp(tablaSimbolos);
		$$->place = t->id;
		$$->tipo = "real";
		modifica_tipo_TS(t, "real");
		if (strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "entero")==0){
		    generaCuadrupla("inttoreal", $1->place, VACIO, $$->place, tablaCuadruplas);
		    Simbolo* t2 = newTemp(tablaSimbolos);
		    modifica_tipo_TS(t2, "real");
		    generaCuadrupla("inttoreal", $3->place, VACIO, t2->id, tablaCuadruplas);
		    generaCuadrupla("/", $$->place, t2->id, $$->place, tablaCuadruplas);
		}else if(strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "real")==0){
		    generaCuadrupla("inttoreal", $1->place, VACIO, $$->place, tablaCuadruplas);
		    generaCuadrupla("/", $$->place, $3->place, $$->place, tablaCuadruplas);
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "entero")==0){
		    generaCuadrupla("inttoreal", $3->place, VACIO, $$->place, tablaCuadruplas);
		    generaCuadrupla("/", $$->place, $3->place, $$->place, tablaCuadruplas);
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "real")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("/", $1->place, $3->place, $$->place, tablaCuadruplas);
		}
		} 
	| exp T_MOD exp {
		// TODO: Añadir verificación de errores en caso de hacer mod de tipos no enteros
		
		Simbolo* t = newTemp(tablaSimbolos);
		$$->place = t->id;
		$$->tipo = "entero";
		modifica_tipo_TS(t, "entero");
		if (strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "entero")==0){
		    generaCuadrupla("mod", $1->place, $3->place, $$->place, tablaCuadruplas);
		}
		}
	| exp T_DIVE exp {
		Simbolo* t = newTemp(tablaSimbolos);
		$$->place = t->id;
		$$->tipo = "entero";
		modifica_tipo_TS(t, "entero");
		if (strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "entero")==0){
		    generaCuadrupla("divE", $1->place, $3->place, $$->place, tablaCuadruplas);
		}
		}
	| T_APARENTESIS exp T_CPARENTESIS {
		$$->place = $2->place;
		$$->tipo = $2->tipo;
		if (strcmp($2->tipo, "bool") == 0){
		    $$->trueExpresion = makelist(tablaCuadruplas->nextquad);
		    $$->falseExpresion = makelist(tablaCuadruplas->nextquad);
		    generaCuadrupla("ifgoto", $2->place, VACIO, VACIO, tablaCuadruplas);
		    generaCuadrupla("goto", VACIO, VACIO, VACIO, tablaCuadruplas);
		}
		}
	| operando{
		$$ = (Expresion*) malloc(sizeof(Expresion));
		$$->place = $1;
		$$->tipo = strdup(consulta_tipo_TS($1, tablaSimbolos->primero));
		}
	| T_LITERAL_NUMERICO {
		
		}
	| T_MINUS exp %prec T_AUXMINUS{
		Simbolo* t = newTemp(tablaSimbolos);
		$$->place = t->id;
		modifica_tipo_TS(t, $2->tipo);
		$$->tipo = $2->tipo;
		if (strcmp($2->tipo, "real")==0){
		    generaCuadrupla("-uReal", $2->place, VACIO, $$->place, tablaCuadruplas);
		}else if (strcmp($2->tipo, "entero")==0){
		    generaCuadrupla("-uEntero", $2->place, VACIO, $$->place, tablaCuadruplas);
		}
		}
	| exp T_BOOLY M exp {
		/* Cabe destacar que estamos creando las expresiones booleanas de la forma que lo hace C, 
		    es decir 0 es falso y 1 es verdadero, no creamos un nuevo tipo booleano. */
		backpatch($1->trueExpresion, $3);
		$$->tipo = strdup("bool");
		$$->falseExpresion = merge($1->falseExpresion, $4->falseExpresion);
		$$->trueExpresion = $4->trueExpresion;
		}
	| exp T_BOOLO M exp {
		backpatch($1->falseExpresion, $3);
		$$->tipo = strdup("bool");
		$$->trueExpresion = merge($1->trueExpresion, $4->trueExpresion);
		$$->falseExpresion = $4->falseExpresion;
		}
	| T_NO exp {
		$$->tipo = strdup("bool");
		$$->trueExpresion = $2->falseExpresion;
		$$->falseExpresion = $2->trueExpresion;
		}
	| T_VERDADERO {
		}
	| T_FALSO {
		}
	| expresion T_OPREL expresion {
		$$->tipo = strdup("bool");
		$$->trueExpresion = makelist(tablaCuadruplas->nextquad);
		$$->falseExpresion = makelist(tablaCuadruplas->nextquad + 1);
		generaCuadrupla("ifgoto", $1->place, $3->place, VACIO, tablaCuadruplas);
		generaCuadrupla("goto", VACIO, VACIO, VACIO, tablaCuadruplas);
		};
expresion: exp{
		} 
	| funcion_ll{
		};

operando: T_IDENTIFICADOR{
		int i = buscarId($1, tablaSimbolos->primero);
		$$ = i;
		} 
	| operando T_PUNTO operando {
		}
	| operando T_ACCESO expresion T_FACCESO {
		}
	| operando T_REF{
		};

/* Instrucciones */
instrucciones: instruccion T_SEC M instrucciones {
		if($1->length > 0){
		    backpatch($1, $3);
		}
		$$ = merge($1, $4);
		}
	| instruccion{
		$$ = makeEmptyList();
		};
instruccion: T_CONTINUAR{
		} 
	| asignacion {
		$$ = makelist(tablaCuadruplas->nextquad-1);
		printf("\tInstrucción de asignación \n");
	}
	| alternativa {
		$$ = $1->next;
		printf("\tInstrucción alternativa\n");
	}
	| iteracion {
		$$ = $1->next;
		printf("\tInstrucción de iteracion\n");
	}
	| accion_ll{
		};
asignacion: operando T_ASIGNACION expresion{
		char* tipoT = strdup(consulta_tipo_TS($1, tablaSimbolos->primero));
		printf("\t\tAsignando %s a %s\n", tipoT, $3->tipo);
		
		if(strcmp(tipoT, $3->tipo)==0){
		    generaCuadrupla(":=", $3->place, VACIO, $1, tablaCuadruplas);
		}else if(strcmp(tipoT, "real")==0 && strcmp($3->tipo, "entero")==0){
		    generaCuadrupla("inttoreal", $3->place, VACIO, $3->place, tablaCuadruplas);
		    generaCuadrupla(":=", $3->place, VACIO, $1, tablaCuadruplas);
		}else{
		    // TODO: Habría que mostrar también la línea en la que se produce este error
		    char* errorT = (char*)malloc(50*sizeof(char));
		    sprintf(errorT, "Asignación de %s a un elemento %s", $3->tipo, tipoT);
		    yyerror(errorT);
		}
		};
alternativa: T_SI expresion T_ENTONCES M instrucciones M lista_opciones T_FSI{
		backpatch($2->trueExpresion, $4);
		backpatch($2->falseExpresion, $6);
		if ($5->length > 0){
		    $$->next = merge($2->falseExpresion, $5);
		}else{
		    $$->next = merge($2->falseExpresion, makelist($6));
		    generaCuadrupla("goto", VACIO, VACIO, VACIO, tablaCuadruplas);
		}
	    };
lista_opciones: T_SINO expresion T_ENTONCES M instrucciones N M lista_opciones{
		backpatch($2->trueExpresion, $4);
		backpatch($2->falseExpresion, $7);
		if ($5->length > 0){
		    $$->next = merge(merge($5, $6->next), $8->next);
		}else{
		    $$->next = merge(merge($8->next, $6->next), makelist(tablaCuadruplas->nextquad));
		    generaCuadrupla("goto", VACIO, VACIO, VACIO, tablaCuadruplas);
		}
	      }
	    | /* empty */{
		$$->next = makeEmptyList();
	    };
N: /*empty*/{
	$$->next = makelist(tablaCuadruplas->nextquad);
	generaCuadrupla("goto", VACIO, VACIO, VACIO, tablaCuadruplas);
    };
iteracion: it_cota_fija {
		} 
	| it_cota_exp{
		};
it_cota_exp: T_MIENTRAS M expresion T_HACER M instrucciones T_FMIENTRAS{
		    backpatch($3->trueExpresion, $5);
		    if ($6->length > 0){
			backpatch($6, $2);
		    }else{
			generaCuadrupla("goto", VACIO, VACIO, $2, tablaCuadruplas);
		    }
		    $$->next = $3->falseExpresion;
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
	| /* empty */{
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

ListaEnteros* makelist(int nextquad){
    ListaEnteros* listaEnteros = (ListaEnteros*)malloc(sizeof(ListaEnteros));
    listaEnteros->lista = (int*)malloc(sizeof(int));
    listaEnteros->lista[0] = nextquad;
    listaEnteros->length = 1;
    return listaEnteros;
}

// Genera una lista vacía
ListaEnteros* makeEmptyList(){
    ListaEnteros* listaEnteros = (ListaEnteros*)malloc(sizeof(ListaEnteros));
    listaEnteros->lista = (int*)malloc(sizeof(int));
    listaEnteros->length = 0;
    return listaEnteros;
}

ListaEnteros* merge(ListaEnteros* lista1, ListaEnteros* lista2){
    ListaEnteros* listaFinal = (ListaEnteros*)malloc(sizeof(ListaEnteros));
    listaFinal->length = lista1->length + lista2->length;
    listaFinal->lista = (int*)malloc(listaFinal->length*sizeof(int));
    int counter = 0;
    for(int i = 0; i < lista1->length; i++){
	listaFinal->lista[counter] = lista1->lista[i];
	counter++;
    }

    for(int i = 0; i < lista2->length;i++){
	listaFinal->lista[counter] = lista2->lista[i];
	counter++;
    }
    return listaFinal;
}

void backpatch(ListaEnteros* listaQuads, int quad){
    for (int i = 0; i < listaQuads->length; i++){
	// Buscamos la cuadrupla a modificar
	Cuadrupla *cuadrupla = buscarCuadrupla(listaQuads->lista[i]);
	if (cuadrupla != NULL){
	    cuadrupla->resultado = quad;
	}
    }
}

Cuadrupla* buscarCuadrupla(int id){
    // Si es 0 devuelvo el primer elemnto
    if (id == 0){
	return tablaCuadruplas->primera;
    }
    //Si es igual a nextquad-1 devuelvo el último elemento
    if (id == tablaCuadruplas->nextquad - 1){
	return tablaCuadruplas->ultima;
    }
    Cuadrupla *cuadrupla = tablaCuadruplas->primera;

    int counter = 0;
    while (counter < id && cuadrupla!=NULL){
	cuadrupla = cuadrupla->siguiente;
	counter++;
    }

    return cuadrupla;
}

void creaCuadruplasOutput(){
    Simbolo* simb = tablaSimbolos->primero;
    while(simb!=NULL){
	if (simb->entradaSalida == 2 || simb->entradaSalida == 3){
	    generaCuadrupla("output", simb->id, VACIO, VACIO, tablaCuadruplas);
	}
	simb = simb->siguiente;
    }
}


int main(void)
{
	tablaSimbolos = (TablaSimbolos*)malloc(sizeof(TablaSimbolos));
	tablaCuadruplas = (TablaCuadruplas*)malloc(sizeof(TablaCuadruplas));

	yyparse();
	// Después de terminar el primer parseo es necesario crear las cuádruplas de output
	creaCuadruplasOutput();

	muestraTabla(*tablaSimbolos);
	printf("\n\n");
	muestraTablaCuadruplas(*tablaCuadruplas);
}
