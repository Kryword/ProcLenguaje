#include <stdio.h>
#include <stdlib.h>
#include "TablaCuadruplas.h"

void muestraTablaCuadruplas(TablaCuadruplas tabla){
	printf("///////////////////////////////\n");
	printf("///   Tabla de cuadruplas   ///\n");
	printf("///////////////////////////////\n");
	if (tabla.primera == NULL){
		printf("La tabla está vacía.");
	}else{
		Cuadrupla* puntero = tabla.primera;
		while(puntero->siguiente != NULL){
			printf("Operador: %s\tOperando1: %s\n", puntero->operador, puntero->operando1);
			puntero = puntero->siguiente;
		}
		printf("Operador: %s\tOperando1: %s\n", puntero->operador, puntero->operando1);
	}
}
