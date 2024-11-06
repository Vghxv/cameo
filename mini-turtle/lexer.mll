
(* Lexical analyser for mini-Turtle *)

{
  open Lexing
  open Parser

  (* raise exception to report a lexical error *)
  exception Lexing_error of string

  (* note : remember to call the Lexing.new_line function
at each carriage return ('\n' character) *)

}

rule token = parse
  | [' ' '\t']  { token lexbuf }
  | "(*" { comment lexbuf }
  | '\n' { new_line lexbuf; token lexbuf }
  | "//" [^ '\n']* '\n'{ new_line lexbuf; token lexbuf }
  | eof { EOF }

  (* keywords *)
  | "forward" { FORWARD }
  | "turnleft" { TURNLEFT }
  | "turnright" { TURNRIGHT }
  | "color" { COLOR }
  | "penup" { PENUP }
  | "pendown" { PENDOWN }
  | "if" { IF }
  | "else" { ELSE }
  | "repeat" { REPEAT }
  | "def" { DEF }
  | "red" { RED }
  | "blue" { BLUE }
  | "green" { GREEN }
  | "black" { BLACK }
  | "white" { WHITE }
  (* Identifiers *)
  | ['a'-'z' 'A'-'Z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_']* as id {
      ID id
    }

  (* Integer literals *)
  | ['0'-'9']+ as num         { INT (int_of_string num) }
  
  (* operators *)
  | '+' { PLUS }
  | '-' { MINUS }
  | '*' { TIMES }
  | '/' { DIVIDE }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | '{' { LBRACE }
  | '}' { RBRACE }
  | ',' { COMMA }

  (* unexpected character *)
  | _ as c { raise (Lexing_error ("Unexpected character: " ^ Char.escaped c)) }

and comment = parse
  | "*)" { token lexbuf }
  | "(*" { comment lexbuf }
  | '\n' { new_line lexbuf; comment lexbuf }
  | _ { comment lexbuf }
  | eof { raise (Lexing_error "Unexpected end of file in comment") }
