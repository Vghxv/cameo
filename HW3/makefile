all:
	ocaml worksheet.ml
	dot -Tpdf autom.dot > autom.pdf
	dot -Tpdf autom2.dot > autom2.pdf
	dot -Tpdf autom3.dot > autom3.pdf
	dot -Tpdf autom4.dot > autom4.pdf
q6:
	ocamlopt a.ml lexer.ml -o a
	./a > q6_out.txt
