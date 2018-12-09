#include <stdio.h>
#include <stdlib.h>
#include "TablaCuadruplas.h"
#include <string.h>

void muestraTablaCuadruplas(TablaCuadruplas tabla){
	printf("////////////////////////////////////////////////////////////////////////////\n");
	printf("||                           Tabla de cuadruplas                          ||\n");
	printf("||------------||-------------||-------------||-------------||-------------||\n");
	printf("||     ID     ||   Operador  ||  Operando1  ||  Operando2  ||  Resultado  ||\n");
	if (tabla.primera == NULL){
		printf("////////////////////////////////////////////////////////////////////////////\n");
		printf("La tabla está vacía.");
	}else{
		Cuadrupla* puntero = tabla.primera;
		while(puntero->siguiente != NULL){
			printf("||%12d||%13s||%13d||%13d||%13d||\n", puntero->id, puntero->operador, puntero->operando1, puntero->operando2, puntero->resultado);
			puntero = puntero->siguiente;
		}
		printf("||%12d||%13s||%13d||%13d||%13d||\n", puntero->id, puntero->operador, puntero->operando1, puntero->operando2, puntero->resultado);
		printf("////////////////////////////////////////////////////////////////////////////\n");
	}
}

void generaCuadrupla(char* operador, int operando1, int operando2, int resultado, TablaCuadruplas* tablaCuadruplas){
	Cuadrupla* cuadrupla = (Cuadrupla*)malloc(sizeof(Cuadrupla));
	cuadrupla->operador = strdup(operador);
	cuadrupla->operando1 = operando1;
	cuadrupla->operando2 = operando2;
	cuadrupla->resultado = resultado;
	cuadrupla->siguiente = NULL;
	if (tablaCuadruplas->ultima == NULL){
		tablaCuadruplas->primera = cuadrupla;
		tablaCuadruplas->ultima = cuadrupla;
		cuadrupla->id = 0;
	}else{
		(tablaCuadruplas->ultima)->siguiente = cuadrupla;
		tablaCuadruplas->ultima = cuadrupla;
		cuadrupla->id = tablaCuadruplas->nextquad;
	}
	tablaCuadruplas->nextquad = cuadrupla->id + 1;
}
