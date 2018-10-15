CC=gcc
DEPS=scanner.l
CFILES=lex.yy
BNAME=gramatica
LIBS=-lfl -lm
FLEX=flex
BISON=bison
BOPTIONS=-v -d
TOCLEAN=gramatica.tab.c gramatica.tab.h lex.yy.c lex.yy.o gramatica.output a.out

default: bison flex
	$(CC) -c $(CFILES).c
	$(CC) $(BNAME).tab.c $(CFILES).o $(LIBS) 
flex: $(DEPS)
	$(FLEX) $^
bison: $(BNAME).y
	$(BISON) $(BOPTIONS) $^ 
clean: 
	rm $(TOCLEAN)
