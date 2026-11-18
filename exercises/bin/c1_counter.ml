open! Core
open Await

(* A single [int ref] living in a capsule, protected by a mutex. *)
let counter : int ref Capsule.Sync.With_mutex.t =
  Capsule.Sync.With_mutex.create (fun () -> ref 0)
;;

let writer_iterations = 10_000_000
let reader_iterations = 5

(* Modify the [writer] and the [reader] functions so that [writer] increments the counter
   and the [reader] reads it and prints to the standard output,
   each doing the specified number of iterations.
   Use [Capsule.Sync.With_mutex.with_lock] and [Sync.blocking]. See their usage below.
*)

(* Solution: every access to the counter goes through [with_lock], which acquires the
   mutex and gives [f] the [int ref] inside the capsule. *)
let writer () =
  let sync = Sync.blocking in
  for _ = 1 to writer_iterations do
    Capsule.Sync.With_mutex.with_lock sync counter ~f:(fun _sync counter -> incr counter)
  done
;;

let reader () =
  let sync = Sync.blocking in
  for _ = 1 to reader_iterations do
    let value =
      Capsule.Sync.With_mutex.with_lock sync counter ~f:(fun _sync counter -> !counter)
    in
    printf "reader saw: %d\n%!" value
  done
;;

let run (par : Parallel.t) =
  let #((), ()) =
    Parallel.fork_join2 par (fun _par -> writer ()) (fun _par -> reader ())
  in
  let final =
    Capsule.Sync.With_mutex.with_lock Sync.blocking counter ~f:(fun _sync counter ->
      !counter)
  in
  printf "final value: %d\n" final
;;

let () = Parallel_scheduler.with_parallel run
