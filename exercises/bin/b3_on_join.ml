(* Exercise: create an int ref value, increment it,
   pass it to one of the fork-join branches (how can you use it here?),
   increment it again after the fork-join finishes.

   Can you think of a similar pattern that you know is data-race free, but the compiler
   doesn't let you express it with contention and portability only?

   Hint: you'd be able to express it in plain multicore OCaml,
   without contention/portability restrictions. (No mutexes involved.)
*)

(* Solution: the branches are [shareable] closures, so a captured [ref] is [shared] inside
   them. A branch can read it, but not write to it. Before and after the fork-join, [r] is
   [uncontended] again, so we can write to it.

   Note: read the field directly with [r.contents]: that only needs [r] to be [shared].
   The [(!)] function is declared with an [uncontended] argument, so [!r] doesn't compile
   inside the branch. *)
let run (par : Parallel.t) =
  let r = ref 0 in
  r := !r + 1;
  let #(a, b) = Parallel.fork_join2 par (fun _ -> r.contents + 1) (fun _ -> 0) in
  r := !r + 1;
  Printf.printf "r: %d, a: %d, b: %d\n" !r a b (* prints r: 2, a: 2, b: 0 *)
;;

(* A similar data-race free pattern that does NOT compile: only one branch touches [r],
   and it writes to it. Nobody else accesses [r] until the fork-join finishes, so this is
   safe (and fine in plain multicore OCaml), but writing requires [r] to be
   [uncontended], while the branch only sees it [shared].

   Error: This value is "shared" because it is used inside the function ... which is
     expected to be "shareable". However, the highlighted expression is expected to be
     "uncontended".

   To express this, we need to transfer ownership of [r] to the branch and back. That's
   what capsules are for (see c0_capsules_move_ownership.ml). *)
(* let run_write (par : Parallel.t) =
     let r = ref 0 in
     r := !r + 1;
     let #((), b) = Parallel.fork_join2 par (fun _ -> r := !r + 1) (fun _ -> 0) in
     r := !r + 1;
     Printf.printf "r: %d, b: %d\n" !r b
   ;; *)

let () = Parallel_scheduler.with_parallel run
