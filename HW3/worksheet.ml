(* question 1 *)
type ichar = char * int

type regexp =
  | Epsilon
  | Character of ichar
  | Union of regexp * regexp
  | Concat of regexp * regexp
  | Star of regexp

(* val null : regexp -> bool *)
let rec null = function
  | Epsilon -> true
  | Character _ -> false
  | Union (r1, r2) -> null r1 || null r2
  | Concat (r1, r2) -> null r1 && null r2
  | Star _ -> true

(* question 2 *)
module Cset = Set.Make (struct
  type t = ichar

  let compare = Stdlib.compare
end)

let rec first = function
  | Epsilon -> Cset.empty
  | Character c -> Cset.singleton c
  | Union (r1, r2) -> Cset.union (first r1) (first r2)
  | Concat (r1, r2) ->
      if null r1 then Cset.union (first r1) (first r2)
      else first r1
        (* if r1 can match epsilon, it is possible that r2 can contribute to the starting characters *)
  | Star r -> first r

let rec last = function
  | Epsilon -> Cset.empty
  | Character c -> Cset.singleton c
  | Union (r1, r2) -> Cset.union (last r1) (last r2)
  | Concat (r1, r2) ->
      if null r2 then Cset.union (last r1) (last r2)
      else last r2
        (* similarly, if r2 can match espilon, it is possible that r1 can contribute to the ending characters *)
  | Star r -> last r

(* question 3 *)
let rec follow c = function
  | Epsilon ->
      Cset.empty
      (* No follow characters for epsilon as it represents an empty match *)
  | Character _ ->
      Cset.empty (* A single character has no follow set on its own *)
  | Union (r1, r2) ->
      (* In a union, the follow set of c in r1 or r2 may contain relevant follow characters,
         so we combine the results from each branch *)
      Cset.union (follow c r1) (follow c r2)
  | Concat (r1, r2) ->
      (* We first find the follow sets of c in both r1 and r2 independently *)
      let follow_r1 = follow c r1 in
      let follow_r2 = follow c r2 in

      (* If c is in the last set of r1, then any characters in the first set of r2
         could follow c, as r2 directly follows r1 in concatenation *)
      let follow_between =
        if Cset.mem c (last r1) then first r2 else Cset.empty
      in

      (* Union the follow sets from r1, the follow set from between, and r2 *)
      Cset.union follow_r1 (Cset.union follow_between follow_r2)
  | Star r ->
      (* In a starred expression, we calculate the follow set within r *)
      let follow_in_r = follow c r in

      (* If c appears in the last set of r, it can be followed by characters in the first set of r
         because the star allows repetition *)
      if Cset.mem c (last r) then Cset.union (first r) follow_in_r
      else follow_in_r

(* question 4 *)
type state = Cset.t (* a state is a set of characters *)

module Cmap = Map.Make (Char) (* dictionary whose keys are characters *)
module Smap = Map.Make (Cset) (* dictionary whose keys are states *)

type autom = {
  start : state;
  trans : state Cmap.t Smap.t;
      (* state dictionary -> (character dictionary -> state) *)
}

let eof = ('#', -1)

let next_state r q c =
  Cset.fold
    (fun ci acc -> Cset.union acc (follow ci r))
    (Cset.filter (fun (ci, _) -> ci = c) q)
    Cset.empty

let make_dfa (r : regexp) : autom =
  let r = Concat (r, Character eof) in
  (* transitions under construction *)
  let trans = ref Smap.empty in
  let rec transitions q =
    if not (Smap.mem q !trans) then (
      (* Compute transitions from q *)
      let char_map =
        Cset.fold
          (fun (c, _) cmap ->
            let next_q = next_state r q c in
            if not (Cset.is_empty next_q) then Cmap.add c next_q cmap
            else Cmap.add c Cset.empty cmap) (* else cmap) *)
          q Cmap.empty
      in

      trans := Smap.add q char_map !trans;
      Cmap.iter (fun _ next_q -> transitions next_q) char_map)
    (* the transitions function constructs all the transitions of the state q,
       if this is the first time q is visited *)
  in

  let q0 = first r in
  transitions q0;
  { start = q0; trans = !trans }

let fprint_state fmt q =
  Cset.iter
    (fun (c, i) ->
      if c = '#' then Format.fprintf fmt "# "
      else Format.fprintf fmt "%c%i " c i)
    q

let fprint_transition fmt q c q' =
  Format.fprintf fmt "\"%a\" -> \"%a\" [label=\"%c\"];@\n" fprint_state q
    fprint_state q' c

let fprint_autom fmt a =
  Format.fprintf fmt "digraph A {@\n";
  Format.fprintf fmt " @[\"%a\" [ shape = \"rect\"];@\n" fprint_state a.start;
  Smap.iter
    (fun q t -> Cmap.iter (fun c q' -> fprint_transition fmt q c q') t)
    a.trans;
  Format.fprintf fmt "@]@\n}@."

let save_autom file a =
  let ch = open_out file in
  Format.fprintf (Format.formatter_of_out_channel ch) "%a" fprint_autom a;
  close_out ch

(* question 5 *)
let rec loop q t = function
  | [] -> Cset.mem eof q
  (* if the list is empty, add a eof to q *)
  | c :: w' -> loop (Cmap.find c (Smap.find q t)) t w'
(* retrive the first element, do `loop` for rest of the w' with transition of the chacacter c*)

let recognize autom w =
  loop autom.start autom.trans (List.init (String.length w) (String.get w))

(* question 6 *)
open Format

let is_accepting state = Cset.mem eof state

let generate filename autom =
  (* Map from state to int *)
  let state_numbers = ref Smap.empty in
  let counter = ref 1 in
  let rec assign_numbers state =
    if not (Smap.mem state !state_numbers) then (
      state_numbers := Smap.add state !counter !state_numbers;
      counter := !counter + 1;
      match Smap.find_opt state autom.trans with
      | Some cmap ->
          Cmap.iter (fun _ next_state -> assign_numbers next_state) cmap
      | None -> ())
  in
  assign_numbers autom.start;

  (* Open the file *)
  let ch = open_out filename in
  let fmt = Format.formatter_of_out_channel ch in

  (* Output prelude *)
  Format.fprintf fmt
    "(* This file is auto generated. Do not modify it manually *)@\n@\n";
  Format.fprintf fmt
    "type buffer = { text: string; mutable current: int; mutable last: int }@\n";
  Format.fprintf fmt "let next_char b =@\n";
  Format.fprintf fmt
    "  if b.current = String.length b.text then raise End_of_file;@\n";
  Format.fprintf fmt "  let c = b.text.[b.current] in@\n";
  Format.fprintf fmt "  b.current <- b.current + 1;@\n";
  Format.fprintf fmt "  c@\n";
  Format.fprintf fmt "@\n";

  (* For each state *)
  Smap.iter
    (fun state n ->
      Format.fprintf fmt "let rec state%d b =@\n" n;
      if is_accepting state then Format.fprintf fmt "  b.last <- b.current;@\n";
      Format.fprintf fmt "  let c = next_char b in@\n";
      let cmap =
        match Smap.find_opt state autom.trans with
        | Some cmap -> cmap
        | None -> Cmap.empty
      in
      (* Generate match statement *)
      Format.fprintf fmt "  match c with@\n";
      (* For each transition *)
      Cmap.iter
        (fun c next_state ->
          let next_n = Smap.find next_state !state_numbers in
          Format.fprintf fmt "  | %C -> state%d b@\n" c next_n)
        cmap;
      Format.fprintf fmt "  | _ -> failwith \"lexical error\"@\n";
      Format.fprintf fmt "@\n")
    !state_numbers;

  (* Output the start function *)
  let start_n = Smap.find autom.start !state_numbers in
  Format.fprintf fmt "let start = state%d@\n" start_n;

  close_out ch

let () =
  (* question 1 *)
  let a = Character ('a', 0) in
  assert (not (null a));
  assert (null (Star a));
  assert (null (Concat (Epsilon, Star Epsilon)));
  assert (null (Union (Epsilon, a)));
  assert (not (null (Concat (a, Star a))));
  print_endline "ex1(null): OK"

let () =
  (* question 2 *)
  let ca = ('a', 0) in
  let cb = ('b', 0) in
  let a = Character ca and b = Character cb in
  let ab = Concat (a, b) in
  let eq = Cset.equal in
  assert (eq (first a) (Cset.singleton ca));
  assert (eq (first ab) (Cset.singleton ca));
  assert (eq (first (Star ab)) (Cset.singleton ca));
  assert (eq (last b) (Cset.singleton cb));
  assert (eq (last ab) (Cset.singleton cb));
  assert (Cset.cardinal (first (Union (a, b))) = 2);
  assert (Cset.cardinal (first (Concat (Star a, b))) = 2);
  assert (Cset.cardinal (last (Concat (a, Star b))) = 2);
  print_endline "ex2(first): OK"

let () =
  (* question 3 *)
  let ca = ('a', 0) and cb = ('b', 0) in
  let a = Character ca and b = Character cb in
  let ab = Concat (a, b) in
  assert (Cset.equal (follow ca ab) (Cset.singleton cb));
  assert (Cset.is_empty (follow cb ab));
  let r = Star (Union (a, b)) in
  assert (Cset.cardinal (follow ca r) = 2);
  assert (Cset.cardinal (follow cb r) = 2);
  let r2 = Star (Concat (a, Star b)) in
  assert (Cset.cardinal (follow cb r2) = 2);
  let r3 = Concat (Star a, b) in
  assert (Cset.cardinal (follow ca r3) = 2);
  print_endline "ex3(follow): OK"

(* question 4 *)
(* (a|b)*a(a|b) *)
let r =
  Concat
    ( Star (Union (Character ('a', 1), Character ('b', 1))),
      Concat (Character ('a', 2), Union (Character ('a', 3), Character ('b', 2)))
    )

let a = make_dfa r
let () = save_autom "autom.dot" a
let () = print_endline "ex4(make_dfa): OK"

(* question 5 *)
let () = assert (recognize a "aa")
let () = assert (recognize a "ab")
let () = assert (recognize a "abababaab")
let () = assert (recognize a "babababab")
let () = assert (recognize a (String.make 1000 'b' ^ "ab"))
let () = assert (not (recognize a ""))
let () = assert (not (recognize a "a"))
let () = assert (not (recognize a "b"))
let () = assert (not (recognize a "ba"))
let () = assert (not (recognize a "aba"))
let () = assert (not (recognize a "abababaaba"))

let r =
  Star
    (Union
       ( Star (Character ('a', 1)),
         Concat
           ( Character ('b', 1),
             Concat (Star (Character ('a', 2)), Character ('b', 2)) ) ))

let a = make_dfa r
let () = save_autom "autom2.dot" a
let () = assert (recognize a "")
let () = assert (recognize a "bb")
let () = assert (recognize a "aaa")
let () = assert (recognize a "aaabbaaababaaa")
let () = assert (recognize a "bbbbbbbbbbbbbb")
let () = assert (recognize a "bbbbabbbbabbbabbb")
let () = assert (not (recognize a "b"))
let () = assert (not (recognize a "ba"))
let () = assert (not (recognize a "ab"))
let () = assert (not (recognize a "aaabbaaaaabaaa"))
let () = assert (not (recognize a "bbbbbbbbbbbbb"))
let () = assert (not (recognize a "bbbbabbbbabbbabbbb"))
let () = print_endline "ex5(recognize): OK"

(* Question 6 *)
let r3 = Concat (Star (Character ('a', 1)), Character ('b', 1))
let a = make_dfa r3
let () = save_autom "autom3.dot" a
let () = generate "a.ml" a
let () = print_endline "ex6(generate): OK"
