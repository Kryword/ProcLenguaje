CC=gcc
DEPS=scanner.l
CFILES=lex.yy.c
LIBS=-lfl
FLEX=flex

default: $(DEPS)
	$(FLEX) $^
	$(CC) $(CFILES) $(LIBS)

clean: 
	rm a.out
	rm lex.yy.c
