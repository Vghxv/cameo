
/* Parsing for mini-Turtle */

%{
  open Ast

%}

/* Declaration of tokens */
%token EOF
%token FORWARD

%token PENUP
%token PENDOWN
%token TURNLEFT
%token TURNRIGHT

%token COLOR
%token RED BLUE GREEN BLACK WHITE

%token IF ELSE LBRACE RBRACE
%token REPEAT
%token DEF

%token <string> ID
%token <int> INT
%token PLUS MINUS TIMES DIVIDE
%token LPAREN RPAREN
%token COMMA

/* Priorities and associativity of tokens */

%left PLUS MINUS
%left TIMES DIVIDE
%nonassoc UMINUS

/* Axiom of the grammar */
%start prog

/* Type of values ​​returned by the parser */
%type <Ast.program> prog
%type <Ast.def list> defs
%type <Ast.def> def
%type <Ast.stmt list> stmts
%type <Ast.stmt> stmt
%type <Ast.expr> expr
%type <Ast.expr list> args
%type <Ast.expr list> arg_list
%type <string list> params
%type <string list> param_list
%%

/* Production rules of the grammar */

// prog is the start symbol of the grammar 
prog:
  defs stmts EOF
      { { defs = $1; main = Sblock $2 } }
;

/* defs is a list of function definitions */
defs:
    /* Empty list of definitions */
    { [] }
  | defs def
      { $1 @ [$2] }
;

// def is a function definition
def:
  DEF ID LPAREN params RPAREN LBRACE stmts RBRACE
    { { name = $2; formals = $4; body = Sblock $7 } }
  | DEF ID LPAREN params RPAREN stmt
    { { name = $2; formals = $4; body = $6 } }
;

// params is a list of parameters
params:
  {[ ]}
  | param_list
  { $1 }
;

// param_list is a list of parameters
param_list:
  ID
    { [$1] }
  | param_list COMMA ID
    { $1 @ [$3] }
;

// stmts is a list of statements
stmts:
  {[ ]}
  | stmts stmt
    { $1 @ [$2] }
;

stmt:
  // forward statement return a Sforward node
  FORWARD expr
    { Sforward $2 }
  | PENUP
    { Spenup }
  | PENDOWN
    { Spendown }
  | TURNLEFT expr
    { Sturn $2 }
  | TURNRIGHT expr
    { Sturn (Ebinop (Sub, Econst 0, $2)) }
  | COLOR color
    { Scolor $2 }
  | IF expr LBRACE stmts RBRACE ELSE LBRACE stmts RBRACE
    { Sif ($2, Sblock $4, Sblock $8) }
  | IF expr LBRACE stmts RBRACE ELSE stmt
    { Sif ($2, Sblock $4, $7) }
  | IF expr LBRACE stmts RBRACE
    { Sif ($2, Sblock $4, Sblock []) }
  | REPEAT expr LBRACE stmts RBRACE
    { Srepeat ($2, Sblock $4) }
  | ID LPAREN args RPAREN
    { Scall ($1, $3) }
;

/* color maps color tokens to Turtle.color values */
color:
    RED   { Turtle.red }
  | BLUE  { Turtle.blue }
  | GREEN { Turtle.green }
  | BLACK { Turtle.black }
  | WHITE { Turtle.white }
;

// expr is an expression
expr:
  expr PLUS expr
    { Ebinop (Add, $1, $3) }
  | expr MINUS expr
    { Ebinop (Sub, $1, $3) }
  | expr TIMES expr
    { Ebinop (Mul, $1, $3) }
  | expr DIVIDE expr
    { Ebinop (Div, $1, $3) }
  | MINUS expr %prec UMINUS
    { Ebinop (Sub, Econst 0, $2) }  /* Translate unary minus */
  | LPAREN expr RPAREN
    { $2 }
  | INT
    { Econst $1 }
  | ID
    { Evar $1 }
;

args:
  {[ ]}
  | arg_list 
    { $1 }
;

arg_list:
  expr
    { [$1] }
  | arg_list COMMA expr
    { $1 @ [$3] }
;