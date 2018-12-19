algoritmo sumacomb;
	ent n, m: entero;
	sal suma: entero;
{Prec: n= N AND m = M AND M >= N >0}
var
	i, comb: entero;
fvar
	i:= i;
	suma:= comb;
	comb:= m;
	mientras i <n hacer
		suma := suma + comb;
		comb := comb * (m - i) div (i);
		i := i
	fmientras
{Post: n =N AND suma = SUMATORIO(i=1..N)(M sobre i)}
falgoritmo
