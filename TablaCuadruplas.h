#include <stdio.h>

typedef struct Cuadrupla{
	int id;
	char *operador;
	int operando1, operando2, resultado;
	struct Cuadrupla* siguiente;
}Cuadrupla;

typedef struct TablaCuadruplas{
	struct Cuadrupla* ultima;
	struct Cuadrupla* primera;
	int nextquad;
}TablaCuadruplas;

void muestraTablaCuadruplas(TablaCuadruplas tabla);
void generaCuadrupla(char* operador, int operando1, int operando2, int resultado, TablaCuadruplas* tablaCuadruplas);
