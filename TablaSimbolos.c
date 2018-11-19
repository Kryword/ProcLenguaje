// Importamos stdio para el guardado en 
// fichero y string para el strcmp
#include <stdio.h>
#include <string.h>
#include "TablaSimbolos.h"

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
		sim->id = 0;
		tabla->ultimoId = 0;
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

void muestraTabla(TablaSimbolos tabla){
	printf("///////////////////////////////\n");
	printf("///    Tabla de símbolos    ///\n");
	printf("///////////////////////////////\n");	
	if (tabla.primero == NULL){
		printf("La tabla está vacía.");
	}else{
		Simbolo* puntero = tabla.primero;
		while(puntero->siguiente != NULL){
			printf("ID: %d\tNombre: %s\tTipo: %s\n", puntero->id, puntero->nombre, puntero->tipo);
			puntero = puntero->siguiente;
		}
		printf("ID: %d\tNombre: %s\tTipo: %s\n", puntero->id, puntero->nombre, puntero->tipo);
	}
}

Simbolo* newTemp(){
	// TODO: Por implementar
	Simbolo* simbolo = nuevoSimbolo();
	simbolo->id = 0;
	return simbolo;
}
