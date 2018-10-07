default: sample.flex
	flex sample.flex
	gcc lex.yy.c -lfl
clean: 
	rm a.out
	rm lex.yy.c
