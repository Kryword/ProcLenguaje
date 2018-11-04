// Importamos stdio para el guardado en 
// fichero y string para el strcmp
#include <stdio.h>
#include <string.h>
#include "TablaSimbolos.h"

/*
 * La estructura utilizada va a ser Simbolo
 * esta representa cada uno de los símbolos
 * de la tabla de símbolos
 */
typedef struct Simbolo
{
    struct Simbolo* siguiente;	// Símbolo siguiente a este, de modo que tengamos una lista
    char* nombre;		// nombre que identifica a dicho símbolo
    char* tipo;			// tipo del símbolo, de momento es un string
    int valor;			// valor del símbolo de tenerlo, esto será un union en un futuro
}Simbolo;

/////////////////////////////////////////////
////////	Funciones	    /////////
// A continuación declaro las funciones que 
// voy a utilizar para la tabla de símbolos

// Esta función inserta un nuevo símbolo como
// símbolo siguiente a uno dado. Después cambia
// el puntero siguiente para apuntar a este último
void insertar(Simbolo** siguiente, Simbolo* sim){
    sim->siguiente = (*siguiente);
    (*siguiente) = sim;
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
