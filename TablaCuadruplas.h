#include <stdio.h>

typedef struct Cuadrupla{
	char *operador;
	int operando1, operando2, resultado;
	struct Cuadrupla* siguiente;
}Cuadrupla;

typedef struct TablaCuadruplas{
	struct Cuadrupla* ultima;
	struct Cuadrupla* primera;
}TablaCuadruplas;

void muestraTablaCuadruplas(TablaCuadruplas tabla);
