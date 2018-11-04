#include <stdio.h>
#include <stdlib.h>

typedef struct Simbolo Simbolo;
void insertar (Simbolo** siguiente, Simbolo* sim);
Simbolo* buscar(char* nombre, Simbolo* tabla);
