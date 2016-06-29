(**************************************************************************)
(*                                                                        *)
(*                 The Zen Computational Linguistics Toolkit              *)
(*                                                                        *)
(*                              G�rard Huet                               *)
(*                                                                        *)
(* �2002 Institut National de Recherche en Informatique et en Automatique *)
(**************************************************************************)

module Share : functor (Algebra:sig type domain; value size: int; end) 
-> sig value share : Algebra.domain -> int -> Algebra.domain; 
       value reset : unit -> unit;
       value memo : array (list Algebra.domain); (* for debugging *) 
   end;



