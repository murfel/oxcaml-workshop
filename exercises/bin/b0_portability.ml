(* Exercise: decide which lines will compile. Uncomment to check yourself. *)

let counter = ref 0
let greeting = "hello"
let incr_counter () = counter := !counter + 1
let atomic_counter = Atomic.make 0

(* let (p1 @ portable) () = print_endline "hi" *)
(* let (p2 @ portable) () = print_endline greeting *)

(* let (p3 @ portable) () = Printf.printf "%d\n" !counter *)
(* let (p4 @ portable) () = counter := 42 *)

(* let (p5 @ portable) () = incr_counter () *)
(* let (p6 @ portable) () = Atomic.incr atomic_counter *)

(* let (p7 @ portable) () = let r = ref 0 in r := !r + 1; !r *)
