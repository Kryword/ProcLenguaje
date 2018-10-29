algoritmo restaAños;
    ent n, m: entero;
    sal años: entero;
{Prec: n=N AND m=M AND M >= 0 AND N >= 0}
var 
    añoAnterior, añoFinal:entero;
    tablaAños: tabla[1..N] de entero;
fvar
    
    {Este programa demuestra el uso de ñ y comentarios
    y también el uso de algún tipo, algunas variables no se usan,
    simplemente están para demostrar la potencia del scanner}

    si n > m -> 
	añoAnterior := m; 
	añoFinal := n
    [] n <= m ->
	añoAnterior := n;
	añoFinal := m
    fsi;
    años := añoFinal - añoAnterior
{Post: n = N AND m = M AND años = |M - N|}
falgoritmo
