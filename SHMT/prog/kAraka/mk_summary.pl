#!PERLPATH -I LIB_PERL_PATH/

#  Copyright (C) 2012-2016 Amba Kulkarni (ambapradeep@gmail.com)
#
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

$myPATH="SCLINSTALLDIR";
require "$myPATH/SHMT/prog/kAraka/compatible.pl";
use GDBM_File;

# ARGV[0]: Script : DEV / ROMAN 
# Devanagari / Roman transliteration / Velthuis

#ARGV[1]: input file:  Output of the parser
# Relevant fields:
# First field: paragraph/line/word_no
# Second field: word

#ARGV[2]: file name containing names of the kaaraka tags
#$ARGV[3]: name of the directory with temporary files
#$ARGV[4]: selected relations
#$ARGV[5]: sentence number
#$ARGV[6]: parseop file name

my $SCRIPT=$ARGV[0];
my $filename=$ARGV[1];
my $kAraka_name=$ARGV[2];

if($SCRIPT eq "DEV") {
   require "$myPATH/SHMT/prog/interface/modify_mo_fn_dev.pl";
   $kAraka_name .= "/kAraka_name_dev.gdbm";
}
if($SCRIPT eq "ROMAN") {
   require "$myPATH/SHMT/prog/interface/modify_mo_fn_roman.pl";
   $kAraka_name .= "/kAraka_name_roman.gdbm";
}

tie(%kAraka_name,GDBM_File,$kAraka_name,GDBM_READER,0644) || die "Can't open $kAraka_name for reading";

my $dirname=$ARGV[3];
my $relations=$ARGV[4];
my $sentnum=$ARGV[5];
my $OUTFILE=$ARGV[6];
my $save=$ARGV[7];
my $translate=$ARGV[8];

$old_relations = $relations;
$old_relations =~ s/:[^:]+$//; #old relations is the current relation minus the last addition.

if($relations eq "") { $relations = "''";}
if($old_relations eq "") { $old_relations = "''";}
#Get the words and their morph analysis from $ARGV[1]
#Also assign the div-class for each of the analysis, needed for HTML display.

open(IN, "<$filename") || die "Can't open $filename for reading";
while($in = <IN>){
      @in = split(/\n/,$in);
      foreach $in (@in) {
          @flds = split(/\t/,$in);
          if(($flds[0] =~ /^[0-9]+।([0-9]+)/) || ( $flds[0] =~ /^[0-9]+.([0-9]+)/)){
           $w_no = $1-1; 
           $indx = $w_no;
           $wrd{$indx} = $flds[2];
           $tmp = $flds[7];
           if($tmp =~ /\-/) {
              $tmp =~ s/स\-पू\-प/स_पू_प/g;
              $tmp =~ s/स\-पू\-प/स_पू_प/g;
              $tmp =~ s/sa\-puu\-pa/sa_puu_pa/g;
              $tmp =~ s/sa\-puu\-pa/sa_puu_pa/g;
              @tmp = split(/-/,$tmp);
              $tmp = "";
              for ($i=0;$i< $#tmp; $i++) {
               $tmp[$i] =~ s/<.*//;
               $tmp .= "-" . $tmp[$i];
              }
              $tmp .= "-" . $tmp[$#tmp];
              $tmp =~ s/^\-//;
           }
           if( $tmp =~ /^(.*)\-/) { $samAsa_pUrvapaxa = $1; $tmp =~ s/^(.*)\-//;} else { $samAsa_pUrvapaxa = "";}
           @ana = split(/\//,$tmp);
           for ($i=0;$i <= $#ana; $i++) {
               $mindx = $indx.",".$i;
               if($samAsa_pUrvapaxa) { $ana[$i] = $samAsa_pUrvapaxa."-".$ana[$i];}
               $mana = &modify_mo($ana[$i]);
               $mana =~ s/<level:[0-4]>//;
               $mana =~ s/<लेवेल्:[0-4]>//;
               $word{$mindx} = $mana;
               if($ana[$i] =~ /^([^<]+).*<(विभक्तिः|vibhaktiḥ|vibhakti\.h):([1-8])>/){
                $class{$mindx} = "N".$3;
             }
             elsif($ana[$i] =~ /^([^<]+).*<(कृत्_प्रत्ययः|kṛt_pratyayaḥ|k\.rt_pratyaya\.h)/){
                $class{$mindx} = "NA";
             }
             elsif($ana[$i] =~ /^([^<]+).*<(varga\.h:avy|vargaḥ:avy|वर्गः:अव्य्)/){
                $class{$mindx} = "NA";
             }
             elsif($ana[$i] =~ /^([^<]+).*<(लकारः|lakāraḥ|lakaara\.h):/){
                $class{$mindx} = "KP";
             }
           }
           if($tot_words < $w_no) { $tot_words = $w_no;}
          }
      }
}
close(IN);

#Read from the parseop.txt, various solutions, one after the other.
$ans = "";
%RELS=();
$parse = "";
$tmp = "";
$cmptbl = 1;
while($in = <STDIN>){
  chomp($in);
  if($in =~ /./) {
         if($in =~ /\(/){
           $in =~ /([0-9]+),([0-9]+),([0-9]+),([0-9]+),([0-9]+)/;
           $to_wrd = $1;
           $to_mid = $2;
           $rel_nm = $3;
           $from_wrd = $4;
           $from_mid = $5;
           $in_node = $to_wrd.",".$to_mid.",".$rel_nm.",".$from_wrd.",".$from_mid;
           $mindx = "$to_wrd,$to_mid";
           $exists{$mindx} = 1;
           $mindx = "$from_wrd,$from_mid";
           $exists{$mindx} = 1;
# Check whether the entry of this solution is compatible with the relations chosen.
           if(&compatible($in_node,$relations)) {
             $to = $to_wrd.",".$to_mid;
             $from = $from_wrd.",".$from_mid;
             $rel = $rel_nm.",".$from;
             $relto = $rel_nm.",".$to;

             if(($RELS{$to} !~ /^$rel#/) && ($RELS{$to} !~ /#$rel#/)) {
               $RELS{$to} .= $rel."#";
               $mindx = "$to";
               $frommindx = "$from";
               $COL{$to_wrd} .= $to."#".$rel.":$class{$mindx};";
           }
         } else { $cmptbl = 0;}
       $tmp .= $in."\n";
      } elsif($in =~ /Total (Complete|Partial) Solutions=([0-9]+)/) {
              $total_solns=$2;
              $parse .= $in."\n";
      } elsif($in =~ /Cost/) { 
           if ($cmptbl) {
               $soln++; $parse .= $tmp.$in."\n"; $tmp = "";
           } else { $cmptbl=1; $tmp = "";}
      } elsif($in =~ /Solution:/) { $tmp.=$in."\n";
      } else { $parse .= $in."\n";}
  } else {$parse .= $in."\n";}
 }
 open(TMP,">$OUTFILE") || die "Can't open $OUTFILE for writing";
 print TMP $parse;
 close(TMP);

  if($save eq "no") {
  if($soln == 0) { print "No Solution Found\n";}
  else {
      if(($total_solns == 1) || ($soln == 1)){
         print "<h3> <a href=\"CGIURL/SHMT/prog/interface/call_parser_summary.cgi?filename=$dirname&amp;outscript=$SCRIPT&amp;rel=$old_relations&amp;sentnum=$sentnum&amp;save=no&amp;translate=no\"> &#x2713;<\/a> Undo\n";
         print "<a href=\"CGIURL/SHMT/prog/interface/show_selected_parse.cgi?filename=$dirname/&amp;sentnum=$sentnum&amp;start=0\"> &#x2713; <\/a>Unique parse tree \n";
        print " <a href=\"CGIURL/SHMT/prog/interface/call_parser_summary.cgi?filename=$dirname&amp;outscript=$SCRIPT&amp;rel=$old_relations&amp;sentnum=$sentnum&amp;save=yes&amp;translate=no\"> &#x2713;<\/a> Save\n";
        print " <a href=\"CGIURL/SHMT/prog/interface/call_parser_summary.cgi?filename=$dirname&amp;outscript=$SCRIPT&amp;rel=$old_relations&amp;sentnum=$sentnum&amp;save=no&amp;translate=yes\"> &#x2713;<\/a>Translate into hindi</h3>\n";
      } else {
        print "<h3> <a href=\"CGIURL/SHMT/prog/interface/call_parser_summary.cgi?filename=$dirname&amp;outscript=$SCRIPT&amp;rel=$old_relations&amp;sentnum=$sentnum&amp;save=no&amp;translate=no\"> &#x2713;<\/a> Undo\n";
        if($soln < 10) {
           print "<a href=\"CGIURL/SHMT/prog/interface/show_selected_parse.cgi?filename=$dirname/&amp;rel=$relations&amp;sentnum=$sentnum\"> &#x2713;<\/a> $soln filtered trees\n";
        } else {
           print "$soln filtered trees\n";
        }
        print "<\/h3>\n";
      } 

 print "<div style=\"position:relative; margin:auto; width:1500px;\">\n";
 print "<table>\n";
 print "<tr>\n";
  for($i=0; $i <= $tot_words; $i++){
    $indx = "$i";
    $pos = $i+1;
    print "<td align=\"center\" style=\"background-color:grey; color:yellow\">$wrd{$indx}($pos)<\/td>\n";
 }
 print "<\/tr>\n";
 print "<tr>\n";
 for($i=0; $i <= $tot_words; $i++){
 print "<td><ul>\n";
         $j=0;
         $mindx = "$i,$j";
         while($j < 10) { # assuming that there are < 10 morph solns
         if($word{$mindx}) { # assuming that there are < 10 morph solns
           $class = $class{$mindx};
#Display the morph analysis, only if it is compatible with the chosen relations.
           if( &compatible_mo($mindx,$relations,%COL)){
             $new_rel = "-,-,-,".$i.",".$j;
             if($relations !~ /:$new_rel/) { $rels = $relations.":".$new_rel;}
             else {$rels = $relations;}
             if ($exists{$mindx}) {
               print "<li class=\"$class\">";
               print $j+1,"<a href=\"CGIURL/SHMT/prog/interface/call_parser_summary.cgi?filename=$dirname&amp;outscript=$SCRIPT&amp;rel=$rels&amp;sentnum=$sentnum&amp;save=no&amp;translate=no\" title=\"$word{$mindx}\">&#x2713; $word{$mindx} </a> <\/li>\n";
             } 
#           else { print "</a>&#x2613; $word{$mindx}  <\/li>\n";}
           }
         }
           $j++;
           $mindx = "$i,$j";
        }
 print "<\/ul><\/td>\n";
 }
 print "<\/tr>\n";
 print "<tr>\n";
 for($i=0; $i <= $tot_words; $i++){
 $more_rels = 1;
 print "<td><ol>\n";
 while($more_rels) {
  $more_rels = 0;
    if($COL{$i} =~ /^([^;]+);/) {
       $COL{$i} =~ s/^([^;]+);//;
       $rel_pos = $1;
       if($rel_pos =~ /([^#]+)#([^,]+),([^,]+),(.*):(.*)/){
          $from = $1;
          $rel_num = $2;
          $wpos = $3;
          $mpos = $4;
          $class = $5;
          $mpos1 = $4+1;
          $wpos1 = $3+1;
          $mindx = $from;
          $rel = $kAraka_name{$rel_num}.",".$wpos1.",".$mpos1;
          $new_rel = $from.",".$rel_num.",".$wpos.",".$mpos;
       }
       if($relations !~ /:$new_rel/) { $rels = $relations.":".$new_rel;}
       else {$rels = $relations;}
       print "<li class =\"$class\">";
       print "<a href=\"CGIURL/SHMT/prog/interface/call_parser_summary.cgi?filename=$dirname&amp;outscript=$SCRIPT&amp;rel=$rels&amp;sentnum=$sentnum&amp;save=no&amp;translate=no\" title=\"$word{$mindx}\">";
       print " &#x2713; $rel </a> <\/li>\n";
       $more_rels = 1;
    } 
 }
  print "<\/ol><\/td>\n";
}
 print "<\/tr>\n";
 print "<\/table>\n";
 print "<\/div>\n";
}
} elsif ($save eq "yes") {
  print "<table border=\"1\">\n";
  for($i=0; $i <= $tot_words; $i++){
    $indx = $i;
    $pos = $i+1;
    print "<tr><td>",$pos,"<\/td><td>",$wrd{$indx},"<\/td>";
    $j=0;
    $mindx = "$i,$j";
    while($j < 10) {
    if($word{$mindx}) {
#Display the morph analysis, only if it is compatible with the chosen relations.
           if( &compatible_mo($mindx,$relations,%COL)){
             $new_rel = "-,-,-,".$i.",".$j;
             if($relations !~ /:$new_rel/) { $rels = $relations.":".$new_rel;}
             else {$rels = $relations;}
             if ($exists{$mindx}) { print "<td>",$word{$mindx},"<\/td>"; } 
           }
    }
           $j++;
           $mindx = "$i,$j";
  }
 $more_rels = 1;
 while($more_rels) {
  $more_rels = 0;
    if($COL{$i} =~ /^([^;]+);/) {
       $COL{$i} =~ s/^([^;]+);//;
       $rel_pos = $1;
       if($rel_pos =~ /([^#]+)#([^,]+),([^,]+),(.*):(.*)/){
          $from = $1;
          $rel_num = $2;
          $wpos = $3;
          $mpos = $4;
          $mpos1 = $4+1;
          $wpos1 = $3+1;
          $mindx = "$from";
          $rel = $kAraka_name{$rel_num}.",".$wpos1.",".$mpos1;
          $class = $5;
          $new_rel = $from.",".$rel_num.",".$wpos.",".$mpos;
       }
       if($relations !~ /:$new_rel/) { $rels = $relations.":".$new_rel;}
       else {$rels = $relations;}
       print "<td>",$rel,"<\/td>";
       $more_rels = 1;
    }
  }
  print "<\/tr>\n";
 }
print "<\/table>";
}
