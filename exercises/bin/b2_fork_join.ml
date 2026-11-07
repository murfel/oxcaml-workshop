(* A custom [my_fork_join2] that hands each branch its own argument. The arguments are
   captured into closures.

   Exercise: annotate f, g, x, y with @ modes and compile to check yourself.
   Hint: think of the requirements for the nullary functions passed into the real fork_join2,
   and work out the requirements for the custom fork_join2 backwards from there.

   Hover over my_fork_join2 to see the real annotations.
*)
let my_fork_join2
  (par : Parallel.t)
  (f)
  (g)
  (x)
  (y)
  =
  Parallel.fork_join2 par
                      (fun _ -> f x) (* @ shareable *)
                      (fun _ -> g y) (* @ shareable *)
;;

(* First example usage. *)
let example1 (par : Parallel.t) =
  let x = ref 1 in
  let y = ref 10 in
  let #(x', y') =
    my_fork_join2 par (fun arg -> arg.contents + 1) (fun arg -> arg.contents + 1) x y
  in
  Printf.printf "x: %d, y: %d\n" x' y'
;;

let () = Parallel_scheduler.with_parallel example1 (* prints x: 2, y: 11 *)

(* Second example usage. *)
let example2 (par : Parallel.t) =
  let incr r = r := !r + 42 in
  let decr r = r := !r - 10 in
  let #(x', y') =
    my_fork_join2
      par
      (fun f -> let r = ref 0 in f r; !r)
      (fun f -> let r = ref 0 in f r; !r)
      incr
      decr
  in
  Printf.printf "a: %d, b: %d\n" x' y'
;;

(* Uncomment to see if your modes pass this one, too. *)
(* let () = Parallel_scheduler.with_parallel example2 (* prints x: 42, y: -10 *) *)
