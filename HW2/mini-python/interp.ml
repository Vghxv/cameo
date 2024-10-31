

open Ast
open Format

(* Exception raised to signal a runtime error *)
exception Error of string
let error s = raise (Error s)

(* Values of Mini-Python.

   Two main differences wrt Python:

   - We use here machine integers (OCaml type `int`) while Python
     integers are arbitrary-precision integers (we could use an OCaml
     library for big integers, such as zarith, but we opt for simplicity
     here).

   - What Python calls a ``list'' is a resizeable array. In Mini-Python,
     there is no way to modify the length, so a mere OCaml array can be used.
*)
type value =
  | Vnone
  | Vbool of bool
  | Vint of int
  | Vstring of string
  | Vlist of value array

(* Print a value on standard output *)
let rec print_value = function
  | Vnone -> printf "None"
  | Vbool true -> printf "True"
  | Vbool false -> printf "False"
  | Vint n -> printf "%d" n
  | Vstring s -> printf "%s" s
  | Vlist a ->
    let n = Array.length a in
    printf "[";
    for i = 0 to n-1 do print_value a.(i); if i < n-1 then printf ", " done;
    printf "]"

(* Boolean interpretation of a value

   In Python, any value can be used as a Boolean: None, the integer 0,
   the empty string, and the empty list are all considered to be
   False, and any other value to be True.
*)
let is_false v = match v with
  | Vbool false -> true
  | Vint 0 -> true
  | Vint _ -> false
  | _ -> false(* TODO (question 2) *)

let is_true v = not (is_false v) (* TODO (question 2) *)

(* We only have global functions in Mini-Python *)

let functions = (Hashtbl.create 16 : (string, ident list * stmt) Hashtbl.t)

(* The following exception is used to interpret `return` *)

exception Return of value

(* Local variables (function parameters and local variables introduced
   by assignments) are stored in a hash table that is passed to the
   following OCaml functions as parameter `ctx`. *)

type ctx = (string, value) Hashtbl.t

(* helper functions *)

let rec compare_list a1 n1 a2 n2 i =
  if i = n1 && i = n2 then 0
  else if i = n1 then -1
  else if i = n2 then 1
  else let c =  compare a1.(i) a2.(i) in
    if c <> 0 then c else compare_list a1 n1 a2 n2 (i + 1)

let rec compare_value v1 v2 = match v1, v2 with
  | Vlist a1, Vlist a2 -> compare_list a1 (Array.length a1) a2 (Array.length a2) 0
  | _ -> compare v1 v2

(* Interpreting an expression (returns a value) *)

let rec expr ctx = function
  | Ecst Cnone ->
      Vnone
  | Ecst (Cstring s) ->
      Vstring s
  (* arithmetic *)
  | Ecst (Cint n) ->
        Vint (Int64.to_int n) (* TODO (question 1) *)
  | Ebinop (Badd | Bsub | Bmul | Bdiv | Bmod |
            Beq | Bneq | Blt | Ble | Bgt | Bge as op, e1, e2) ->
      let v1 = expr ctx e1 in
      let v2 = expr ctx e2 in
      begin match op, v1, v2 with
        | Badd, Vint n1, Vint n2 -> Vint (n1 + n2) (* TODO (question 1) *)
        | Bsub, Vint n1, Vint n2 -> Vint (n1 - n2) (* TODO (question 1) *)
        | Bmul, Vint n1, Vint n2 -> Vint (n1 * n2) (* TODO (question 1) *)
        | (Bdiv | Bmod), Vint _, Vint 0 -> error "division by zero" 
        | Bdiv, Vint n1, Vint n2 -> Vint (n1 / n2) (* TODO (question 1) *)
        | Bmod, Vint n1, Vint n2 -> Vint (n1 mod n2) (* TODO (question 1) *)
        | Beq, _, _  -> Vbool (compare_value v1 v2 = 0)(* TODO (question 2) *)
        | Bneq, _, _ -> Vbool (compare_value v1 v2 <> 0) (* TODO (question 2) *)
        | Blt, _, _  -> Vbool (compare_value v1 v2 < 0) (* TODO (question 2) *)
        | Ble, _, _  -> Vbool (compare_value v1 v2 <= 0) (* TODO (question 2) *)
        | Bgt, _, _  -> Vbool (compare_value v1 v2 > 0) (* TODO (question 2) *)
        | Bge, _, _  -> Vbool (compare_value v1 v2 >= 0) (* TODO (question 2) *)
        | Badd, Vstring s1, Vstring s2 ->
            (* Vstring (String.cat s1 s2) *)
            Vstring (s1 ^ s2) 
            (* TODO (question 3) *)
        | Badd, Vlist l1, Vlist l2 ->
            Vlist (Array.append l1 l2)(* TODO (question 5) *)
        | _ -> error "unsupported operand types"
      end
  | Eunop (Uneg, e1) ->
      begin match expr ctx e1 with
      | Vint n -> Vint (-n) 
      | _ -> error "unsupported operand types" end(* TODO (question 1) *)
  (* Boolean *)
  | Ecst (Cbool b) ->
      Vbool b (* TODO (question 2) *)
  | Ebinop (Band, e1, e2) ->
      let v1 = expr ctx e1 in 
        if is_true v1 then expr ctx e2 else v1
        (* TODO (question 2) *)
  | Ebinop (Bor, e1, e2) ->
    (* let v1 = match expr ctx e1 with
      | Vbool b -> b
      | _ -> failwith "Expected boolean expression" 
    in 
    let v2 = match expr ctx e2 with
      | Vbool b -> b
      | _ -> failwith "Expected boolean expression"
    in 
    Vbool (v1 || v2) *)
    let v1 = expr ctx e1 in 
      if is_true v1 then v1 else expr ctx e2
    (* TODO (question 2) *)
  | Eunop (Unot, e1) ->
      let v = match expr ctx e1 with
      | Vbool b -> b 
      | _ -> failwith "Expected boolean expression"
      in 
      Vbool (not (v))(* TODO (question 2) *)
  | Eident {id} ->
      if not (Hashtbl.mem ctx id) then error "unbound variable"; Hashtbl.find ctx id(* TODO (question 3) *)
  (* function call *)
  | Ecall ({id="len"}, [e1]) ->
      begin match expr ctx e1 with
      | Vstring s -> Vint (String.length s)
      | Vlist l -> Vint (Array.length l)
      | _ -> error "this expression has no 'len'" end (* TODO (question 5) *)
  | Ecall ({id="list"}, [Ecall ({id="range"}, [e1])]) ->
      let n = expr_int ctx e1 in 
      Vlist (Array.init (max 0 n) (fun i -> Vint i)) (* TODO (question 5) *)
  | Ecall ({id=f}, el) ->
    if not (Hashtbl.mem functions f) then error ("unknown function " ^ f);
    let args, body = Hashtbl.find functions f in
    if List.length args <> List.length el then error "bad arity";
    let ctx' = Hashtbl.create 16 in
    List.iter2 (fun {id=x} e -> Hashtbl.add ctx' x (expr ctx e)) args el;
    begin try stmt ctx' body; 
      Vnone with Return v -> v end
    (* TODO (question 4) *)
  | Elist el ->
      Vlist (Array.of_list(List.map (expr ctx) el))(* TODO (question 5) *)
  | Eget (e1, e2) ->
      begin match expr ctx e1 with
      | Vlist l ->
        let i = expr_int ctx e2 in
        (try l.(i) with Invalid_argument _ -> error "index out of bounds")
      | _ -> error "list expected" end(* TODO (question 5) *)


and expr_int ctx e = match expr ctx e with
  | Vbool false -> 0
  | Vbool true -> 1
  | Vint n -> n
  | _ -> error "integer expected"
(* Interpreting a statement

   returns nothing but may raise exception `Return` *)

and stmt ctx = function
  | Seval e ->
      ignore (expr ctx e)
  | Sprint e ->
      print_value (expr ctx e); printf "@."
  | Sblock bl ->
      block ctx bl
  | Sif (e, s1, s2) ->
      if is_true( expr ctx e ) then stmt ctx s1 else stmt ctx s2 (* TODO (question 2) *)
  | Sassign ({id}, e1) ->
      Hashtbl.replace ctx id (expr ctx e1)(* TODO (question 3) *)
  | Sreturn e ->
      raise (Return (expr ctx e))(* TODO (question 4) *)
  | Sfor ({id=x}, e, s) ->
      begin match expr ctx e with
      | Vlist l -> Array.iter (fun v -> Hashtbl.replace ctx x v; stmt ctx s) l
      | _ -> error "lits expected" end(* TODO (question 5) *)
  | Sset (e1, e2, e3) ->
      begin match expr ctx e1 with
      | Vlist l -> l.(expr_int ctx e2) <- expr ctx e3
      | _ -> error "list expected" end(* TODO (question 5) *)

(* Interpreting a block (a sequence of statements) *)

and block ctx = function
  | [] -> ()
  | s :: sl -> stmt ctx s; block ctx sl

(* Interpreting a file
   - `dl` is a list of function definitions (see type `def` in ast.ml)
   - `s` is a statement (the toplevel code)
*)

let file (dl, s) =
  (* TODO (question 4) *)
  List.iter (fun (f, args, body) -> Hashtbl.add functions f.id (args, body)) dl;
  stmt (Hashtbl.create 16) s
