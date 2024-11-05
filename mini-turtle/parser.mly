
/* Parsing for mini-Turtle */

%{
  open Ast

%}

/* Declaration of tokens */

%token EOF
/* To be completed */

/* Priorities and associativity of tokens */

/* To be completed */

/* Axiom of the grammar */
%start prog

/* Type of values ​​returned by the parser */
%type <Ast.program> prog

%%

/* Production rules of the grammar */

prog:
  /* To be completed */ EOF
    { { defs = []; main = Sblock [] } (* To be modified *) }
;


