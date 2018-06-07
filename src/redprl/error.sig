
(* the  ! takes as argument a ref and returns the value to which it points*)
signature REDPRL_ERROR =
sig
  datatype 'a frag =
     % of string
   | ! of 'a

  type term

  (* exn: exception values *)
  val error : term frag list -> exn
  val format : exn -> string
  
  (* *)
  val annotate : Pos.t option -> exn -> exn
  
  (* *)
  val annotation : exn -> Pos.t option
end
