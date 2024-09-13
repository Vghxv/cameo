(* 1-a *)
let rec fact n = match n with 0 -> 1 | _ -> n * fact (n - 1)
(* 1-b *)
let nb_bit_pos n =
  let rec aux n acc = match n with 
  | 0 -> acc 
  | _ -> aux (n / 2) (acc + (n mod 2)) in
  aux n 0
(* 2 *)
let fibo n =
  let rec aux n a b = match n with
  | 0 -> a
  | _ -> aux (n - 1) b (a + b) in
  aux n 0 1
(* 3-a *)
let rec reverse l = match l with
  | "" -> "" 
  | _ -> reverse (String.sub l 1 ((String.length l) - 1)) ^ (String.sub l 0 1)
let isPalindrome l = match l with
  | "" -> true
  | _ -> l = reverse l
(* 3-b *)
let rec comparel l1 l2 = match l1, l2 with
  | "", "" -> true
  | "", _ -> false
  | _, "" -> true
  | _ -> 
    if l1.[0] < l2.[0] then 
      false
    else if l1.[0] > l2.[0] then
      true
    else
      comparel (String.sub l1 1 ((String.length l1) - 1)) (String.sub l2 1 ((String.length l2) - 1))
(* 3-c *)
let factor m1 m2 =
  try
    let _ = Str.search_forward (Str.regexp_string m1) m2 0 in
    true
  with Not_found -> false
(* 4-a *)
let rec split l = match l with
  | [] -> [], []
  | [x] -> [x], [] 
  | x :: y :: tl -> let l1, l2 = split tl in x :: l1, y :: l2
(* 4-b *)
let rec merge l1 l2 = match l1, l2 with
  | [], [] -> []
  | [], _ -> l2
  | _, [] -> l1
  | x :: tl1, y :: tl2 -> if x < y then x :: merge tl1 l2 else y :: merge l1 tl2
(* 4-c *)
let rec mergesort l = match l with
  | [] -> []
  | [x] -> [x]
  | _ -> 
    let l1, l2 = split l in
    merge (mergesort l1) (mergesort l2)
(* 5-a *)
let rec square_sum l = match l with
  | [] -> 0
  | x :: tl -> x * x + square_sum tl

let square_sum_no_rec l = List.fold_left (fun acc x -> acc + x * x) 0 l

(* 5-b *)
let find_opt x l = 
  let rec aux index l = match l with
    | [] -> None
    | y :: tl -> if y = x then Some index else aux (index + 1) tl in
  aux 0 l
let find_opt_no_rec x l =
  let _, result = 
    List.fold_left 
      (fun (index, acc) y -> 
          if y = x then (index, Some (index)) 
          else (index + 1, acc)) 
      (0, None) l 
  in
  result
;;
(* 6 *)
(* let rec rev l = match l with
  | [] -> []
  | x :: tl -> rev tl @ [x]

let rec map f l = match l with
  | [] -> []
  | x :: tl -> f x :: map f tl *)
  (* 
  rev Implementation:
  Your rev function uses the @ operator to concatenate lists. This operator has a time complexity of O(n) for the length of the first list. Since rev calls this operation in every recursive step, the overall time complexity becomes O(n^2), which is inefficient for large lists.
  Moreover, this approach is not tail recursive because the concatenation operation (@ [x]) is performed after the recursive call, so it can lead to a stack overflow when reversing very large lists.
  map Implementation:
  
  The map function as you've implemented is not tail recursive because the construction of the list (f x :: map f tl) occurs after the recursive call. This means it will also consume stack space proportional to the size of the list, which can cause a stack overflow for very large lists. *)
let lllll = List.init 1_000_001 (fun i -> i)

let rev l = 
  let rec aux acc l = match l with 
  | [] -> acc
  | x :: tl -> aux (x :: acc) tl
in aux [] l

let map f l =
  let rec aux acc l = match l with
  | [] -> acc
  | x :: tl -> aux (f x :: acc) tl 
in aux [] l
(* 7 *)
type 'a seq = 
| Elt of 'a
| Seq of 'a seq * 'a seq
let (@@) s1 s2 = Seq (s1, s2)


(* 7-a *)
let hd_ s = 
  let rec aux s = match s with
  | Elt x -> x
  | Seq (s1, _) -> aux s1
in aux s

let tl_ s = 
  let rec aux s = match s with
  | Elt x -> x
  | Seq (_, s2) -> aux s2
in aux s

let mem_ x s =
  let rec aux acc x s = match s with
  | Elt y -> if y = x then true else acc
  | Seq (s1, s2) -> aux (aux acc x s1) x s2
in aux false x s

let rec rev_ s = match s with
  | Elt x -> Elt x
  | Seq (s1, s2) -> Seq (rev_ s2, rev_ s1)

let rec map_ f s = match s with
  | Elt x -> Elt (f x)
  | Seq (s1, s2) -> Seq (map_ f s1, map_ f s2)

let rec fold_left_ f acc s = match s with
  | Elt x -> f acc x
  | Seq (s1, s2) -> fold_left_ f (fold_left_ f acc s1) s2

let rec fold_right_ f s acc = match s with
  | Elt x -> f x acc
  | Seq (s1, s2) -> fold_right_ f s1 (fold_right_ f s2 acc)

(* 7-b *)
(* use fold left *)
(* let rec seq2list s = match s with
  | Elt x -> [x]
  | Seq (s1, s2) -> List.fold_left (fun acc x -> x :: acc) (seq2list s2) (seq2list s1) *)
(* tail recursive *)
let rec seq2list_ s =
  let rec aux acc s = match s with
    | Elt x -> x :: acc
    | Seq (s1, s2) -> aux (aux acc s2) s1
  in aux [] s
(* 7-c *)
let find_opt_ x s =
  let rec aux index s = match s with
    | Elt y -> if y = x then Some index else None 
    | Seq (s1, s2) ->
      match aux index s1 with
      | Some i -> Some i
      | None -> aux (index + (count s1)) s2
  and count s = match s with
    | Elt _ -> 1
    | Seq (s1, s2) -> count s1 + count s2
  in aux 0 s
(* 7-d *)
let nth_ s n =
  let rec aux index s = match s with
    | Elt y -> if index = n then Some y else None
    | Seq (s1, s2) ->
      match aux index s1 with
      | Some x -> Some x
      | None -> aux (index + (count s1)) s2
  and count s = match s with
    | Elt _ -> 1
    | Seq (s1, s2) -> count s1 + count s2
  in aux 0 s

let q description f exp = 
  let result = f () in
  Printf.printf "%s: %s : %s\n" description result (if result = exp then "Passed" else "Failed");;

let o2s x = match x with
  | None -> ""
  | Some x -> string_of_int x 
let () = 
  q "fact 5" (fun () -> string_of_int (fact 5)) "120";
  q "nb_bit_pos 5" (fun () -> string_of_int (nb_bit_pos 5)) "2";
  q "fibo 7" (fun () -> string_of_int (fibo 7)) "13";
  q "isPalindrome abba" (fun () -> string_of_bool (isPalindrome "abba")) "true";
  q "isPalindrome bbc" (fun () -> string_of_bool (isPalindrome "bbc")) "false";
  q "comparel bbc abd" (fun () -> string_of_bool (comparel "bbc" "abd")) "true";
  q "comparel abc abd" (fun () -> string_of_bool (comparel "abc" "abd")) "false";
  q "factor abc 123abc456" (fun () -> string_of_bool (factor "abc" "123abc456")) "true";
  q "factor xyz 123abc456" (fun () -> string_of_bool (factor "xyz" "123abc456")) "false";
  let l = [1; 3; 2; 4; 5; 7; 6] in
  let l' = mergesort l in
  q "mergesort" (fun () -> List.fold_left (fun acc x -> acc ^ (string_of_int x) ^ " ") "" l') "1 2 3 4 5 6 7 ";
  let l = [1; 3; 2; 4; 5; 7; 6] in
  q "square_sum" (fun () -> string_of_int (square_sum l)) "140";
  q "square_sum_no_rec" (fun () -> string_of_int (square_sum_no_rec l)) "140";
  let l = [1; 3; 2; 4; 5; 7; 6] in
  q "find_opt 5" (fun () -> string_of_int (Option.get (find_opt 7 l))) "5";
  let l = [1; 3; 2; 4; 5; 7; 6] in
  q "find_opt 5" (fun () -> o2s (find_opt 10 l)) "";
  let l = [1; 3; 2; 4; 5; 7; 6] in
  q "find_opt_no_rec 5" (fun () -> string_of_int (Option.get (find_opt_no_rec 7 l))) "5";
  let l = [1; 3; 2; 4; 5; 7; 6] in
  q "find_opt_no_rec 5" (fun () -> o2s (find_opt_no_rec 10 l)) "";
  let huge1 = rev lllll in
  q "rev" (fun () -> string_of_int (List.hd huge1)) "1000000";
  let huge2 = map (fun x -> x * 2) lllll in
  q "map" (fun () -> string_of_int (List.hd huge2)) "2000000";
  let s = Seq (Elt 1, Seq (Elt 2, Seq (Elt 3, Elt 4))) in
  q "hd" (fun () -> string_of_int (hd_ s)) "1";
  q "tl" (fun () -> string_of_int (tl_ s)) "4";
  q "mem 3" (fun () -> string_of_bool (mem_ 3 s)) "true";
  q "mem 5" (fun () -> string_of_bool (mem_ 5 s)) "false";
  let s = Seq (Elt 1, Seq (Elt 2, Seq (Elt 3, Elt 4))) in
  let s' = rev_ s in
  q "rev_" (fun () -> string_of_int (hd_ s')) "4";
  let s = Seq (Elt 1, Seq (Elt 2, Seq (Elt 3, Elt 4))) in
  let s' = map_ (fun x -> x * 2) s in
  q "map_" (fun () -> string_of_int (hd_ s')) "2";
  let s = Seq (Elt 1, Seq (Elt 2, Seq (Elt 3, Elt 4))) in
  q "fold_left_" (fun () -> string_of_int (fold_left_ (fun acc x -> acc + x) 0 s)) "10";
  let s = Seq (Elt 1, Seq (Elt 2, Seq (Elt 3, Elt 4))) in
  q "fold_right_" (fun () -> string_of_int (fold_right_ (fun x acc -> x + acc) s 0)) "10";
  let s = Seq (Elt 1, Seq (Elt 2, Seq (Elt 3, Elt 4))) in
  q "seq2list_" (fun () -> List.fold_left (fun acc x -> acc ^ (string_of_int x) ^ " ") "" (seq2list_ s)) "1 2 3 4 ";
  let s = Seq (Elt 1, Seq (Elt 2, Seq (Elt 3, Elt 4))) in
  q "find_opt_" (fun () -> string_of_int (Option.get (find_opt_ 3 s))) "2";
  let s = Seq (Elt 1, Seq (Elt 2, Seq (Elt 3, Elt 4))) in
  q "nth_" (fun () -> string_of_int (Option.get (nth_ s 2))) "3";
