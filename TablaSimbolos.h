#include <stdio.h>
#include <stdlib.h>

/*
 * La estructura utilizada va a ser Simbolo
 * esta representa cada uno de los símbolos
 * de la tabla de símbolos
 */
typedef struct Simbolo
{
    struct Simbolo* siguiente;	// Símbolo siguiente a este, de modo que tengamos una lista
    int id;
    char* nombre;		// nombre que identifica a dicho símbolo
    char* tipo;			// tipo del símbolo, de momento es un string
}Simbolo;

void insertar (Simbolo** siguiente, Simbolo* sim);
Simbolo* buscar(char* nombre, Simbolo* tabla);
