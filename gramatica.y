%{
#include <stdio.h>
#include "TablaSimbolos.h"
#include "TablaCuadruplas.h"
#include <string.h>
#include "definiciones.h"
int yylex(void);
void yyerror(char const *);
int* merge(int* lista1, int* lista2);
int* makeList(int nextquad);
void backpatch(int* lista, int quad);
Cuadrupla* buscarCuadrupla(int id);

TablaSimbolos* tablaSimbolos;
TablaCuadruplas* tablaCuadruplas;

typedef struct Cola{
	char* nombre;
	struct Cola* siguiente;
}Cola;
typedef struct Expresion{
	int place;
	char* code;
	char* tipo;
	int* trueExpresion;
	int* falseExpresion;
}Expresion;
%}
%union{
	int entero;
	double real;
	char* union_cadena;
	char** union_cadenas;
	struct Cola* union_cola;
	struct Expresion* union_expresion;
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
		    generaCuadrupla("input", simbolo->id, 0, 0, tablaCuadruplas);
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

exp: exp T_PLUS exp {
		Simbolo* t = newTemp(tablaSimbolos);
		$$->place = t->id;
		if (strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "entero")==0){
		    modifica_tipo_TS(t, "entero");
		    generaCuadrupla("+Entero", $1->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "entero";
		}else if(strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "real")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("inttoreal", $1->place, 0, $$->place, tablaCuadruplas);
		    generaCuadrupla("+Real", $$->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "entero")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("inttoreal", $3->place, 0, $$->place, tablaCuadruplas);
		    generaCuadrupla("+Real", $$->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "real")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("+Real", $1->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}
		printf("\t\tSuma de %s y %s\n", $1->tipo, $3->tipo);
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
		    generaCuadrupla("inttoreal", $1->place, 0, $$->place, tablaCuadruplas);
		    generaCuadrupla("-Real", $$->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "entero")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("inttoreal", $3->place, 0, $$->place, tablaCuadruplas);
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
		    generaCuadrupla("inttoreal", $1->place, 0, $$->place, tablaCuadruplas);
		    generaCuadrupla("*Real", $$->place, $3->place, $$->place, tablaCuadruplas);
		    $$->tipo = "real";
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "entero")==0){
		    modifica_tipo_TS(t, "real");
		    generaCuadrupla("inttoreal", $3->place, 0, $$->place, tablaCuadruplas);
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
		    generaCuadrupla("inttoreal", $1->place, 0, $$->place, tablaCuadruplas);
		    Simbolo* t2 = newTemp(tablaSimbolos);
		    modifica_tipo_TS(t2, "real");
		    generaCuadrupla("inttoreal", $3->place, 0, t2->id, tablaCuadruplas);
		    generaCuadrupla("/", $$->place, t2->id, $$->place, tablaCuadruplas);
		}else if(strcmp($1->tipo, "entero")==0 && strcmp($3->tipo, "real")==0){
		    generaCuadrupla("inttoreal", $1->place, 0, $$->place, tablaCuadruplas);
		    generaCuadrupla("/", $$->place, $3->place, $$->place, tablaCuadruplas);
		}else if(strcmp($1->tipo, "real")==0 && strcmp($3->tipo, "entero")==0){
		    generaCuadrupla("inttoreal", $3->place, 0, $$->place, tablaCuadruplas);
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
		}
	| operando{
		$$ = (Expresion*) malloc(sizeof(Expresion));
		$$->place = $1;
		$$->tipo = strdup(consulta_tipo_TS($1, tablaSimbolos->primero));
		printf("\t\tOperando tipo: %s\n", $$->tipo);
		}
	| T_LITERAL_NUMERICO {
		
		}
	| T_MINUS exp %prec T_AUXMINUS{
		Simbolo* t = newTemp(tablaSimbolos);
		$$->place = t->id;
		modifica_tipo_TS(t, $2->tipo);
		$$->tipo = $2->tipo;
		if (strcmp($2->tipo, "real")==0){
		    generaCuadrupla("-uReal", $2->place, 0, $$->place, tablaCuadruplas);
		}else if (strcmp($2->tipo, "entero")==0){
		    generaCuadrupla("-uEntero", $2->place, 0, $$->place, tablaCuadruplas);
		}
		}
	| exp T_BOOLY exp {
		// TODO: Queda por hacer esta parte, tema 6 página 11
		// TODO: Preguntar por como funciona backpatch
		/* Cabe destacar que estamos creando las expresiones booleanas de la forma que lo hace C, 
		    es decir 0 es falso y 1 es verdadero, no creamos un nuevo tipo booleano. */
		}
	| exp T_BOOLO exp { 
		}
	| T_NO exp {
		}
	| T_VERDADERO {
		/* TODO: Preguntar como se representaría esto */
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
		int i = buscarId($1, tablaSimbolos->primero);
		if(i != 0){
			printf("\t\tEncontrado identificador: %d\n", i);
		}
		$$ = i;
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
		char* tipoT = strdup(consulta_tipo_TS($1, tablaSimbolos->primero));
		printf("\t\tAsignando %s a %s\n", tipoT, $3->tipo);
		
		if(strcmp(tipoT, $3->tipo)==0){
		    generaCuadrupla(":=", $3->place, 0, $1, tablaCuadruplas);
		}else if(strcmp(tipoT, "real")==0 && strcmp($3->tipo, "entero")==0){
		    generaCuadrupla("inttoreal", $3->place, 0, $3->place, tablaCuadruplas);
		    generaCuadrupla(":=", $3->place, 0, $1, tablaCuadruplas);
		}else{
		    // TODO: Habría que mostrar también la línea en la que se produce este error
		    char* errorT = (char*)malloc(50*sizeof(char));
		    sprintf(errorT, "Asignación de %s a un elemento %s", $3->tipo, tipoT);
		    yyerror(errorT);
		}
		};
alternativa: T_SI expresion T_ENTONCES instrucciones lista_opciones T_FSI{
		};
lista_opciones: T_SINO expresion T_ENTONCES instrucciones lista_opciones {
		}
	| /* empty */{
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

//TODO: Verificar que esto funciona siempre
int* makelist(int nextquad){
    int *lista = (int*)malloc(sizeof(int));
    lista[0] = nextquad;
    return lista;
}

// TODO: Esta función no funciona correctamente
int* merge(int* lista1, int* lista2){
    int* listaFinal = (int*)malloc((sizeof(lista1) + sizeof(lista2)) * sizeof(int));
    int counter = 0;
    for(int i = 0; i < sizeof(lista1)/sizeof(int)-1; i++){
	listaFinal[i] = lista1[i];
	counter++;
    }

    for(int i = 0; i < sizeof(lista2)/sizeof(int)-1;i++){
	listaFinal[counter] = lista2[i];
	counter++;
    }
    printf("Merge de listas: %d\n", counter);
    printf("listaFinal[0] = %d\n", listaFinal[0]);
    printf("listaFinal[1] = %d\n", listaFinal[1]);
    printf("listaFinal[2] = %d\n", listaFinal[2]);
    printf("listaFinal[3] = %d\n", listaFinal[3]);

    return listaFinal;
}

/*  
 *   TODO: Preguntar como debería funcionar esto, de momento da errores debido al merge 
 *	y a que desconozco como calcular la cantidad de elementos en el array de ints. 
 *	Quizás sería conveniente crear una estructura nueva para estas listas.
 */
void backpatch(int* lista, int quad){
    printf("%d\n", *lista);
    for (int i = 0; i < sizeof(lista)/sizeof(lista[0]) - 1; i++){
	printf("%d", lista[i]);
	// Buscamos la cuadrupla a modificar
	Cuadrupla *cuadrupla = buscarCuadrupla(lista[i]);
	if (cuadrupla == NULL)
	    printf("Cuadrupla no encontrada\n");
	else
	    printf("\t\tEncontrada cuadrupla %d:%s\n", cuadrupla->id, cuadrupla->operador);
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
	    generaCuadrupla("output", simb->id, 0, 0, tablaCuadruplas);
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
	backpatch(merge(makelist(1), merge(makelist(2), makelist(4))), 5);
}
