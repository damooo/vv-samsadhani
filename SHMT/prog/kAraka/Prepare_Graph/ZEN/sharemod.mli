(**************************************************************************)
(*                                                                        *)
(*                 The Zen Computational Linguistics Toolkit              *)
(*                                                                        *)
(*                              G�rard Huet                               *)
(*                                                                        *)
(* �2003 Institut National de Recherche en Informatique et en Automatique *)
(**************************************************************************)

module Sharemod : functor (Quotient:sig type domain; 
                                    value congr: 'a -> 'a -> bool; end) 
-> sig value canon: Quotient.domain -> Quotient.domain; 
   end;



