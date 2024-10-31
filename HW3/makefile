all:
	ocaml worksheet.ml
	dot -Tpdf autom.dot > autom.pdf
	dot -Tpdf autom2.dot > autom2.pdf
	dot -Tpdf autom3.dot > autom3.pdf

q6:
	ocamlopt a.ml lexer.ml -o a
	./a > q6.txt 