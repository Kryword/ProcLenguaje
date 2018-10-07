CC=gcc
DEPS=scanner.flex
CFILES=lex.yy.c
LIBS=-lfl
FLEX=flex

default: $(DEPS)
	$(FLEX) $^
	$(CC) $(CFILES) $(LIBS)

clean: 
	rm a.out
	rm lex.yy.c
