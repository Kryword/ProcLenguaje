default: scanner.flex
	flex scanner.flex
	gcc lex.yy.c -lfl
clean: 
	rm a.out
	rm lex.yy.c
