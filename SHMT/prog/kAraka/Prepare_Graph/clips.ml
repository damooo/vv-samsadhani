(* corresponds to assign_kaaraka.clp *)

open Pada_structure; (* clips_head.txt *)

open Bank_lexer; 
module Gram = Camlp4.PreCast.MakeGram Bank_lexer 
;
open Bank_lexer.Token
;
value morphs = Gram.Entry.mk "morphs"
;

(* Grammar of morph_analyses coming from sentence *)

EXTEND Gram
  GLOBAL: morphs;
  morphs:
    [ [ l = morph_rec; `EOI -> l
      | l = morph_rec -> failwith "Wrong morph data"
    ] ] ;
  morph_rec:
    [ [ -> []
      | l = morph_rec; t = morph ->  (* left (terminal) recursion essential *)
        l @ [ t ]
    ] ] ;
  morph:
    [ [ s = sup -> Sup s 
      | w = wif -> Wif w
      | k = kqw -> Kqw k
      | a = avy -> Avy a
      | aw = avywaxXiwa -> AvywaxXiwa aw
      | ak = avykqw -> Avykqw ak
      | w = waxXiwa -> WaxXiwa w
    ] ] ;
  sup:
    [ [ "("; "sup"; "("; "id"; i = INT; ")"; 
                    "("; "mid"; m = INT; ")"; 
                    "("; "word"; w = IDENT; ")"; 
                    "("; "rt"; r = IDENT; ")"; 
                    "("; "lifgam"; ling = IDENT; ")"; 
                    "("; "viBakwiH"; vib = INT; ")"; 
                    "("; "vacanam"; vac = IDENT; ")"; 
                    "("; "level"; lev = INT; ")";
        ")" -> 
        (int_of_string i,int_of_string m,w,r,ling,int_of_string vib,vac,int_of_string lev)
    ] ] ;

(* { id = i; mid = m; word = w; rt = r; lifgam = ling
       ; viBakwiH = vib; vacanam = vac; level = lev } *)
  wif:
    [ [ "("; "wif"; "("; "id"; i = INT; ")"; 
                    "("; "mid"; m = INT; ")"; 
                    "("; "word"; w = IDENT; ")"; 
                    "("; "rt"; r = IDENT; ")"; 
                    "("; "prayogaH"; voice = IDENT; ")"; 
                    "("; "lakAraH"; la = IDENT; ")"; 
                    "("; "puruRaH"; per = IDENT; ")"; 
                    "("; "vacanam"; vac = IDENT; ")"; 
                    "("; "paxI"; padi = IDENT; ")"; 
                    "("; "XAwuH"; rtwithiw = IDENT; ")"; 
                    "("; "gaNaH"; gana = IDENT; ")"; 
                    "("; "sanAxiH"; san = IDENT; ")"; 
                    "("; "level"; lev = INT; ")";
        ")" -> 
        (int_of_string i,int_of_string m,w,r,voice,la,per,vac,padi,rtwithiw,gana,san,int_of_string lev)
    ] ] ;

  kqw:
    [ [ "("; "kqw"; "("; "id"; i = INT; ")"; 
                    "("; "mid"; m = INT; ")"; 
                    "("; "word"; w = IDENT; ")"; 
                    "("; "kqw_vb_rt"; kqwrt = IDENT; ")"; 
                    "("; "kqw_prawyayaH"; kp = IDENT; ")"; 
                    "("; "XAwuH"; rtwithiw = IDENT; ")"; 
                    "("; "gaNaH"; gana = IDENT; ")"; 
                    "("; "rt"; r = IDENT; ")"; 
                    "("; "lifgam"; ling = IDENT; ")"; 
                    "("; "viBakwiH"; vib = INT; ")"; 
                    "("; "vacanam"; vac = IDENT; ")"; 
                    "("; "sanAxiH"; san = IDENT; ")"; 
                    "("; "level"; lev = INT; ")";
        ")" -> 
        (int_of_string i,int_of_string m,w,kqwrt,kp,rtwithiw,gana,r,ling,int_of_string vib,vac,san,int_of_string lev)
    ] ] ;

  avy:
    [ [ "("; "avy"; "("; "id"; i = INT; ")"; 
                    "("; "mid"; m = INT; ")"; 
                    "("; "word"; w = IDENT; ")"; 
                    "("; "rt"; r = IDENT; ")"; 
                    "("; "level"; lev = INT; ")";")" -> 
        (int_of_string i,int_of_string m,w,r,int_of_string lev)
    ] ] ;

  avywaxXiwa:
    [ [ "("; "avywaxXiwa"; "("; "id"; i = INT; ")"; 
                    "("; "mid"; m = INT; ")"; 
                    "("; "word"; w = IDENT; ")"; 
                    "("; "rt"; r = IDENT; ")"; 
                    "("; "waxXiwa_prawyayaH"; taddhita = IDENT; ")"; 
                    "("; "level"; lev = INT; ")";
        ")" -> 
        (int_of_string i,int_of_string m,w,r,taddhita,int_of_string lev)
    ] ] ;

  avykqw:
    [ [ "("; "avykqw"; "("; "id"; i = INT; ")"; 
                       "("; "mid"; m = INT; ")"; 
                       "("; "word"; w = IDENT; ")"; 
                       "("; "rt"; r = IDENT; ")"; 
                       "("; "kqw_prawyayaH"; kqw = IDENT; ")"; 
                       "("; "XAwuH"; rtwithiw = IDENT; ")"; 
                       "("; "gaNaH"; gana = IDENT; ")"; 
                       "("; "sanAxiH"; san = IDENT; ")";
                       "("; "level"; lev = INT; ")";
         ")" -> 
        (int_of_string i,int_of_string m,w,r,kqw,rtwithiw,gana,san,int_of_string lev)
    ] ] ;
  waxXiwa:
    [ [ "("; "waxXiwa"; "("; "id"; i = INT; ")"; 
                        "("; "mid"; m = INT; ")"; 
                        "("; "word"; w = IDENT; ")"; 
                        "("; "rt"; r = IDENT; ")"; 
                        "("; "waxXiwa_prawyayaH"; taddhita = IDENT; ")"; 
                        "("; "waxXiwa_rt"; taddhitart = IDENT; ")"; 
                        "("; "lifgam"; ling = IDENT; ")"; 
                        "("; "viBakwiH"; vib = INT; ")"; 
                        "("; "vacanam"; vac = IDENT; ")";
                        "("; "level"; lev = INT; ")";
        ")" -> 
        (int_of_string i,int_of_string m,w,r,taddhita,taddhitart,ling,int_of_string vib,vac,int_of_string lev)
    ] ] ;
END
;

value analyse strm = let morphs = 
  try Gram.parse morphs Loc.ghost strm with
       [ Loc.Exc_located loc (Error.E msg) -> do
          { output_string stdout "\n\n"
          ; flush stdout 
          ; Format.eprintf "Lexical error: %a in line %a in example \n%!" 
                           Error.print msg Loc.print loc 
          ; failwith "Parsing aborted\n"
          }
       | Loc.Exc_located loc (Stream.Error msg) -> do
          { output_string stdout "\n\n"
          ; flush stdout 
          ; Format.eprintf "Syntax error: %s in example \n%!" msg 
          ; failwith "Parsing aborted\n"
          }
       | Loc.Exc_located loc ex -> do
          { output_string stdout "\n"
          ; flush stdout 
          ; Format.eprintf "Fatal error in example \n%!" 
          ; raise ex
          }
       | ex -> raise ex
       ]  in morphs
;

value print_relation = fun
  [ Relation (i1 , i2 , i3 , i4 , i5 , i6)  -> do
             { print_string "("
             ; print_int i1; print_string " "
             ; print_int i2; print_string " "
             ; print_int i3; print_string " "
             ; print_int i4; print_string " "
             ; print_int i5; print_string ") #"
             ; print_string i6; print_string " \n"
             }
  ]
;
 value rec print_relation_list = fun 
  [ [] -> ()
  | [ r :: l ] -> do { print_relation r
                     ; print_relation_list l
                     }
  ]
;
(* Not being used 
value print_morph_id = fun
  [ Sup (id,mid,word,rt,lifgam,viBakwiH,vacanam,level) -> print_int id
  | Wif (id,mid,word,rt,prayogaH,lakAraH,puruRaH,vacanam,paxI,dhatu,gaNaH,sanAxiH,level) -> print_int id
  | Kqw (id,mid,word,kqwrt,kp,dhatu,gaNaH,rt,lifgam,viBakwiH,vacanam,sanAxiH,level) -> print_int id
  | Avy (id,mid,word,rt,level) -> print_int id
  | AvywaxXiwa (id,mid,word,rt,taddhita,level) -> print_int id
  | Avykqw (id,mid,word,rt,kqw,dhatu,gaNaH,sanAxiH,level) -> print_int id
  | WaxXiwa (id,mid,word,rt,taddhita,taddhitart,lifgam,viBakwiH,vacanam,level) -> print_int id
  ]
;
*)
value pronominal12 rt = (rt="yuRmax" || rt="asmax")
;
value pronominal123 rt = (rt="yuRmax" || rt="asmax" || rt="yaw" || rt="waw")
;
value aBihiwa rt vac1 vac2 per = (vac1=vac2) &&  
                                 (     ((per="ma") && (rt = "yuRmax")) 
                                    || ((per="u") && (rt = "asmax")) 
                                    || ((per="pra") && 
                                        not (rt = "asmax") &&
                                        not (rt = "yuRmax")
				       )
				 )
;
value noun_agreement rt vac1 vac2 gen1 gen2 =    (vac1=vac2)
                                              && (gen1=gen2) 
                                              && (not (pronominal12 rt))
;
value noun_agreement_vibh rt vac1 vac2 gen1 gen2 vib1 vib2 =    (vac1=vac2)
                                                             && (gen1=gen2)
                                                             && (vib1=vib2)
                                                             && (not (pronominal12 rt))
;
value populate_from file trie =
  let ic = open_in file in
  try while True do { let word = Transduction.code_raw_WX (input_line ic) 
                    ; trie.val := Trie.enter trie.val word
                    }
  with [ End_of_file -> close_in ic ]
  ; 

value build_trie file = 
  let trie = ref Trie.empty in
      do { populate_from file trie
         ; (trie.val)
         }
;

value member_of word trie =
       Trie.mem (Transduction.code_raw_WX word) trie
;
    
value kriyAviSeRaNas = build_trie "DATA/kriyAviSeRaNa_list"
;

value xvikarmakas1 = build_trie "DATA/xvikarmaka_XAwu_list1"
;

value xvikarmakas2 = build_trie "DATA/xvikarmaka_XAwu_list2"
;

value sakarmaka_verbs =  build_trie "DATA/sakarmaka_XAwu_list"
;

value karaNa_verbs = build_trie "DATA/karaNa_XAwu_list"
;

value sampraxAna_verbs = build_trie "DATA/sampraxAna_XAwu_list"
;

value apAxAna_verbs = build_trie "DATA/apAxAna_XAwu_list"
;

value kAlAXikaraNas = build_trie "DATA/kAlAXikaraNa_list"
;

value xeSAXikaraNas = build_trie "DATA/xeSAXikaraNa_list"
;

value shashthii_kqw_verbs = build_trie "DATA/RaRTI_kqw_list"
;

value karwari_karmaNi_kwa_verbs = build_trie "DATA/karwari_karmaNi_kwa_XAwu_list"
;

value gawibuxXi_verbs = build_trie "DATA/gawibuxXi_XAwu_list"
;

value karwqkarmaBAvakwa_verbs = build_trie "DATA/karwq_karma_BAva_kwa_list"
;

value karmakqw_verbs = build_trie "DATA/karma_kqw_list"
;

value bhAva_kqw_verbs = build_trie "DATA/BAva_kqw_list"
;

value avy_verb_list = build_trie "DATA/avy_verb_list"
;

value akarmaka_verbs = build_trie "DATA/akarmaka_XAwu_list"
;

value samboXana_sUcaka = build_trie "DATA/samboXana_sUcaka_list"
;

value avy_viSeRaNam_list = build_trie "DATA/avy_viSeRaNam_list"
;

value viRayAXikaraNa_verbs = build_trie "DATA/viRayAXikaraNa_XAwu_list"
;

value upapaxa2_list = build_trie "DATA/upapaxa_2"
;

value upapaxa3_list = build_trie "DATA/upapaxa_3"
;

value upapaxa4_list = build_trie "DATA/upapaxa_4"
;

value upapaxa5_list = build_trie "DATA/upapaxa_5"
;

value upapaxa6_list = build_trie "DATA/upapaxa_6"
;

value upapaxa7_list = build_trie "DATA/upapaxa_7"
;

value aXikaraNas = build_trie "DATA/upapaxa_aXikaraNa_list"
;

value upapaxa_viSeRaNas = build_trie "DATA/upapaxa_viSeRaNa_list"
;

value shakAxi = build_trie "DATA/SakAxi_list" (* Ocaml does not allow variables starting with Caps. Hence SakAxi -> shakAxi *)
;

value relations_encodings = [   ("upapaxasambanXaH",1);
				("samAnakAlaH",2);
				("prawiyogI",3);
				("sahAyakakriyA",4);
				("vIpsA",5);
(* kAraka region: There can be only one kaaraka *)
				("karwA",7);
				("karwqsamAnAXikaraNam",8);
 (* Note the order of karwA and kawqsamAnAXikaraNa
     aSvaH SvewaH aswi: with these wts, cost = 14+8 = 22
     If it were reverse, cost = 16 + 7 = 23 *)
				("karmasamAnAXikaraNam",9);
(* To handle the dvikarmaka verbs, we need gONa and muKya karma *)
				("gONakarma",10);
				("muKyakarma",11);
				("karma",12);
				("prayojakakarwA",13);
				("prayojyakarwA",14);
				("kriyAviSeRaNam",15);
				("karaNam",18);
				("sampraxAnam",19);
				("apAxAnam",20);
(* There can be more than one of the each of the following *)
				("xeSAXikaraNam",21);
(* No rule for xeSAXikaraNam yet *)
				("kAlAXikaraNam",22);
				("viRayAXikaraNam",23);
(* No rule for viRayAXikaraNam yet *)
				("aXikaraNam",24);
				("sambanXaH",26);
				("hewuH",28);
				("samucciwam1",31);
				("samucciwam2",32);
				("samucciwam3",33);
				("samucciwam4",34);
				("samucciwam5",35);
				("samucciwam6",36);
				("samucciwam7",37);
				("samucciwamviSeRaNam",38);
				("samucciwamprayojanam",39);
				("samucciwamhewu",40);
				("samucciwamkriyA",41);
				("anyawaraH",42);
				("prayojanam",43);
				("anuyogI",44);
				("pUrvakAlaH",45);
				("wAxarWyam",46);
				("niReXyaH",47);
				("samboXanasUcakam",48);
				("samboXyaH",49);
  (*				("vikAryakarma",50);  Not Used *)
				("viSeRaNam",51);
				("RaRTIsambanXaH",52);
				("vAkyasamucciwam",61);
				("ananwarakAlaH",62);
				("maXyasWakarwA",64);
				("nirXAraNam",65);
				("BAvalakRaNasapwamI",75);
				("niwya_sambanXaH",99);
				("sahakAraka",100);
                            ]
(* kAraka_names.txt contains this list, all the notes from that file are to copied to this  17 Nov 2013*)
;
value encode rel = List.assoc rel relations_encodings
;

value rlwifaBihiwa m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,puruRaH2,vacanam2,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,rt1,_,_,_,viBakwiH1,vacanam1,_) 
     | Kqw (id1,mid1,_,rt1,_,_,_,_,_,viBakwiH1,vacanam1,_,_)
     | Sup (id1,mid1,_,rt1,_,viBakwiH1,vacanam1,_) -> 
       if (id1<id2) && (viBakwiH1=1) && (aBihiwa rt1 vacanam1 vacanam2 puruRaH2)
       then if (prayogaH2="karwari") 
            then if (sanAxiH2="Nic") 
                 then [ Relation (id1,mid1,encode "prayojakakarwA",id2,mid2,"1.4.56; 2.3...;rlwifaBihiwa1")]
                 else [ Relation (id1,mid1,encode "karwA",id2,mid2,"rlwifaBihiwa2")]
            else if(prayogaH2="karmaNi")
                 then if (sanAxiH2="Nic") 
                      then [ Relation (id1,mid1,encode "prayojyakarwA",id2,mid2,"rlwifaBihiwa3")]
                      else if (member_of rt2 xvikarmakas2)
                           then [ Relation (id1,mid1,encode "muKyakarma",id2,mid2,"rlwifaBihiwa4")]
                           else if (member_of rt2 xvikarmakas1)
                                then [ Relation (id1,mid1,encode "gONakarma",id2,mid2,"rlwifaBihiwa5")]
	                         else if ((not (member_of rt1 kriyAviSeRaNas)) && (member_of rt1 sakarmaka_verbs))
                                      then [ Relation (id1,mid1,encode "karma",id2,mid2,"rlwifaBihiwa6")]
		                      else []
	         else []
       else []
      | _ -> []
      ]
  | _ -> []
  ]
  ;
value rlkqwaBihiwa m1 m2 = match m2 with
  [ Kqw (id2,mid2,_,rt2,kqw2,_,_,_,lifgam2,viBakwiH2,vacanam2,_,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,rt1,_,_,lifgam1,viBakwiH1,vacanam1,_) 
     | Kqw (id1,mid1,_,rt1,_,_,_,_,lifgam1,viBakwiH1,vacanam1,_,_)
     | Sup (id1,mid1,_,rt1,lifgam1,viBakwiH1,vacanam1,_) -> 
       if    (id1<id2) && (viBakwiH1=1) 
          && (noun_agreement rt1 vacanam1 vacanam2 lifgam1 lifgam2)
       then match kqw2 with
       [ "kwa" -> if (member_of rt2 karwqkarmaBAvakwa_verbs)
                  then [ Relation (id1,mid1,encode "karwA",id2,mid2,"rlkqwaBihiwa1")
                       ; Relation (id1,mid1,encode "karma",id2,mid2,"rlkqwaBihiwa2")
                       ]
                  else if (member_of rt2 akarmaka_verbs)
                       then if (member_of rt2 sakarmaka_verbs)
                            then [ Relation (id1,mid1,encode "karwA",id2,mid2,"rlkqwaBihiwa3")
                                 ; Relation (id1,mid1,encode "karma",id2,mid2,"rlkqwaBihiwa4")
                                 ]
                            else [ Relation (id1,mid1,encode "karwA",id2,mid2,"rlkqwaBihiwa5")]
                       else if (member_of rt2 sakarmaka_verbs)
                            then [ Relation (id1,mid1,encode "karwA",id2,mid2,"rlkqwaBihiwa6")
                                 ; Relation (id1,mid1,encode "karma",id2,mid2,"rlkqwaBihiwa7")
				 ]
                            else []
      | "wavya"  
      | "wavyaw"  
      | "anIyar"  
      | "yaw"  
      | "kyap"  
      | "Nyaw"  -> if (member_of rt2 sakarmaka_verbs)
                  then [ Relation (id1,mid1,encode "karma",id2,mid2,"rlkqwaBihiwa8")]
                  else []
      | "Kal"   -> if (member_of rt2 sakarmaka_verbs)
                  then [ Relation (id1,mid1,encode "karma",id2,mid2,"rlkqwaBihiwa9")]
                  else []
      | "yuc"   -> if (member_of rt2 sakarmaka_verbs)
                  then [ Relation (id1,mid1,encode "karma",id2,mid2,"rlkqwaBihiwa10")]
		  else []
      | _ -> [ Relation (id1,mid1,encode "karwA",id2,mid2,"rlkqwaBihiwa11")]
      ]
      else []
     | _ -> []
     ]
  | _ -> []
  ]
;
(* Verb - Noun relations:

   Examples: vqkRAw parNam pawawi
   ;grAmAw gawam rAmam SyAmaH paSyawi 
   ;grAmawaH SyAmaH AgacCawi
   Paninian sutra: apAxAne paFcamI

   Examples: piwA rAmAya puswakam xaxAwi
            ;piwA rAmAya xAwum puswakam krINAwi
            ;piwA rAmAya xawwam Palam KAxawi 
   Paninian sutra: sampraxAne cawurWI 

   Example: rAmaH xAwreNa pAxapam lunAwi
            rAmaH SyAmena xAwreNa lunam pAxapam paSyawi 
   Paninian sutra: (karwq)karaNayoH wqwIyA

   Examples: rAmaH aXyayanena grAme vasawi
             jIviwasya hewoH api Xarmam na wyajew.
   Paninian sutra: 

  Examples: vqkRe sWiwam rAmam SyAmaH kaWAm kaWayawi
            ;kapiH vqkRe vasawi
            ;grAme vasiwum rAmaH icCawi
  Paninian sutra: AXAro aXikaraNam

  Examples:rAmaH yuxXAya wvarayA/vegena gacCawi.
           rAmaH brAhmaNAya paTanAya puswakam xaxAwi.
  Paninian sutra:  (prayojana) 
 
  rAmaH SyAmasya gqham gacCawi
  Paninian sutra: ReRe RaRTI
*)
value rlanaBihiwe m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,sanAxiH2,_)
  | Kqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,sanAxiH2,_)
  | Avykqw (id2,mid2,_,rt2,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ Sup (id1,mid1,word1,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,word1,_,_,_,_,_,_,viBakwiH1,_,_,_)
     | WaxXiwa (id1,mid1,word1,_,_,_,_,viBakwiH1,_,_) -> 
       if (id1 < id2) 
       then match viBakwiH1 with
       [ 3 ->  if (not (member_of word1 kriyAviSeRaNas))
               then if (member_of rt2 karaNa_verbs)
                    then [ Relation (id1,mid1,encode "karaNam",id2,mid2,"rlanaBihiwe1")
                              (* ; Relation (id1,mid1,encode "hewuH",id2,mid2,"rlanaBihiwe2") *)
                         ]
                    else [Relation (id1,mid1,encode "hewuH",id2,mid2,"rlanaBihiwe3")]
               else []
       | 4 ->  if (member_of rt2 sampraxAna_verbs)
               then [ Relation (id1,mid1,encode "sampraxAnam",id2,mid2,"rlanaBihiwe4")
                    (*; Relation (id1,mid1,encode "prayojanam",id2,mid2,"rlanaBihiwe5") *)
                    ]
               else [ Relation (id1,mid1,encode "prayojanam",id2,mid2,"rlanaBihiwe6")]
       | 5 ->  if (member_of rt2 apAxAna_verbs)
               then [ Relation (id1,mid1,encode "apAxAnam",id2,mid2,"rlanaBihiwe7")
                        (* ; Relation (id1,mid1,encode "hewuH",id2,mid2,"rlanaBihiwe8") *)
                    ]
               else [ Relation (id1,mid1,encode "hewuH",id2,mid2,"rlanaBihiwe9")]
              (* Handle prAsAxAw prekRyawe and AsanAw prekRyawe *)
       | 7  -> if (member_of word1 kAlAXikaraNas)
               then [ Relation (id1,mid1,encode "kAlAXikaraNam",id2,mid2,"rlanaBihiwe10")]
               else if (member_of word1 xeSAXikaraNas)
                    then [ Relation (id1,mid1,encode "xeSAXikaraNam",id2,mid2,"rlanaBihiwe11")]
                    else if (member_of rt2 viRayAXikaraNa_verbs)
                         then [ Relation (id1,mid1,encode "viRayAXikaraNam",id2,mid2,"rlanaBihiwe12")]
                         else [ Relation (id1,mid1,encode "aXikaraNam",id2,mid2,"rlanaBihiwe13")]
       | 8 ->  [ Relation (id1,mid1,encode "samboXyaH",id2,mid2,"rlanaBihiwe14")]

       | 1
       | 2
       | _ -> [] (* raise an exception *)
       ]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* old name: assign_apAxAna_wasil *)
(* Examples: grAmawaH ganwum icCanwam rAmam SyAmaH kaWAm kaWayawi *)
(* Paninian sutra:  *)

value rlapAxAna_wasil m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_) 
  | Avykqw (id2,mid2,_,rt2,_,_,_,_,_) ->
     match m1 with
     [ AvywaxXiwa (id1,mid1,_,_,taddhita1,_)->
       if id1<id2 && (taddhita1="wasil") && (member_of rt2 apAxAna_verbs)
       then [ Relation (id1,mid1,encode "apAxAnam",id2,mid2,"apAxAnam1")]
       else []
     |_ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_kriyA_viSeRaNa *)
(* aSvaH vegena XAvawi.*)
(* ;rAmaH brAhmaNavaw aXIwe *)
value rlkriyAviSeRaNam_or_aXikaraNam m1 m2 = match m2 with
  [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,_,_,_,_,_,_) ->
     match m1 with
     [ Sup (id1,mid1,word1,_,_,_,_,_)
     | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,_,_,_)
     | Avykqw (id1,mid1,word1,_,_,_,_,_,_)
     | Avy (id1,mid1,word1,_,_) -> 
       if id1<id2 && (member_of word1 kriyAviSeRaNas)
       then [ Relation (id1,mid1,encode "kriyAviSeRaNam",id2,mid2,"kriyAviSeRaNam1")]
       else if id1<id2 && (member_of word1 aXikaraNas)
            then [ Relation (id1,mid1,encode "aXikaraNam",id2,mid2,"aXikaraNam1")]
            else []
     | AvywaxXiwa (id1,mid1,word1,_,taddhita1,_) -> 
       if id1<id2 && (member_of word1 kriyAviSeRaNas)
       then [ Relation (id1,mid1,encode "kriyAviSeRaNam",id2,mid2,"kriyAviSeRaNam2")]
       else if id1<id2 && (taddhita1="vawup")
       then [ Relation (id1,mid1,encode "kriyAviSeRaNam",id2,mid2,"kriyAviSeRaNam3")]
       else if id1<id2 && (member_of word1 aXikaraNas)
            then [ Relation (id1,mid1,encode "aXikaraNam",id2,mid2,"aXikaraNam2")]
            else []
     |_ -> []
     ]
  | _ -> []
  ]
  ;

(* rAme vanam gawe sawi sIwA api gacCawi *)
value rlBAvalakRaNa_sapwamI1 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_) ->
     match m1 with
     [ Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if (viBakwiH1=7) 
       then [ Relation (id1,mid1,encode "BAvalakRaNasapwamI",id2,mid2,"2.3.36;2.3.37;rlBAvalakRanasapwamI1")]
       else if (viBakwiH1=6)
            then [ Relation (id1,mid1,encode "BAvalakRaNasapwamI",id2,mid2,"2.3.37;rlBAvalakRanasapwamI1")]
            else []
     | _ -> []
     ]
  | _ -> []
  ]
;
value rlBAvalakRaNa_sapwamI2 m1 m2 = match m2 with
  [ Kqw (id2,mid2,_,_,_,_,_,_,_,viBakwiH2,_,_,_) ->
     match m1 with
     [ Sup (id1,mid1,_,_,_,viBakwiH1,_,_) ->
       if ((viBakwiH1=viBakwiH2) && ((viBakwiH1=7)||(viBakwiH1=6)))
       then [ Relation (id1,mid1,encode "karwA",id2,mid2,"rlBAvalakRanasapwamI2")
            ; Relation (id1,mid1,encode "karma",id2,mid2,"rlBAvalakRanasapwamI2")
            ]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
;

(* assign_avykqw_pUrvakAlInawva *)
(* rAmaH xugXam pIwvA vanam gacCawi *)
(* assign_assign_prayojana_avykqw *)
value rlpUrvakAla m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,rt2,_,_,_,_,_) ->
     match m1 with
     [ Avykqw (id1,mid1,_,_,kqw1,_,_,_,_) ->
           if id1<id2 
           then if ((kqw1="kwvA") || (kqw1="lyap"))
                then [ Relation (id1,mid1,encode "pUrvakAlaH",id2,mid2,"rlpUrvakAla:1")]
                else []
            else []
     | _ -> []
     ]
   | _ -> []
   ]
;

(* rAmaH puswakam paTiwum gqham gacCawi 
 rAmaH puswakam paTiwum gacCanwam bAlakam paSyawi. *)
value rlwumun m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,rt2,_,_,_,_,_) ->
     match m1 with
     [ Avykqw (id1,mid1,_,_,kqw1,_,_,_,_) ->
          if (kqw1="wumun") 
          then if ((rt2="iR2") || (rt2="icCuka"))
               then [ Relation (id1,mid1,encode "karma",id2,mid2,"rlwumun:1")]
               else if (member_of rt2 shakAxi)
                    then [ Relation (id1,mid1,encode "sahAyakakriyA",id2,mid2,"rlwumun:2")]
                    else [ Relation (id1,mid1,encode "prayojanam",id2,mid2,"rlwumun:3")]
          else []
     | _ -> []
     ]
  | _ -> []
  ]
;
(* assign_samAnakAlikawvam *)
(* rAmaH grAmam gacCan wqNam spqSawi. *)
value rlsamAnakAla m1 m2 = match m2 with
  [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_) ->
     match m1 with
     [ Kqw (id1,mid1,_,_,kqw1,_,_,_,_,_,_,_,_) ->
       if id1<id2 && ((kqw1="Sawq_lat") || (kqw1="SAnac_lat"))
       then [ Relation (id1,mid1,encode "samAnakAlaH",id2,mid2,"rlsamAnakAla")]
       else []
     |_ -> []
     ]
  | _ -> []
  ]
;
(* Noun Noun relation *)
(* assign_noun_viSeRaNa *)
(* grAmam gacCanwam rAmam SyAmaH paSyawi.
;rAmeNa pawrasya paTanam sunxaram kaWyawe. *)
value rlviSeRaNam m1 m2 = match m2 with
  [ Sup (id2,mid2,_,rt2,lifgam2,viBakwiH2,vacanam2,_)
  | Kqw (id2,mid2,_,_,_,_,_,rt2,lifgam2,viBakwiH2,vacanam2,_,_)
  | WaxXiwa (id2,mid2,_,rt2,_,_,lifgam2,viBakwiH2,vacanam2,_) -> 
   match m1 with
      [ Sup (id1,mid1,_,rt1,lifgam1,viBakwiH1,vacanam1,_)
      | WaxXiwa (id1,mid1,_,rt1,_,_,lifgam1,viBakwiH1,vacanam1,_)
      | Kqw (id1,mid1,_,_,_,_,_,rt1,lifgam1,viBakwiH1,vacanam1,_,_) ->
        if (id1<id2) && (noun_agreement_vibh rt1 vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2) && not (member_of rt1 kriyAviSeRaNas) && not (member_of rt2 kriyAviSeRaNas) && not (rt2="yaw") && not (rt2="waw") && not(rt1=rt2)
       then [ Relation (id1,mid1,encode "viSeRaNam",id2,mid2,"rlviSeRaNam1")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;

(* Avy Noun relation *)
(* assign_avy_viSeRaNa *)
value rlavy_viSeRaNam m1 m2 = match m2 with
  [ Sup (id2,mid2,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_)
  | WaxXiwa (id2,mid2,_,_,_,_,_,_,_,_) -> 
     match m1 with
     [ Avy (id1,mid1,word1,_,_) ->
       if (id1=id2-1) && (member_of word1 avy_viSeRaNam_list)
       then [ Relation (id1,mid1,encode "viSeRaNam",id2,mid2,"rlavy_viSeRaNam1")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;

value rlvIpsA m1 m2 = match m2 with
  [ Sup (id2,mid2,word2,_,_,_,_,_)
  | Kqw (id2,mid2,word2,_,_,_,_,_,_,_,_,_,_)
  | WaxXiwa (id2,mid2,word2,_,_,_,_,_,_,_)
  | Avy (id2,mid2,word2,_,_) ->
   match m1 with
      [ Sup (id1,mid1,word1,_,_,_,_,_)
      | WaxXiwa (id1,mid1,word1,_,_,_,_,_,_,_)
      | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,_,_,_)
      | Avy (id1,mid1,word1,_,_) ->
        if (id1=id2-1) && (word1=word2)
       then [ Relation (id1,mid1,encode "vIpsA",id2,mid2,"rlvIpsA1")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
value rlsamboXanasUcakam m1 m2 = match m2 with
  [ Sup (id2,mid2,_,_,_,viBakwiH2,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,viBakwiH2,_,_,_)
  | WaxXiwa (id2,mid2,_,_,_,_,_,viBakwiH2,_,_) -> 
   match m1 with
     [ Avy (id1,mid1,word1,_,_) ->
        if  (id1=id2-1) 
          && (member_of word1 samboXana_sUcaka)
          && (viBakwiH2=8)
       then [ Relation (id1,mid1,encode "samboXanasUcakam",id2,mid2,"rlsamboXasUcakam")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
value rlnirXAraNam m1 m2 = match m2 with
  [ Sup (id2,mid2,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_)
  | WaxXiwa (id2,mid2,_,_,_,_,_,_,_,_) -> 
   match m1 with
      [ Sup (id1,mid1,_,rt1,_,viBakwiH1,vacanam1,_)
      | WaxXiwa (id1,mid1,_,rt1,_,_,_,viBakwiH1,vacanam1,_)
      | Kqw (id1,mid1,_,_,_,rt1,_,_,_,viBakwiH1,vacanam1,_,_) ->
        if    (id1=id2-1) 
           && ((viBakwiH1=6) || (viBakwiH1=7)) 
           && ((vacanam1="xvi") || (vacanam1="bahu"))
           (* It is necessary to check  ((is_jAwi rt1) || (is_guNa rt1) || (is_kriyA rt1)); jAwi-guNa-kriyABiH samuxAyAw ekasya pqWak-karaNam nirXAraNam  Under A 2.2.10 in kASikA *)
       then [ Relation (id1,mid1,encode "nirXAraNam",id2,mid2,"2.3.41;rlnirXAraNam1")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
value rlupapaxa_viSeRaNa m1 m2 = match m2 with
  [ Sup (id2,mid2,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_)
  | WaxXiwa (id2,mid2,_,_,_,_,_,_,_,_) -> 
   match m1 with
      [ Sup (id1,mid1,word1,_,_,_,_,_)
      | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,_,_,_)
      | WaxXiwa (id1,mid1,word1,_,_,_,_,_,_,_)
      | Avy (id1,mid1,word1,_,_)
      | Avykqw (id1,mid1,word1,_,_,_,_,_,_)
      | AvywaxXiwa (id1,mid1,word1,_,_,_) ->
        if (id1=id2-1) && (member_of word1 upapaxa_viSeRaNas)
        then [ Relation (id1,mid1,encode "viSeRaNam",id2,mid2,"rlupapaxa_viSeRaNam")]
        else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
value rlupapaxa m1 m2 = match m2 with
   [ Sup (id2,mid2,_,rt2,_,_,_,_)
   | Kqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_)
   | Avy (id2,mid2,_,rt2,_)
   | Avykqw (id2,mid2,_,rt2,_,_,_,_,_)
   | AvywaxXiwa (id2,mid2,_,rt2,_,_)
   | WaxXiwa (id2,mid2,_,rt2,_,_,_,_,_,_) -> 
      match m1 with
      [ Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
      | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_)
      | WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) ->
         if ((id1=id2-1) || (id1=id2+1))
         then match viBakwiH1 with
         [ 2  -> if (member_of rt2 upapaxa2_list) 
                 then [Relation (id1,mid1,encode "upapaxasambanXaH",id2,mid2,"rlupapaxa1")]
                 else []
         | 3  -> if (member_of rt2 upapaxa3_list) 
                 then [Relation (id1,mid1,encode "upapaxasambanXaH",id2,mid2,"rlupapaxa2")]
                 else []
         | 4  -> if (member_of rt2 upapaxa4_list) 
                 then [Relation (id1,mid1,encode "upapaxasambanXaH",id2,mid2,"rlupapaxa3")]
                 else [ Relation (id1,mid1,encode "wAxarWyam",id2,mid2,"rlupapaxa4")]
         | 5  -> if (member_of rt2 upapaxa5_list) 
                 then [Relation (id1,mid1,encode "upapaxasambanXaH",id2,mid2,"rlupapaxa5")]
                 else []
         | 6  -> if (member_of rt2 upapaxa6_list) 
                 then [Relation (id1,mid1,encode "upapaxasambanXaH",id2,mid2,"rlupapaxa6")]
                 else [ Relation (id1,mid1,encode "RaRTIsambanXaH",id2,mid2,"rlupapaxa7")]
         | 7  -> if (member_of rt2 upapaxa7_list) 
                 then [Relation (id1,mid1,encode "upapaxasambanXaH",id2,mid2,"rlupapaxa8")]
                 else []
         | _ -> []
         ]
         else []
      | _ -> []
      ]
   | _ -> []
   ]
  ;
value rlsambanXa m1 m2 = match m2 with
  [ Avy (id2,mid2,word2,_,_) ->
   match m1 with
     [ Avy (id1,mid1,word1,_,_) ->
        if (id1=id2-1)
           && (member_of word1 samboXana_sUcaka)
           && (member_of word2 samboXana_sUcaka)
           && (not (word1=word2))
       then [ Relation (id1,mid1,encode "sambanXaH",id2,mid2,"rlsambanXa")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* ;wvaM mA gacCa. *)
value rlavy_wifverb_special m1 m2 = match m2 with
  [ Wif (id2,mid2,_,_,_,lakAraH2,_,_,_,_,_,_,_) ->
     match m1 with
     [ Avy (id1,mid1,word1,_,_) ->
       if id2=id1+1 && (word1="mA") 
          && ((lakAraH2="lot") || (lakAraH2="viXilif") || (lakAraH2="lqt"))
       then [ Relation (id1,mid1,encode "sambanXaH",id2,mid2,"rlavy_wifverb1")]
       else if id1=id2+1 && (word1="sma") 
            then [ Relation (id1,mid1,encode "sambanXaH",id2,mid2,"rlavy_wifverb2")]
            else []
     |_ -> []
     ]
  | _ -> []
  ]
  ;
(* TO CHECK *)
(* assign_karwA_kwa_karwqvAcya2 *)
(* aham kIxqSIM xaSAm prApwaH asmi *)
value rlkw1 m1 m2 = match m2 with
  [ Kqw (id2,mid2,_,_,kqw2,_,_,kqwrt2,lifgam2,viBakwiH2,vacanam2,_,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,rt1,_,_,lifgam1,_,vacanam1,_) 
     | Sup (id1,mid1,_,rt1,lifgam1,_,vacanam1,_) -> 
       if id1<id2 && (kqw2="kwa") && (vacanam2=vacanam1) && ((lifgam2 = lifgam1) || (rt1="yuRmax") || (rt1="asmax")) && (member_of kqwrt2 karwqkarmaBAvakwa_verbs)
       then 
          if(viBakwiH2 = 3) 
          then [ Relation (id1,mid1,encode "karwA",id2,mid2,"rlkw1")]
          else if(viBakwiH2 = 2) 
               then [ Relation (id1,mid1,encode "karma",id2,mid2,"rlkw1")]
               else []
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_karma_karmavAcya *)
(* pAcakena waNdulaH pacyawe *)
value rl3 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,puruRaH2,vacanam2,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ Sup (id1,mid1,word1,_,_,_,vacanam1,_)
     | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,vacanam1,_,_)
     | WaxXiwa (id1,mid1,word1,_,_,_,_,_,vacanam1,_) -> 
       if id1<id2 && (prayogaH2="karmaNi") && aBihiwa rt2 vacanam1 vacanam2 puruRaH2 && (sanAxiH2="Nic") && not (member_of word1 kriyAviSeRaNas)
       then [ Relation (id1,mid1,encode "karwA",id2,mid2,"rl3")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_karwA_of_kwAnwa_kriyA *)
(* rAmeNa pATaH paTiwaH *)
value rl4 m1 m2 = match m2 with
  [ Kqw (id2,mid2,_,_,kqw2,_,_,kqwrt2,lifgam2,viBakwiH2,vacanam2,_,_) ->
     match m1 with
     [ Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_)
     | WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) -> 
       if id1<id2 && ((kqw2="kwa") || (kqw2="yaw") || (kqw2="Nyaw")||(kqw2="Nyap")||(kqw2="wavyaw")||(kqw2="wavya")||(kqw2="aNIyar")) && (member_of kqwrt2 sakarmaka_verbs) && not (member_of kqwrt2 karwqkarmaBAvakwa_verbs) && (viBakwiH1=3)
       then [ Relation (id1,mid1,encode "karwA",id2,mid2,"rl4")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
value rl5 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,_,prayogaH2,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_)
     | WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) -> 
       if id1<id2 && ((prayogaH2="karmaNi") || (prayogaH2="BAve")) && not (sanAxiH2="Nic") && (viBakwiH1=3)
       then [ Relation (id1,mid1,encode "karwA",id2,mid2,"rl5")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_karma_karwqvAcya *)
(*
  rAmaH vexam paTawi
; vexam is the karma of paTawi
*)
value rl6 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ Sup (id1,mid1,word1,_,_,viBakwiH1,_,_)
     | WaxXiwa (id1,mid1,word1,_,_,_,_,viBakwiH1,_,_) -> 
       if id1<id2 && (prayogaH2="karwari") && not (sanAxiH2="Nic") && (viBakwiH1=2) && not (member_of word1 kriyAviSeRaNas) && not (member_of rt2 xvikarmakas1) && not (member_of rt2 xvikarmakas2) && not (member_of rt2 sakarmaka_verbs) && not (rt2="iR2")
       then [ Relation (id1,mid1,encode "karma",id2,mid2,"rl6")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_karma_for_iR2_with_wumun_kqrwqvAcya *)
(* mohanaH grAmam ganwum rAmam icCawi. *)
value rl7 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,_,_,_,_,_,_,_) ->
     match m1 with
     [ Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) -> 
       if id1<id2 && (prayogaH2="karwari") && not (rt2="iR2") && (viBakwiH1=2)
       then [ Relation (id1,mid1,encode "karma",id2,mid2,"rl7")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_kqw_karma_karwqvAcya *)
(* rAmaH paTanam karowi.  *)
value rl8 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,_,_,_,_,_,_,_) ->
     match m1 with
     [ Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (prayogaH2="karwari") && not (rt2="iR2") && (viBakwiH1=2) && not(member_of rt2 xvikarmakas1) && not(member_of rt2 xvikarmakas2) && not(member_of rt2 sakarmaka_verbs)
       then [ Relation (id1,mid1,encode "karma",id2,mid2,"rl8")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_wumunanwa_karma_to_iR2 *)
(* rAmaH maXuram Palam KAxiwum icCawi. *)
value rl10 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
       [ Avykqw (id1,mid1,_,rt1,kqw1,_,_,_,_) ->
       if id1<id2 && (kqw1="wumun") && not(rt1="iR2") && not(sanAxiH2="Nic")
       then [ Relation (id1,mid1,encode "gONakarma",id2,mid2,"rl10")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_karma_karwariNIc *)
(* aXyApakaH CAwram pATayawi
 ; CAwram is the karma of PATayawi *)
value rl11 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,_,prayogaH2,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,word1,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,word1,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,word1,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=2) && (prayogaH2="karwari") && (sanAxiH2="Nic") && not(member_of word1 kriyAviSeRaNas)
       then [ Relation (id1,mid1,encode "karma",id2,mid2,"rl11")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(*
;===========================================================================
; Following 5 functions deal with the prayojaka and prayojya karwAs.
; prayoga       prayojaka               prayojya           gatibuddhi
; karwari_Nic   1(case 1 below)    2(case 3 below)        Yes
; karwari_Nic   1(case 1 below)    3(case 4 below)        No
; karmaNi_Nic   3(case 5 below)    2(case 2 below)        either or
;===========================================================================
*)

(* assign_prayojaka_karwA_karwqvAcya  Case:1

; Assign prayojaka karwA (Case 1)
; xevaxawwaH yajFaxawwena oxanam pAcayawi.
; xevaxawwaH is karwA of pAcayawi.

; xevaxawwaH yajFaxawwam pATam pATayawi.
; xevaxawwaH is karwA of pATayawi.
*)
value rl12 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,_,prayogaH2,_,puruRaH2,vacanam2,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,rt1,_,_,_,viBakwiH1,vacanam1,_) 
     | Sup (id1,mid1,_,rt1,_,viBakwiH1,vacanam1,_)
     | Kqw (id1,mid1,_,_,_,_,_,rt1,_,viBakwiH1,vacanam1,_,_) ->
       if id1<id2 && (viBakwiH1=1) && (prayogaH2="karwari") && (sanAxiH2="Nic") && (aBihiwa rt1 vacanam1 vacanam2 puruRaH2)
       then [ Relation (id1,mid1,encode "prayojakakarwA",id2,mid2,"rl12")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_prayojya_karwA_karwqvAcya  Case:2*)
(* aXyApakena CAwram pATaH pATyawe.
; CAwraH is prayojya karwA of pATyawe

; aXyApakena CAwram waNdulaH pAcyawe.
; CAwram is prayojya karwA of pAcyawe
*)
value rl13 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,_,prayogaH2,_,puruRaH2,vacanam2,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,rt1,_,_,_,viBakwiH1,vacanam1,_) 
     | Sup (id1,mid1,_,rt1,_,viBakwiH1,vacanam1,_)
     | Kqw (id1,mid1,_,_,_,_,_,rt1,_,viBakwiH1,vacanam1,_,_) ->
       if id1<id2 && (viBakwiH1=1) && (prayogaH2="karmaNi") && (sanAxiH2="Nic") && (aBihiwa rt1 vacanam1 vacanam2 puruRaH2)
       then [ Relation (id1,mid1,encode "prayojyakarwA",id2,mid2,"rl13")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_prayojya_karwA_karwqvAcya_gawibuxXi  Case:3*)
(* aXyApakaH CAwram grAmam gamayawi.
; CAwraH is the prayojya karwA of gamayawi.
*)
value rl14 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,rt1,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,rt1,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,rt1,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=2) && (prayogaH2="karwari") && (sanAxiH2="Nic") && member_of rt2 gawibuxXi_verbs && not (member_of rt1 kriyAviSeRaNas)
       then [ Relation (id1,mid1,encode "prayojyakarwA",id2,mid2,"rl14")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_prayojya_karwA_karwqvAcya_akarmaka  Case:4*)
(* ;xampawyoH kalahaH mAm niwarAm upahAsayawi sma.*)
value rl15 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,rt1,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,rt1,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,rt1,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=2) && (prayogaH2="karwari") && (sanAxiH2="Nic") && not(member_of rt2 sakarmaka_verbs) && not(member_of rt1 kriyAviSeRaNas)
       then [ Relation (id1,mid1,encode "prayojyakarwA",id2,mid2,"rl15")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_prayojya_karwA_karwqvAcya_no_gawibuxXi  Case:d*)
(* ; xevaxawwaH yajFaxawwena oxanam pAcayawi.
; yajFaxawwena is prayojya karwA of pAcayawi.
*)
value rl16 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=3) && (prayogaH2="karwari") && (sanAxiH2="Nic") && not(member_of rt2 gawibuxXi_verbs)
       then [ Relation (id1,mid1,encode "prayojyakarwA",id2,mid2,"rl16")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_prayojya_karwA_karmavAcya  Case:5*)
(* ;yajFaxawwena puwram pATaH pATyawe
;yajFaxawwa is the prayojaka karwA of pATyawe.

;yajFaxawwena puwram waNdulaH pAcyawe
;yajFaxawwa is the prayojaka karwA of pAcyawe.
*)
value rl17 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,_,prayogaH2,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=3) && (prayogaH2="karmaNi") && (sanAxiH2="Nic")
       then [ Relation (id1,mid1,encode "prayojakakarwA",id2,mid2,"rl17")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_gONamuKyakarma_1_2karwqvAcya *)
(* rAmaH vexam paTawi *)

value rl18_19 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=2) && (prayogaH2="karwari") && not (sanAxiH2="Nic") && (member_of rt2 xvikarmakas1 || member_of rt2 xvikarmakas2)
       then [ Relation (id1,mid1,encode "gONakarma",id2,mid2,"rl18_19")
            ; Relation (id1,mid1,encode "muKyakarma",id2,mid2,"rl18_19")
            ]
       else [ ]
     | _ -> [ ]
     ]
  | _ -> [ ]
  ]
  ;
(* assign_muKyakarma_2karmavAcya *)
(* rAmeNa ajA grAmam nIyawe *)
value rl20 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,puruRaH2,vacanam2,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=1) && (prayogaH2="karmaNi") && not (sanAxiH2="Nic") && member_of rt2 xvikarmakas2
       then
         [ Relation (id1,mid1,encode "karma",id2,mid2,"rl20")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
;
(* assign_gONakarma_2karmavAcya *)
(* rAmeNa ajA grAmam nIyawe *)
value rl21 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=2) && (prayogaH2="karmaNi") && not (sanAxiH2="Nic") && (member_of rt2 xvikarmakas2)
       then
         [ Relation (id1,mid1,encode "gONakarma",id2,mid2,"rl21")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
;
(* assign_muKyakarma_1karmavAcya *)
(* rAmeNa nqpaH BikRAm yAcyawe *)
value rl22 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,puruRaH2,vacanam2,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=2) && (prayogaH2="karmaNi") && not (sanAxiH2="Nic") && member_of rt2 xvikarmakas1
       then
         [ Relation (id1,mid1,encode "karma",id2,mid2,"rl22")]
       else []
     | _ -> []
     ]
     | _ -> []
  ]
;
(* assign_gONakarma_1karmavAcya *)
(* rAmeNa nqpaH BikRAm yAcyawe *)
value rl23 m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,prayogaH2,_,_,_,_,_,_,sanAxiH2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=1) && (prayogaH2="karmaNi") && not (sanAxiH2="Nic") && member_of rt2 xvikarmakas1
       then
         [ Relation (id1,mid1,encode "gONakarma",id2,mid2,"rl23")]
       else []
     | _ -> []
     ]
     | _ -> []
  ]
;
(* assign_gONamuKyakarma_2karwqvAcya_avykqw *)
(* gudAkeSaH govinxam ukwvA baBUva. *)
value rlkqw_muKya m1 m2 = match m2 with
  [ Avykqw (id2,mid2,_,rt2,kqw2,_,_,_,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (viBakwiH1=2) && member_of rt2 xvikarmakas2 && member_of rt2 xvikarmakas1
       then [ Relation (id1,mid1,encode "gONakarma",id2,mid2,"rlkqw_muKya")
	    ; Relation (id1,mid1,encode "muKyakarma",id2,mid2,"rlkqw_muKya")
            ]
       else []
     | _ -> []
     ]
     | _ -> []
  ]
;
(* assign_karma_karwqkqxanwa *)
(* rAmaH grAmam gacCan wqNam spqSawi. *)
value rl56 m1 m2 = match m2 with
  [ Kqw (id2,mid2,_,kqwrt2,_,_,_,_,_,viBakwiH2,_,_,_) ->
     match m1 with
     [ Sup (id1,mid1,_,_,_,_,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,_,_,_,_)
     | Wif (id1,mid1,_,_,_,_,_,_,_,_,_,_,_) ->
       if (id1<id2) && (viBakwiH2=2) && (member_of kqwrt2 sakarmaka_verbs)
       then
         [ Relation (id2,mid2,encode "karma",id1,mid1,"rl56")]
       else []
    | _ -> []
     ]
    | _ -> []
  ]
;
(* assign_karwA_sakarmaka_karma_BAvakqxanwa *)
(* rAmeNa KAxiwam Palam maXuram AsIw
;haswena KAxiwam Palam maXuram AsIw *)
value rl57 m1 m2 = match m2 with
  [ Kqw (id2,mid2,_,kqwrt2,kqw2,_,_,_,_,viBakwiH2,_,_,_) ->
     match m1 with
     [ Sup (id1,mid1,_,_,_,_,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,_,_,_,_) ->
       if (id1<id2) && (viBakwiH2=3) && (((member_of kqw2 karmakqw_verbs) && (member_of kqwrt2 sakarmaka_verbs)) || (member_of kqw2 bhAva_kqw_verbs))
       then [ Relation (id1,mid1,encode "karwA",id2,mid2,"rl57")
            ; Relation (id1,mid1,encode "karaNam",id2,mid2,"rl57")
            ]
       else []
    | _ -> []
     ]
    | _ -> []
  ]
;
(* assign_kAraka_RaRTI *)
(* rAmeNa prajAyAH SAsanam kriyawe *)
value rl39 m1 m2 = match m2 with
  [ Kqw (id2,mid2,_,kqwrt2,kqw2,_,_,_,lifgam2,viBakwiH2,vacanam2,_,_) ->
     match m1 with
     [ Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_)
     | WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) -> 
       if id2=id1+1 && (viBakwiH1=6) && member_of kqwrt2 shashthii_kqw_verbs
       then  [ Relation (id1,mid1,encode "karwA",id2,mid2,"rl39")
             ; Relation (id1,mid1,encode "karma",id2,mid2,"rl39")
	     ]
       else []
     |_ -> []
     ]
   |_ -> []
 ]
;
(* assign_rel_for_iwi *)
(*
;Added by sheetal 
;modified by Pavan; changed the name of the sambanXa to anuyogI.
;SrUyawAm iwi Amanwrya rAmaH avocaw.
;This change is not good.
;Earlier solution was better.
; Counter example:
;praBAwe aham rAjasaBAm gawvA kA vArwA iwi paSyAmi.
; Here iwi is marked as an anuyogi, so praBAwe is marked as a karma, This is wrong.
;iwi itself denotes a vaakya karma.
;rl63
; In view of the change in the previous rule, from this rule sambanXa is removed by Amba; 29 feb 2012
*)
value rl63a m1 m2 = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,rt2,_,_,_,_,_) ->
     match m1 with
     [ Avy (id1,mid1,word1,_,_) ->
       if (id1<id2) && (word1="iwi") && (member_of rt2 sakarmaka_verbs)
       then [ Relation (id1,mid1,encode "karma",id2,mid2,"rl63a")]
       else []
    | _ -> []
     ]
  | _ -> []
  ]
  ;
(* assign_karma_avykqxanwa *)
(*rAmaH puswakam paTiwum gqham gacCawi
;rAmaH xugXam pIwvA vanam gacCawi
*)
value rl50 m1 m2 = match m2 with
  [ Avykqw (id2,mid2,_,rt2,kqw2,_,_,_,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (kqw2="wumun") && (viBakwiH1=2) && (member_of rt2 sakarmaka_verbs)
       then
         [ Relation (id1,mid1,encode "karma",id2,mid2,"rl50")]
       else []
     | _ -> []
     ] 
  | _ -> []
  ]
;
(* assign_karma_of_wumun_no_iR2 *)
(* *)
value rl51 m1 m2 = match m2 with
  [ Avykqw (id2,mid2,_,rt2,kqw2,_,_,_,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (kqw2="wumun") && (viBakwiH1=2) && (member_of rt2 sakarmaka_verbs)
       then
         [ Relation (id1,mid1,encode "karma",id2,mid2,"rl51")]
       else []
    | _ -> []
     ]
    | _ -> []
  ]
;
(* assign_rel_for_iwi_kqw *)
(* Canxra iva muKam paSya. Here Canxra and muKam do not have the same viBakwi
;paramAwmA iva pUrNaH Baviwum icCawi. ???
;rAmasya iva kqRNasya gAvaH sanwi.
*)
value rl63 m1 m2 = match m2 with
  [ Avy (id2,mid2,word2,_,_) ->
     match m1 with
     [ Kqw (id1,mid1,_,kqwrt1,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if (id1<id2) && (word2="iwi") && member_of kqwrt1 sakarmaka_verbs
       then
         [ Relation (id1,mid1,encode "karma",id2,mid2,"rl63")]
       else []
     | _ -> []
     ]
    | _ -> []
  ]
;
(* assign_karwq_samAnAXikaraNa_BUwvA *)
(* ;saH prasannaH BUwvA mAwaram avaxaw. *)
value rl50a m1 m2 = match m2 with
  [ Avykqw (id2,mid2,word2,_,kqw2,_,_,_,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) 
     | Sup (id1,mid1,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_,_) ->
       if id1<id2 && (kqw2="wumun") && (viBakwiH1=1) && (word2="BUwvA")
       then
         [ Relation (id1,mid1,encode "karwqsamAnAXikaraNam",id2,mid2,"rl50a")]
       else []
    | _ -> []
     ]
    | _ -> []
  ]
;
(* assign_assign_auxiliary *)
(* rAmaH puswakam paTiwum Saknowi *)
value rl55b m1 m2 = match m2 with
  [ Avykqw (id2,mid2,_,_,kqw2,_,_,_,_) ->
     match m1 with
     [ Wif (id1,mid1,_,rt1,_,_,_,_,_,_,_,_,_) ->
       if id2=id1-1 && (kqw2="wumun") (* Necessary to chk whether rt1 belongs to Saka, xqS, etc. *)
       then
         [ Relation (id2,mid2,encode "sahakriyA",id1,mid1,"rl55b")]
       else []
    | _ -> []
     ]
    | _ -> []
  ]
;
(* assign_avy_verb *)
(* ;mohanaH na AgacCawi. *)
value rl58 m1 m2 = match m2 with
  [ Avy (id2,mid2,_,rt2,_) ->
     match m1 with
     [ Wif (id1,mid1,_,_,_,_,_,_,_,_,_,_,_)
     | Avykqw (id1,mid1,_,_,_,_,_,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,_,_,_,_) ->
       if (id1<id2) && (member_of rt2 avy_verb_list)
       then
         [ Relation (id1,mid1,encode "sambanXaH",id2,mid2,"rl58")]
       else []
    | _ -> []
     ]
    | _ -> []
  ]
;
(* assign_avy_noun *)
(* rAmaH eva vanam gacCawi. *)
value rl59 m1 m2 = match m2 with
  [ Avy (id2,mid2,_,rt2,_) ->
     match m1 with
     [ Kqw (id1,mid1,_,_,_,_,_,_,_,_,_,_,_)
     | Sup (id1,mid1,_,_,_,_,_,_)
     | WaxXiwa (id1,mid1,_,_,_,_,_,_,_,_) -> 
       if (id1=id2+1) && not (rt2="iva") && not (rt2="ca") && not (rt2="iwi")
       then
         [ Relation (id1,mid1,encode "sambanXaH",id2,mid2,"rl59")]
       else []
    | _ -> []
     ]
    | _ -> []
  ]
;
(* assign_iwi *)
(* iwi after any noun or verb is related to the previous word by sambanXa relation
;Note the direction also. Now iwi is the head, and not the verb. *)

value rl62 m1 m2 = match m1 with
  [ Avy (id1,mid1,word1,_,_) ->
     match m2 with
     [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_)
     | Avykqw (id2,mid2,_,_,_,_,_,_,_)
     | Sup(id2,mid2,_,_,_,_,_,_)
     | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_) ->
       if (id1=id2+1) && (word1="iwi")
       then [ Relation (id1,mid1,encode "sambanXaH",id2,mid2,"rl62")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;



value all_rules = 
[
rlanaBihiwe; rlapAxAna_wasil; rlkriyAviSeRaNam_or_aXikaraNam; rlpUrvakAla; rlsamAnakAla; rlviSeRaNam; rlavy_viSeRaNam; rlvIpsA; rlsamboXanasUcakam; rlnirXAraNam; rlupapaxa_viSeRaNa; rlupapaxa; rlsambanXa; rlwifaBihiwa; rlkqwaBihiwa; rl3; rl4; rl5; rl6; rl7; rl8; rl10; rl11; rl12; rl13; rl14; rl15; rl16; rl17; rl18_19; rl20; rl21; rl22; rl23; rlkqw_muKya; rl56; rl57; rl39; rl63a; rl50; rl51; rl63; rl50a; rl55b; rl58; rl59;  rl62; 
  ]
;

value clips_engine morphs =
  loop1 [] morphs 
  where rec loop1 acc1 = fun
       [ [] -> acc1
       | [ m1 :: r1 ] -> 
         let relations_m1 = loop2 [] morphs
           where rec loop2 acc2 = fun
           [ [] -> acc2
           | [ m2 :: r2 ] -> 
             let relations_m1_m2 = 
		List.fold_left collate acc2 all_rules where
   	        collate rels rule = match rule m1 m2 with
                                    [ [] -> rels
                                    | r -> [ r :: rels ]
                                    ] in 
	     loop2 (List2.union relations_m1_m2 acc2) r2
           ] in
         loop1 (List2.union relations_m1 acc1) r1
       ] 
;


value process morphs = do
  { (* List.iter print_morph_id morphs *) (* we print the input for verification *)
   
   List.iter print_relation_list (clips_engine morphs)
  }
;
let morphs = analyse (Stream.of_channel stdin) in
process morphs
;
