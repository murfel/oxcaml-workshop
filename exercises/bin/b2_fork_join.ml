(* A custom [my_fork_join2] that hands each branch its own argument. The arguments are
   captured into closures.

   Exercise: annotate f, g, x, y with @ modes and compile to check yourself.
   Hint: think of the requirements for the nullary functions passed into the real fork_join2,
   and work out the requirements for the custom fork_join2 backwards from there.

   Hover over my_fork_join2 to see the real annotations.
*)

(* Solution: the real [fork_join2] takes its two branches [@ shareable], so everything
   they capture ([f], [x] and [g], [y]) must be [@ shareable] as well. Inside a shareable
   closure, captured values are seen as [shared], so [f] and [g] get [x] and [y] at
   [shared] (their inferred types are ['a @ shared -> 'b]); we may as well accept [x] and
   [y] at [shared] too, which lets callers pass already-[shared] values.

   Inferred signature:
     Parallel.t
     -> ('a @ shared -> 'b) @ shareable
     -> ('c @ shared -> 'd) @ shareable
     -> 'a @ shareable shared
     -> 'c @ shareable shared
     -> #('b * 'd)

   Dropping [shared] from [x] and [y] also compiles; they are then accepted only
   [uncontended], which is the default. *)
let my_fork_join2
  (par : Parallel.t)
  (f @ shareable)
  (g @ shareable)
  (x @ shareable shared)
  (y @ shareable shared)
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

let () = Parallel_scheduler.with_parallel example2 (* prints a: 42, b: -10 *)
