#!PERLPATH -I LIB_PERL_PATH/

#  Copyright (C) 2009-2016 Amba Kulkarni (ambapradeep@gmail.com)
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later
#  version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


$Data_Path=$ARGV[0];
if($ARGV[2] eq "D") { $DEBUG = 1; } else {$DEBUG = 0;}

use GDBM_File;
tie(%NOUN,GDBM_File,"$Data_Path/hi/noun.dbm",GDBM_READER,0644) || die "Can't open $Data_Path/hi/noun.dbm for reading";
tie(%PRONOUN,GDBM_File,"$Data_Path/hi/pronoun.dbm",GDBM_READER,0644) || die "Can't open pronoun.dbm for reading";
tie(%TAM,GDBM_File,"$Data_Path/hi/tam.dbm",GDBM_READER,0644) || die "Can't open tam.dbm for reading";
tie(%VERB,GDBM_File,"$Data_Path/hi/verb.dbm",GDBM_READER,0644) || die "Can't open verb.tam for reading";
tie(%AVY,GDBM_File,"$Data_Path/hi/avy.dbm",GDBM_READER,0644) || die "Can't open avy.dbm for reading";
tie(%PRATIPADIKAM,GDBM_File,"$Data_Path/hi/noun_pronoun_pratipadika.dbm",GDBM_READER,0644) || die "Can't open noun_pronoun_pratipadika.dbm for reading";

tie(%FEM,GDBM_File,"$Data_Path/hi/fem_hnd_noun.dbm",GDBM_READER,0644) || die "Can't open avy.dbm for reading";


$rNOUN = \%NOUN;
$rPRONOUN = \%PRONOUN;
$rTAM = \%TAM;
$rVERB = \%VERB;
$rAVY = \%AVY;
$rPRATIPADIKAM = \%PRATIPADIKAM;

# To store the missing entries fom the dictionary
#open(TMP_N,">dict_noun_add.txt") || die "Can't open dict_noun_add.txt";
#open(TMP_V,">dict_verb_add.txt") || die "Can't open dict_verb_add.txt";
#open(TMP_A,">dict_avy_add.txt") || die "Can't open dict_avy_add.txt";
#open(TMP_P,">dict_pron_add.txt") || die "Can't open dict_pron_add.txt";
#open(TMP_T,">dict_tam_add.txt") || die "Can't open dict_tam_add.txt";

   $default_lifga = "m";
   $default_vacana = "s";
   $default_puruRa = "a";
   $default_tam = "0";

while($tmpin = <STDIN>){
  #print "in = $in\n";
  chomp($tmpin);
  if ($tmpin =~ /./) {
  @f = split(/\t/,$tmpin);
  $in = $f[13];
  $ans = "";

  if($in =~ /\-/) {
     $in =~ /<rt:([^\-]+)-([^>]+)>/;
     $pUrvapaxa = $1;
     $uwwarapaxa = $2;
     #print "pUrvapaxa = $pUrvapaxa\n";
     #print "uwwarapaxa = $uwwarapaxa\n";
     $pUrvapaxa =~ s/<[^>]+>//g;
     $pUrvapaxa =~ s/><//g;
     $pUrvapaxa =~ s/>//g;
     #print "pUrvapaxa = $pUrvapaxa\n";
     $pUrvapaxa =~ s/\/[^\-]+\-//g;
     $pUrvapaxa =~ s/\/[^\-]+$//g;
     #print "pUrvapaxa = $pUrvapaxa\n";
     #$in = $pUrvapaxa."-".$uwwarapaxa;
  }
  #print "in = $in\n";
  $in =~ s/\/.*//;
  $in =~ s/></;/g;
  $in =~ s/</{/g;
  $in =~ s/>/}/g;
  $in =~ s/({vargaH:sa\-pU\-pa;[^}]+}(\/[^{]+)?)+\-/-/g;
  #print "in = $in\n";

  if($in =~ /rt:(.+)\-([^;]+)/) { 
     $samAsa_pUrvapaxa = &get_dict_mng($1,"TMP_N",$rPRATIPADIKAM); 
     $in =~ s/rt:[^;]+/rt:$uwwarapaxa/;
  } else { $samAsa_pUrvapaxa = "";}

  #print "in = $in\n";
  @in = split(/\//,$in);
  if($in ne ""){
    if($ARGV[1] eq "ONE") { $LAST = 0; } else {$LAST = $#in;}
    for($i=0;$i<=$LAST;$i++){
  #    print "in = $in\n";
      $cat = &get_cat($in[$i]);
      if($cat eq "P") {

        ($rt,$lifga,$viBakwi,$vacana) = split(/:/, &get_noun_features($in[$i]));

       $key = $rt."_".$lifga;
       $map_rt = &get_dict_mng($key,"TMP_P", $rPRONOUN);
       if($map_rt =~ /(.*):(.*)/) { $map_rt = $1; $hn_lifga = &get_skt_hn_lifga($2);}
       $map_viBakwi = &get_dict_mng($viBakwi, "TMP_T", $rTAM);

       if($samAsa_pUrvapaxa) { $map_rt = $samAsa_pUrvapaxa."-".$map_rt;}
      
    #   if($map_rt =~ /(.*):(.*)/) { $map_rt = $1; 
    #      $hn_lifga = &get_skt_hn_lifga($2);
    #   }
       $hn_lifga = &get_hn_P_lifga($map_rt,$lifga);
       $hn_vacana = &get_hn_vacana($vacana);
       $hn_puruRa = &get_hn_purURa_sarvanAma($rt);
       $ans .= "/$map_rt $cat $hn_lifga $hn_vacana $hn_puruRa $map_viBakwi";

      } elsif($cat eq "kqw-noun") {

       ($rt, $kqw, $XAwu, $gaNa, $kqw_pratipadika, $lifgam, $viBakwi, $vacana) = 
         split(/:/, &get_kqw_noun_features($in[$i]));

       $key = $kqw_pratipadika."_".$lifgam;

       $map_rt = &get_dict_mng($key,"TMP_N", $rNOUN);
       if($NOUN{$key} ne "") {
          $cat = "n";
          if($samAsa_pUrvapaxa) { $map_rt = $samAsa_pUrvapaxa."-".$map_rt;}

          $map_viBakwi = &get_dict_mng($viBakwi, "TMP_T", $rTAM);

          if($map_rt =~ /(.*):(.*)/) { $map_rt = $1; $hn_lifga = &get_skt_hn_lifga($2);}
         # $hn_lifga = &get_hn_lifga($map_rt,$lifgam);
          $hn_vacana = &get_hn_vacana($vacana);

          $ans .= "/$map_rt $cat $hn_lifga $hn_vacana $default_puruRa $map_viBakwi";
       } else {
         $cat = "v";

         $map_rt = &get_dict_mng($rt, "TMP_V", $rVERB);
         $map_kqw = &get_dict_mng($kqw, "TMP_T", $rTAM);

         $hn_lifga = &get_skt_hn_lifga($lifgam);
         $hn_vacana = &get_hn_vacana($vacana);
         $ans .=  "/$map_rt $cat $hn_lifga $hn_vacana $default_puruRa $map_kqw";
      }
      }elsif($cat eq "n") {

        ($rt,$lifga,$viBakwi,$vacana) = split(/:/, &get_noun_features($in[$i]));

       $key = $rt."_".$lifga;
       $map_rt = &get_dict_mng($key, "TMP_N", $rNOUN);

       if($samAsa_pUrvapaxa) { $map_rt = $samAsa_pUrvapaxa."-".$map_rt;}

       $map_viBakwi = &get_dict_mng($viBakwi, "TMP_T", $rTAM);
      
       if($map_rt =~ /(.*):(.*)/) { $map_rt = $1; $hn_lifga = &get_skt_hn_lifga($2);}
       #$hn_lifga = &get_hn_lifga($map_rt,$lifga);
       $hn_vacana = &get_hn_vacana($vacana);
       $ans .= "/$map_rt $cat $hn_lifga $hn_vacana $default_puruRa $map_viBakwi";

      } elsif($cat eq "kqw-avy") {
        ($rt,$kqw,$XAwu,$gaNa) = (split/:/, &get_kqw_avy_features($in[$i]));

       $map_rt = &get_dict_mng($rt,"TMP_V", $rVERB);
       $map_kqw = &get_dict_mng($kqw, "TMP_T", $rTAM);

       $cat = "v";
       $ans .= "/$map_rt $cat $default_lifga $default_vacana $default_puruRa $map_kqw";

      } elsif($cat eq "waxXiwa_avy") {

       ($rt, $waxXiwa, $lifga) =  split(/:/, &get_waxXiwa_avy_features($in[$i]));
       #print "rt = $rt waxXiwa = $waxXiwa lifga = $lifga\n";

       if($lifga eq "avy") {
          $map_rt = &get_dict_mng($rt, "TMP_A", $rAVY);
       } else {
          $key = $rt."_".$lifga;
          $map_rt = &get_dict_mng($key, "TMP_N", $rNOUN);
       }

       if($samAsa_pUrvapaxa) { $map_rt = $samAsa_pUrvapaxa."-".$map_rt;}

       $map_waxXiwa = &get_dict_mng($waxXiwa, "TMP_T", $rTAM);
      
       if($map_rt =~ /(.*):(.*)/) { $map_rt = $1; $hn_lifga = &get_skt_hn_lifga($2);}
       else { $hn_lifga = "m";}
       #$hn_lifga = &get_hn_lifga($map_rt,$lifga);
       $hn_cat = "n"; # The category of the rt word is n, while the resultant is an avy
       $ans .= "/$map_rt $hn_cat $hn_lifga $default_vacana $default_puruRa $map_waxXiwa";
       #$ans .= "/$map_rt $hn_cat NW NW NW $map_waxXiwa";
# Commented the previous line, since in case of vixyAlaya n NW NW NW se, machine produced vixyAlayaeyegA_se. Here 'se' corresponds to waxXiwa_prawyayaH:wasil

      } elsif($cat eq "avy"){
          #print "in = ", $in[$i],"\n";

          $rt = &get_avy_feature($in[$i]);

          $map_rt = &get_dict_mng($rt, "TMP_A", $rAVY);
          #$ans .= "/$map_rt avy $default_lifga $default_vacana $default_puruRa $default_tam";
          if($samAsa_pUrvapaxa) { $map_rt = $samAsa_pUrvapaxa."-".$map_rt;}
          $ans .= "/$map_rt avy NW NW NW NW";

      } elsif($cat eq "v") {

       ($rt,$prayoga,$lakAra,$purURa,$vacana,$XAwu,$gaNa) = 
          split(/:/, &get_verb_features($in[$i]));
       
       $map_rt = &get_dict_mng($rt, "TMP_V", $rVERB);

       $pra_lakAra = $prayoga."_".$lakAra;
       $map_lakAra = &get_dict_mng($pra_lakAra, "TMP_T", $rTAM);

       $hn_purURa = &get_hn_purURa($purURa);
       $hn_vacana = &get_hn_vacana($vacana);

       $ans .= "/$map_rt $cat $default_lifga $hn_vacana $hn_purURa $map_lakAra";

   } else { 
       # This is to handle the words unrecognised by morph
       $cat = "n";
       $map_rt = $in[$i];
       $map_rt =~ s/{word:.*;rel_nm:;relata_pos:}//;
       if($samAsa_pUrvapaxa) { $map_rt = $samAsa_pUrvapaxa."-".$map_rt;}
       $ans .=  "/$map_rt $cat $default_lifga $default_vacana $default_puruRa $default_tam";}
  } # Do for each analysis
     $ans =~ s/^\///; 
     $ans =~ s/\/$//; 
     print $tmpin,"\t",$ans;
     $ans = "";
  } # If input is non-empty
 } # If entry is non empty
  print "\n";
} # End while

close(TMP_N);
close(TMP_V);
close(TMP_P);
close(TMP_A);
close(TMP_T);

untie(%FEM);
untie(%NOUN);
untie(%PRONOUN);
untie(%TAM);
untie(%AVY);
untie(%VERB);


sub get_hn_lifga{
 my($wrd,$lifga) = @_;

 if($FEM{$wrd}) { $lifga = "f";}
 elsif($lifga eq "napuM") { $lifga = "m";}
 elsif($lifga eq "puM") { $lifga = "m";}
 elsif($lifga eq "swrI") { $lifga = "f";}
 elsif($lifga eq "a") { $lifga = "m";}
 else { $lifga = "m";} # Default value, in case of any error

$lifga;
}
1;

sub get_skt_hn_lifga{
 my($lifga) = @_;

 if($lifga eq "napuM") { $lifga = "m";}
 elsif($lifga eq "puM") { $lifga = "m";}
 elsif($lifga eq "swrI") { $lifga = "f";}
 elsif($lifga eq "a") { $lifga = "m";}
 else { $lifga = "m";} # Default value, in case of any error

$lifga;
}
1;

sub get_hn_P_lifga{
 my($wrd,$lifga) = @_;

 if($lifga eq "napuM") { $lifga = "m";}
 elsif($lifga eq "puM") { $lifga = "m";}
 elsif($lifga eq "swrI") { $lifga = "f";}
 elsif($lifga eq "a") { $lifga = "m";}

$lifga;
}
1;

sub get_hn_purURa{
 my($purURa) = @_;

 if($purURa eq "u") { $purURa = "u";}
 elsif($purURa eq "ma") { $purURa = "m";}
 elsif($purURa eq "pra") { $purURa = "a";}

$purURa;
}
1;

sub get_hn_purURa_sarvanAma{
 my($rt) = @_;

 my($purURa) = "";

 if($rt eq "asmax") { $purURa = "u";}
 elsif($rt eq "yuRmax") { $purURa = "m";}
 else { $purURa = "a";}

$purURa;
}
1;

sub get_hn_vacana{
 my($vacana) = @_;

 if($vacana eq "1") { $vacana = "s";}
 elsif($vacana eq "2") { $vacana = "p";}
 elsif($vacana eq "3") { $vacana = "p";}

$vacana;
}
1;


sub get_hn_cat{
 my($cat) = @_;

 if($cat eq "nA") { $cat = "n";}
 if($cat eq "saMKyeyam") { $cat = "n";}
 if($cat eq "pUraNam") { $cat = "n";}

$cat;
}
1;

sub clean{
my($in) = @_;
#This cleans the dictionary entry removing all the meanings joined by '^' and the extra comments in {}.
      if($in =~ /:/) {
         $in =~ s/\^.*:/:/;
      } else {
         $in =~ s/\^.*//;
      }
      $in =~ s/\{.*\}//;
$in;
}
1;


sub get_cat{

my($in) = @_;

   if($in =~ /vargaH:sarva/){ $cat = "P";}

   elsif($in =~ /vargaH:avy;kqw_prawyayaH:/){ $cat = "kqw-avy";}
   elsif($in =~ /kqw_prawyayaH/){ $cat = "kqw-noun";}

   elsif($in =~ /vargaH:avy;waxXiwa_prawyayaH:([^;]+;lifga)/){ $cat = "n";}
   elsif($in =~ /vargaH:avy;waxXiwa_prawyayaH:([^;]+)/){ $cat = "waxXiwa_avy";}

   elsif($in =~ /vargaH:avy/){ $cat = "avy"; } 

   elsif($in =~ /lakAraH:([^;]+)/){ $cat = "v"; }

   elsif($in =~ /vargaH:(nA|saMKyeyam|pUraNam)/){ $cat = "n";}
}
1;

sub get_noun_features{
my($in) = @_;
my($ans);
  if($in =~ /^.*rt:([^;]+).*lifgam:([^;]+).*viBakwiH:([^;]+).*vacanam:([^;]+)/){

     $ans = join(":",$1,$2,$3,$4);

  }
$ans;
}
1;

sub get_kqw_avy_features{
my($in) = @_;

my($ans);

if($in =~ /^.*rt:([^;]+).*vargaH:avy;kqw_prawyayaH:([^;]+);XAwuH:([^;]+);gaNaH:([^;]+)/){

 $ans = join(":",$1,$2,$3,$4);
}
$ans;
}
1;

sub get_verb_features{
my($in) = @_;
my($ans);

    if($in =~ /^.*rt:([^;]+).*prayogaH:([^;]+);lakAraH:([^;]+);puruRaH:([^;]+);vacanam:([^;]+);.*XAwuH:([^;]+);gaNaH:([^;]+)/){

     $ans = join(":",$1,$2,$3,$4,$5,$6,$7);
    }
$ans;
}
1;

sub get_kqw_noun_features{
my($in) = @_;

my($ans);

  if($in =~ /^.*rt:([^;]+).*kqw_prawyayaH:([^;]+);XAwuH:([^;]+);gaNaH:([^;]+).*kqw_pratipadika:([^;]+).*lifgam:([^;]+).*viBakwiH:([^;]+).*vacanam:([^;}]+)/){

  $ans = join(":",$1,$2,$3,$4,$5,$6,$7,$8);
  }
$ans;
}
1;

sub get_waxXiwa_avy_features{
my($in) = @_;

my($ans);

  if($in =~ /^.*rt:([^;]+).*vargaH:avy;waxXiwa_prawyayaH:([^;]+);lifgam:([^;]+)/){
     $ans = join(":",$1,$2,$3);
  }
  elsif($in =~ /^.*rt:([^;]+).*vargaH:avy;waxXiwa_prawyayaH:([^;]+)/){
     $ans = join(":",$1,$2,"avy");
  }
$ans;
}
1;

sub get_avy_feature{
my($in) = @_;
my($rt);

  if($in =~ /^.*rt:([^;]+).*vargaH:avy/){
     $rt = $1;
     #print "rt = $rt\n";
  }
$rt;
}
1;

sub get_dict_mng{
my($rt,$missing_fl_nm,$rdatabase) = @_;
my($ans) = "";
       
       if($$rdatabase{$rt} ne "") {
          $ans = &clean($$rdatabase{$rt});
       } else { 
          print $missing_fl_nm $rt,"\n"; 
    #      if($rt !~ /[1-9]/) { # If not a verb
    #         $rt =~ s/_.*//; # To remove the lifga info
    #      }
          if($rt =~ /1_/) { $rt =~ s/1_/_/;} 
#This has been added to take care of Names that are not to be translated.
          $ans = $rt;
	  $ans =~ s/_/:/;
       }
$ans;
}
1;
