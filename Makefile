CC=gcc
DEPS=scanner.l
CFILES=lex.yy.c TablaSimbolos.c TablaCuadruplas.c
OFILES=lex.yy.o TablaSimbolos.o TablaCuadruplas.o
BNAME=gramatica
LIBS=-lfl -lm
FLEX=flex
BISON=bison
BOPTIONS=-v -d -t
TOCLEAN=gramatica.tab.c gramatica.tab.h lex.yy.c lex.yy.o gramatica.output TablaSimbolos.o TablaCuadruplas.o a.out

default: bison flex gramatica.tab.h $(CFILES) definiciones.h
	$(CC) -c $(CFILES)
	$(CC) $(BNAME).tab.c $(OFILES) $(LIBS) 
flex: $(DEPS)
	$(FLEX) $^
bison: $(BNAME).y
	$(BISON) $(BOPTIONS) $^ 
clean: 
	rm $(TOCLEAN)
