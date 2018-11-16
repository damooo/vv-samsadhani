(**************************************************************************)
(*                                                                        *)
(*                 The Zen Computational Linguistics Toolkit              *)
(*                                                                        *)
(*                              G�rard Huet                               *)
(*                                                                        *)
(* �2002 Institut National de Recherche en Informatique et en Automatique *)
(**************************************************************************)

(*i Zippers i*)

(*i module Zipper = struct i*)

(* We start with ordered trees.
We assume the mutual inductive types: *)

type tree = [ Tree of arcs ]
and arcs = list tree
;

(* The tree zippers are the contexts of a place holder in the arcs, that
is linked to its left siblings, right siblings, and parent context: *)

type tree_zipper = 
  [ Top
  | Zip of (arcs * tree_zipper * arcs)
  ]
;

(* Let us model access paths in trees by sequences on natural numbers naming
the successive arcs 1, 2, etc. *)

type access = list int
and domain = list access
;

(* We usually define the domain of a tree as the set of accesses of its subterms: *)

(* [ dom : tree -> domain ] *)
value rec dom = fun
  [ Tree arcs -> 
    let doms = List.map dom arcs in
    let f (n,d) dn = let ds = List.map (fun u -> [ n :: u ]) dn 
                     in (n+1,List2.unstack ds d) in
    let (_,d) = List.fold_left f (1,[ [] ]) doms in Word.mirror d
  ]
;

(* Thus, we get for instance: *)

value tree0 = Tree [Tree [Tree []; Tree []]; Tree []]
;
dom(tree0)
;

(* [ -> [[]; [1]; [1; 1]; [1; 2]; [2]] : domain ] *)

(* Now if [rev(u)] is in [dom(t)], we may zip-down [t] along [u]
by changing focus, as follows: *)

type focused_tree = (tree_zipper * tree)
;
value nth_context n = nthc n []
 where rec nthc n l = fun
   [ [] -> raise (Failure "out of domain")
   | [ x :: r ] -> if n = 1 then (l,x,r) else nthc (n-1) [ x :: l] r
   ]
;
value rec enter u t = match u with
  [ [] -> ((Top,t) : focused_tree)
  | [ n :: l ] -> let (z,t1) = enter l t 
                  in match t1 with 
    [ Tree arcs -> let (l,t2,r) = nth_context n arcs 
                   in (Zip(l,z,r),t2)
    ]
  ]
;

(* and now we may for instance navigate in [tree0]: *)
enter [2; 1] tree0
;

(* [ -> (Zip ([Tree []], Zip ([], Top, [Tree []]), []), Tree []): focused_tree ] *)

(* \subsection{Structured edition on focused trees} *)

(* We shall not explicitly use these access stacks and the function [enter];
these access stacks are implicit from the zipper structure, and we shall
navigate in focused trees one step at a time, using the following structure
editor primitives on focused trees. *)

value down (z,t) = match t with
   [ Tree arcs -> match arcs with
     [ [] -> raise (Failure "down")
     | [ hd :: tl ] -> (Zip ([],z,tl),hd)
     ]
   ]
;
value up (z,t) = match z with
   [ Top -> raise (Failure "up")
   | Zip (l,u,r) -> (u, Tree (List2.unstack l [ t :: r ]))
   ]
;
value left (z,t) = match z with
   [ Top -> raise (Failure "left")
   | Zip (l,u,r) -> match l with
      [ [] -> raise (Failure "left")
      | [ elder :: elders ] -> (Zip (elders,u,[ t :: r ]),elder)
      ]
   ]
;
value right (z,t) = match z with
   [ Top -> raise (Failure "right")
   | Zip (l,u,r) -> match r with
      [ [] -> raise (Failure "right")
      | [ younger :: youngers ] -> (Zip ([ t :: l ],u,youngers),younger)
      ]
   ]
;
value del_l (z,_) = match z with
   [ Top -> raise (Failure "del_l")
   | Zip (l,u,r) -> match l with
      [ [] -> raise (Failure "del_l")
      | [ elder :: elders ] -> (Zip (elders,u,r),elder)
      ]
   ]
;
value del_r (z,_) = match z with
   [ Top -> raise (Failure "del_r")
   | Zip (l,u,r) -> match r with
      [ [] -> raise (Failure "del_r")
      | [ younger :: youngers ] -> (Zip (l,u,youngers),younger)
      ]
   ]
;
value replace (z,_) t = (z,t)
;

(* Note how [replace] is a local operation, even though all our programming is applicative. 

\subsection{Zipper operations}

The editing operations above are operations on a finite tree represented
at a focus. But we may also define operations on zippers alone, which may
be thought of as operations on a potentially infinite tree, actually on
all trees, finite or infinite, having this initial context. That is, focused
trees as pairs (context,structure) refer to finite elements (inductive values),
whereas contexts may be seen as finite approximations to streams
(co-inductive values), for instance generated by a process. 
For example, here is an interpreter that takes a command to build 
progressively a zipper context: *)

type context_construction =
  [ Down | Left of tree | Right of tree ]
;
value build z = fun
  [ Down -> Zip ([],z,[])
  | Left t -> match z with
     [ Top -> raise (Failure "build Left")
     | Zip (l,u,r) -> Zip ([ t :: l ],u,r) 
     ]
  | Right t -> match z with
     [ Top -> raise (Failure "build Right")
     | Zip (l,u,r) -> Zip (l,u,[ t :: r ]) 
     ]
  ]
;

(* But we could also add to our commands some destructive operations, to
delete the left or right sibling, or to pop to the upper context.

\subsection{Zippers as linear maps}

We developed the idea that zippers were dual to trees in the sense that
they may be used to represent the approximations to the
coinductive structures corresponding to trees as inductive structures.
We shall now develop the idea that zippers may be seen as linear maps
over trees, in the sense of linear logic. In the same way that a stack 
[st] may be thought of as a representation of the function which, given 
a list [l], returns the list [unstack st l], a zipper
[z] may be thought of as the function which, given a tree
[t], returns the tree [zip_up z t], with: *)

value rec zip_up z t = match z with
  [ Top -> t 
  | Zip (l,up,r) -> zip_up up (Tree (List2.unstack l [ t :: r ])) 
  ]
;

(* Thus [zip_up] may be seen as a coercion between a zipper and a map
   from trees to trees, which is linear by construction.                    *)
(* Alternatively to computing [zip_up z t], we could of course just build
   the focused tree [(z,t)], which is a ``soft'' representation which could 
   be rolled in into [zip_up z t] if an actual term is needed later on.     *)
(* Applying a zipper to a term is akin to substituting the term in the
   place holder represented by the zipper. If we substitute another zipper,
   we obtain zipper composition, as follows. 
   First, we define the reverse of a zipper:                                *)

value rec zip_unstack z1 z2 = match z1 with
  [ Top -> z2
  | Zip (l,z,r) -> zip_unstack z (Zip (l,z2,r)) 
  ]
;
value zip_rev z = zip_unstack z Top
;

(* And now composition is similar to concatenation of lists: *)

value compose z1 z2 = 
  zip_unstack (zip_rev z2) z1
;

(* It is easy to show that [Top] is an identity on the left and on the
   right for composition, and that composition is associative. Thus we get
   a category, whose objects are trees and morphisms are zippers, which
   we call the Zipper category of linear tree maps. *)

(* We end this section by pointing out that tree splicing, or {\sl adjunction}
   in the terminology of Tree Adjoint Grammars, is very naturally expressible
   in this framework. Indeed, what is called a rooted tree in this tradition is
   here directly expressed as a zipper \verb!zroot!, and adjunction at a tree
   occurrence is prepared by decomposing this tree at the given occurrence
   as a focused tree [(z,t)]. Now the adjunction of [zroot] at this occurrence
   is simply computed as: *)

value splice_down (z,t) zroot = (compose z zroot, t)
;

(* if the focus of attention stays at the subtree [t], or *)

value splice_up (z,t) zroot = (z, zip_up zroot t)
;

(* if we want the focus of attention to stay at the adjunction occurrence.
   These two points of view lead to equivalent structures, in the sense
   of tree identity modulo focusing: *)

value equiv (z,t) (z',t') = (zip_up z t = zip_up z' t')
;

(*i end; i*)

