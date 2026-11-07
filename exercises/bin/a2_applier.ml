(* Exercise: implement the [applier] function
   which accepts a pair of a (ref int, function)
   and applies the function to the ref int.

   Add a small usage example for a (ref 42, incrementer) function.
   The incrementer function must increment its argument.

   At which mode should your function accept the pair?
   Annotate the arguments and the [applier] function parameters
   with the strictest modes possible.
*)

let () =
  (* Annotate the modes like let (r @ mode) = ref 42 ... *)
  let r = ref 42 in
  Printf.printf "%d\n" !r
;;
