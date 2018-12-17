algoritmo restaAños;
    ent n, m: entero;
    sal años: entero;
{Prec: n=N AND m=M AND M >= 0 AND N >= 0}
var 
    añoAnterior, añoFinal:entero;
fvar
    si añoAnterior > añoAnterior->
	años := añoFinal
    [] añoAnterior < añoAnterior->
	años := añoAnterior;
	si años>años->
	    años:=años
	fsi
    [] añoAnterior = añoAnterior->
	años:=añoFinal
    fsi
{Post: n = N AND m = M AND años = |M - N|}
falgoritmo
