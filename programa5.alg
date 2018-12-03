algoritmo programa5;
ent a, b: entero;
{Prec: Precondicion}
var
	aux:entero;
	tup:tupla prueba:entero; prueba2:real; ftupla;
	c:real;
fvar
	{c:=b;}
	aux:=-b;
	aux:=a+b;
	a:=aux+b;
	c:=aux+c;
	c:=c+c;
	c:=c+aux;

	{expresiones de multiplicación}
	a:=a*a;
	c:=a*c;
	c:=c*a;
	c:=c*c;

	{Expresiones de división}
	a:=a/a;
	c:=a/c;
	c:=c/a;
	c:=c*c;

	{Expresiones de módulo}
	a:=a mod b;

	{Expresión división entera}
	a:=a div b;

	{Error de compilación por asignación de tipos incorrectos}
	a:=c;

	{Expresión relativamente compleja}
	c:=a+b-a/c*c
{Post: Postcondición}
falgoritmo
