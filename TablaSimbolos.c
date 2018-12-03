// Importamos stdio para el guardado en // fichero y string para el strcmp #include <stdio.h> #include <string.h>
#include "TablaSimbolos.h"
#include <string.h>

/////////////////////////////////////////////
////////	Funciones	    /////////
// A continuación declaro las funciones que 
// voy a utilizar para la tabla de símbolos

// Esta función inserta un nuevo símbolo como
// símbolo siguiente a uno dado. Después cambia
// el puntero siguiente para apuntar a este último
void insertar(TablaSimbolos* tabla, Simbolo* sim){
	sim->siguiente = NULL;
	if (tabla->primero == NULL){
		tabla->primero = sim;
		sim->id = 1;
		tabla->ultimoId = 1;
	}else{
		(tabla->ultimo)->siguiente = sim;
		tabla->ultimoId++;
		sim->id = tabla->ultimoId;
	}
	tabla->ultimo = sim;
}

// Esta función busca en la tabla de símbolos
// el símbolo pedido utilizando el nombre indicado
Simbolo* buscar(char* nombre, Simbolo* tabla){
    // Recorro la tabla entera desde el símbolo que me han dado
    // El símbolo que me han dado se supone que es el comienzo
    // de la tabla de símbolos, es decir, el primer símbolo
    while((tabla != NULL) && (strcmp(nombre, tabla->nombre))){
		tabla = tabla->siguiente;
    }
    return tabla;
}

Simbolo* nuevoSimbolo(){
	Simbolo* simbolo = (Simbolo*)malloc(sizeof(Simbolo));
	return simbolo;
}

int buscarId(char* nombre, Simbolo* tabla){
	Simbolo* sim = buscar(nombre, tabla);
	if (sim != NULL){
		return sim->id;
	}else{
		return 0;
	}
}

void muestraTabla(TablaSimbolos tabla){
	printf("//////////////////////////////////////////////\n");
	printf("||/            Tabla de símbolos           /||\n");
	printf("||////////||//////////////////////||////////||\n");
	printf("||   ID   ||        Nombre        ||  Tipo  ||\n");
	if (tabla.primero == NULL){
		printf("//////////////////////////////////////////////\n");
		printf("La tabla está vacía.");
	}else{
		Simbolo* puntero = tabla.primero;
		while(puntero->siguiente != NULL){
			printf("||%8d||%22s||%8s||\n", puntero->id, puntero->nombre, puntero->tipo);
			//printf("%d", puntero->entradaSalida);
			puntero = puntero->siguiente;
		}
		printf("||%8d||%22s||%8s||\n", puntero->id, puntero->nombre, puntero->tipo);
		printf("//////////////////////////////////////////////\n");
	}
}

Simbolo* buscarSimboloPorId(int id, Simbolo* tabla){
	while((tabla != NULL) && (id != tabla->id)){
		tabla = tabla->siguiente;
	}
	return tabla;
}

Simbolo* newTemp(TablaSimbolos *tablaSimbolos){
	// TODO: Por implementar
	Simbolo* simbolo = nuevoSimbolo();
	simbolo->id = tablaSimbolos->ultimoId + 1;
	simbolo->nombre = (char*)malloc(50*sizeof(char));
	snprintf(simbolo->nombre, 50, "_TMP_%d", simbolo->id);
	insertar(tablaSimbolos, simbolo);
	return simbolo;
}

char* consulta_tipo_TS(int id, Simbolo* tabla){
	while((tabla != NULL) && (id != tabla->id)){
		tabla = tabla->siguiente;
	}
	if (tabla != NULL){
		return tabla->tipo;
	}
}

void modifica_tipo_TS(Simbolo* simb, char* tipo){
	simb->tipo = strdup(tipo);
}
