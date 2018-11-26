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

typedef struct TablaSimbolos
{
	struct Simbolo* primero;
	struct Simbolo* ultimo;
	int ultimoId;
}TablaSimbolos;

void insertar (TablaSimbolos* tabla, Simbolo* sim);
Simbolo* buscar(char* nombre, Simbolo* tabla);
int buscarId(char* nombre, Simbolo* tabla);
Simbolo* nuevoSimbolo();
void muestraTabla(TablaSimbolos tabla);
Simbolo* newTemp(TablaSimbolos *tablaSimbolos);
char* consulta_tipo_TS(int id, Simbolo* tabla);
void modifica_tipo_TS(Simbolo* id, char* tipo);
