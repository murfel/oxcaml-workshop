open! Core
open Await

(* Exercise: rename _data into data, modify data on the initial thread,
   then pass it and modify on one of the fork_join branches,
   then modify it again after the fork_join.
   Do not use atomics or mutexes. *)

(* Solution: whoever holds the [@ unique] key owns the capsule.

   1. On the initial thread, [Key.access] borrows the key and hands it back.
   2. The key is moved into the first branch (the closure is [once], so it can consume
      the unique key). The second branch can't use the key or the data.
   3. A [Key.t] has a [void] layout, so it can't be returned from a branch inside a
      tuple. And even boxed, it would come back [aliased], because [fork_join2] returns
      its results at the default modes. Instead, the branch destroys the key: this merges
      the capsule into the current one and gives a permanent [Access.t]. The branch
      returns that access boxed, and once the join completes, the initial thread uses it
      to modify the data again. *)
let () =
  let (P key) = Capsule.Prim.create () in
  let data = Capsule.Data.create (fun () -> ref 42) in
  (* 1. Modify on the initial thread. *)
  let #((), key) =
    Capsule.Prim.Key.access key ~f:(fun access ->
      let r = Capsule.Data.unwrap ~access data in
      r := !r + 1)
  in
  let run par =
    let #(access, right) =
      Parallel.fork_join2
        par
        (fun _ ->
          (* 2. Modify on a fork_join branch. *)
          let access = Capsule.Prim.Key.destroy key in
          let r = Capsule.Data.unwrap ~access data in
          r := !r * 2;
          Capsule.Prim.Access.box access)
        (fun _ -> 2)
    in
    (* 3. Modify after the fork_join. *)
    let access = Capsule.Prim.Access.unbox access in
    let r = Capsule.Data.unwrap ~access data in
    r := !r + right;
    !r
  in
  let result = Parallel_scheduler.with_parallel run in
  Printf.printf "result: %d\n" result (* prints result: 88, i.e. (42 + 1) * 2 + 2 *)
;;
