(* This file is auto generated. Do not modify it manually 😼*)

type buffer = { text: string; mutable current: int; mutable last: int }
let next_char b =
  if b.current = String.length b.text then raise End_of_file;
  let c = b.text.[b.current] in
  b.current <- b.current + 1;
  c

let rec state2 b =
  let c = next_char b in
  match c with
  | _ -> failwith "lexical error"

let rec state4 b =
  b.last <- b.current;
  let c = next_char b in
  match c with
  | '#' -> state2 b
  | 'a' -> state3 b
  | _ -> failwith "lexical error"

let rec state1 b =
  b.last <- b.current;
  let c = next_char b in
  match c with
  | '#' -> state2 b
  | 'a' -> state3 b
  | 'b' -> state4 b
  | _ -> failwith "lexical error"

let rec state3 b =
  b.last <- b.current;
  let c = next_char b in
  match c with
  | '#' -> state2 b
  | 'b' -> state4 b
  | _ -> failwith "lexical error"

let start = state1
