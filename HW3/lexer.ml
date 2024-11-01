open A

let tokenize text =
  (* string is text, cur_pos is the current position in the string, last is the last position of the token *)
  let rec find_token string cur_pos =
    if cur_pos < String.length string then
      let b = { text; current = cur_pos; last = -1 } in
      (* prints the token and calls find_token *)
      let tokens_out () =
        let token = String.sub b.text cur_pos (b.last - cur_pos) in
        print_endline ("--> \"" ^ token ^ "\"");
        find_token b.text b.last
      in
      try start b with
      | End_of_file ->
          (* using the last position of the token to check if the token is empty *)
          if b.last > cur_pos then tokens_out ()
          else print_endline "exception End_of_file"
      | Failure msg ->
          if msg = "lexical error" then
            (* using the last position of the token to check if the token is empty *)
            if b.last > cur_pos then tokens_out ()
            else print_endline ("exception Failure(\"" ^ msg ^ "\")")
          else print_endline ("exception Failure(\"" ^ msg ^ "\")")
    else ()
  in
  find_token text 0

let () =
  let text = "abbaaab" in
  print_endline ("string: " ^ text);
  tokenize text;
  print_endline ""

let () =
  let text = "aba" in
  print_endline ("string: " ^ text);
  tokenize text;
  print_endline ""

let () =
  let text = "aac" in
  print_endline ("string: " ^ text);
  tokenize text;
  print_endline ""
