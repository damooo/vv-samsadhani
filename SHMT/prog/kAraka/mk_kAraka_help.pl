#!PERLPATH -I LIB_PERL_PATH/

#  Copyright (C) 2010-2016 Amba Kulkarni (ambapradeep@gmail.com)
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

# ARGV[0]: Script : DEV / ROMAN 
# Devanagari / Roman transliteration

#$ARGV[1] : sentence number

#ARGV[2]: morph input file:
# Relevant fields:
# First field: paragraph/line/word_no
# Second field: word

#ARGV[3]: file name containing names of the kaaraka tags

#ARGV[4]: File path for temporary files

$myPATH="SCLINSTALLDIR";
#STDIN: contains the output of the CLIPS file
$SCRIPT=$ARGV[0];
$sentence = $ARGV[1];

if($SCRIPT eq "DEV") {
   require "$myPATH/SHMT/prog/interface/modify_mo_fn_dev.pl";
}
if($SCRIPT eq "ROMAN") {
   require "$myPATH/SHMT/prog/interface/modify_mo_fn_roman.pl";
}

#These color codes are taken from Sanskrit_style.css (SHMT/web_interface/Sanskrit_style.css)

#$color{"N1"} = "#00FFFF";
#$color{"N2"} = "#B4FFB4";
#$color{"N3"} = "#FFEC8B";
#$color{"N4"} = "#7FFFD4";
#$color{"N5"} = "#FFDAB9";
#$color{"N6"} = "#FF99FF";
#$color{"N7"} = "#87CEFF";
#$color{"N8"} = "#C0FFC1";
#$color{"NA"} = "#E6E6FA";
#$color{"KP"} = "#FFAEB9";

$color{"N1"} = "#00BFFF";
$color{"N2"} = "#93DB70";
$color{"N3"} = "#40E0D0";
$color{"N4"} = "#B0E2FF";
$color{"N5"} = "#B4FFB4";
$color{"N6"} = "#87CEEB";
$color{"N7"} = "#C6E2EB";
$color{"N8"} = "#6FFFC3";
$color{"NA"} = "#FF99FF";
$color{"KP"} = "#FF1975";

use GDBM_File;
tie(%kAraka_name,GDBM_File,"$ARGV[3]",GDBM_READER,0644) || die "Can't open $ARGV[3] for reading";

$dir = "back";
$/ = "\n\n";
$path = $ARGV[4];
open(IN, "<$ARGV[2]") || die "Can't open $ARGV[2] for reading";
while($in = <IN>){
      @in = split(/\n/,$in);
      $hdr = "digraph G\{\nrankdir=BT;\n compound=true;\n";
# fontpath=\"/home/ambaji/.fonts\";\n";
      foreach $in (@in) {
          @flds = split(/\t/,$in);
          if(($flds[0] =~ /^([0-9]+)।([0-9]+)/) || ( $flds[0] =~ /^([0-9]+).([0-9]+)/)){
           $s_no = $1; 
           $w_no_one = $2; 
           $w_no = $2-1; 
           $indx = $s_no.".".$w_no;
           $tmp = $flds[7];
           #print STDERR "before ",$tmp,"\n";
           if($tmp =~ /\-/) {
              $tmp =~ s/स\-पू\-प/स_पू_प/g;
              $tmp =~ s/sa\-puu\-pa/sa_puu_pa/g;
              $tmp =~ s/<वर्गः:स\-उ\-प\-[^>]+>//g;
              $tmp =~ s/<vargaḥ:sa\-u\-pa\-[^>]+>//g;
              $tmp =~ s/^\///;

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
           #print STDERR "after ",$tmp,"\n";
           #   $tmp =~ s/\/[^\/]+<level:0>//g;
           #   $tmp =~ s/^[^\/]+<level:0>//;
           #   $tmp =~ s/\/[^\/]+<लेवेल्:0>//g;
           #   $tmp =~ s/^[^\/]+<लेवेल्:0>//;
           @ana = split(/\//,$tmp);
           for ($i=0;$i <= $#ana; $i++) {
               $mindx = $indx.".".$i;
               if($samAsa_pUrvapaxa) { $ana[$i] = $samAsa_pUrvapaxa."-".$ana[$i];}
               $mana = &modify_mo($ana[$i]);
               $mana =~ s/<(level|लेवेल्):[0-4]>//g;
               $mana =~ s/<(kqw_prawyayaH|कृत्_प्रत्ययः):([^>]+)>/ $2/g;
	       $mana =~ s/ /{/;
	       $mana =~ s/$/}/;
               $word{$mindx} = $mana."($w_no_one)";
               if($ana[$i] =~ /^([^<]+).*<(विभक्तिः|vibhaktiḥ|vibhakti\.h):([1-8])>/){
                $wcolor{$mindx} = $color{"N".$3};
             }
             elsif($ana[$i] =~ /^([^<]+).*<(कृत्_प्रत्ययः|kṛt_pratyayaḥ|k\.rt_pratyaya\.h)/){
                $wcolor{$mindx} = $color{"NA"};
             }
             elsif($ana[$i] =~ /^([^<]+).*<(लकारः|lakāraḥ|lakaara\.h):/){
                $wcolor{$mindx} = $color{"KP"};
             }
           }
           if($tot_words[$s_no] < $w_no) { $tot_words[$s_no] = $w_no;}
          }
      }
}
close(IN);

$/ = "\n";
$parse = 1;
$cluster_no = 0;
$rel_str = "";

## STDIN : parser output as a set of 5 tiplets
while($in = <STDIN>){
  chomp($in);
  if($in =~ /./) {
      if($in =~ /^([0-9]+).minion$/){
         $parse = 1;
         $dotfl_nm = "$sentence.$parse.dot"; 
         if ($filehandle_status == "open") { # This condition is encountered when there is no solution.
	    print TMP1 "A [shape=rectangle label=\"No Solution Found\"]";
            print TMP1 "\n}\n";
            close(TMP1);
         }
         open(TMP1,">${path}/${dotfl_nm}") || die "Can't open ${path}/${dotfl_nm} for writing";
         $indx = $sentence; 
	 %word_used = ();
         $filehandle_status = "open";
         print TMP1 $hdr;
      } elsif($in =~ /Total (Complete|Partial) Solutions=([0-9]+)/){
        $total_parses = $2;
      } elsif($in =~ /Cost = (.*)/){
        $distance = $1;
        print TMP1 "A [shape=rectangle label=\"Parse: $parse of $total_parses; Cost = $distance\"]\n";
        $parse++;
      } elsif($in =~ /\(/){
         $in =~ s/\(//;
         $in =~ s/\)//;
         if($in =~ /^([0-9]+),([0-9]+),([0-9]+),([0-9]+),([0-9]+)/){
            $is_cluster = 0;
            $s_w_no = $1;
            $s_w_a_no = $2;
            $rel_nm = $3;
            $d_w_no = $4;
            $d_w_a_no = $5;
            if($rel_nm == 2) { $style = "dashed color=\"red\"";$rank = "{rank = same; Node$s_w_no; Node$d_w_no;}"; $dir = "both";}
            elsif($rel_nm > 100) { $rel_nm = $rel_nm - 100; $style = "dotted";}
            else {$style = ""; $dir = "back";}
            $k_rel_nm = $kAraka_name{$rel_nm};
	    if(($k_rel_nm =~ /समुच्चितम्/) || ($k_rel_nm =~ /अन्यतरः/)|| (($k_rel_nm =~ /विशेषणम्/) && ($k_rel_nm !~ /क्रियाविशे/) )|| ($k_rel_nm =~ /^वाक्यकर्म$/) ||
               ($k_rel_nm =~ /samuccitam/) || ($k_rel_nm =~ /anyataraḥ/)|| ($k_rel_nm =~ /anyatara\.h/) || (($k_rel_nm =~ /viśeṣaṇam/) && ($k_rel_nm !~ /kriyāvi/)) || ($k_rel_nm =~ /^vākyakarma$/)){
                if($cluster[$cluster_no] =~ /#$d_w_no;$d_w_a_no,/) {
                   if($cluster[$cluster_no] !~ /#$s_w_no;$s_w_a_no,/) {
                         $cluster[$cluster_no] .= "#".$s_w_no.";".$s_w_a_no.",";
                         $is_cluster = 1;
                   }
                } else {
                   $cluster_no++;
                   $cluster[$cluster_no] = "#".$s_w_no.";".$s_w_a_no.",";
                   $cluster[$cluster_no] .= "#".$d_w_no.";".$d_w_a_no.",";
                   $is_cluster = 1;
                }
#Following lines are commented, since all the words were included in cluster.
            #} else {
            #       for($z=0;$z<=$cluster_no;$z++){
            #         if(($cluster[$z] =~ /#$d_w_no;$d_w_a_no,/) || 
            #            ($cluster[$z] !~ /#$s_w_no;$s_w_a_no,/)){
            #             $cluster[$z] .= "#".$s_w_no.";".$s_w_a_no.",";
            #             $is_cluster = 1;
            #         }
            #       }
            } 
            if ($is_cluster == 0) {
                   if($non_cluster !~ /#$s_w_no;$s_w_a_no,/) {
                      $non_cluster .= "#".$s_w_no.";".$s_w_a_no.",";
                   }
                   if($non_cluster !~ /#$d_w_no;$d_w_a_no,/) {
                      $non_cluster .= "#".$d_w_no.";".$d_w_a_no.",";
                   }
            }
            
           if($style ne "") { $s_str = "style=$style";} else {$s_str = "";}
	   $rel_str .= "\nNode$s_w_no -> Node$d_w_no \[ $s_str label=\"".$k_rel_nm."\"  dir=\"$dir\" \]";
       }
      }
  } else {
        if($rel_str) {
          for($i=1; $i <= $cluster_no;$i++){

              print TMP1 "\nsubgraph cluster_",$i,"{\n";

              $nodes = $cluster[$i];
              $nodes =~ s/^#//;
              @nodes = split(/#/,$nodes);
              foreach $node (@nodes) {
		    $node =~ s/,//;
		    $node =~ s/;/./;
		    $indx = $sentence.".".$node;
		    $node =~ s/\..*//;
                    print TMP1 "Node$node [style=filled, color=\"$wcolor{$indx}\" ";
#If it is a verb, shape is rectangle.
		    if($wcolor{$indx} eq "#FFAEB9") { print TMP1 "shape=rectangle ";}
                    print TMP1 "label = \"$word{$indx}\"]\n";
		    $word_used{$node} = 1;
              }
                  print TMP1 "\n}\n";
          }
              $nodes = $non_cluster;
              $nodes =~ s/^#//;
              @nodes = split(/#/,$nodes);
              foreach $node (@nodes) {
		    $node =~ s/,//;
		    $node =~ s/;/./;
		    $indx = $sentence.".".$node;
		    $node =~ s/\..*//;
                    print TMP1 "Node$node [style=filled, color=\"$wcolor{$indx}\" ";
		    if($wcolor{$indx} eq "#FFAEB9") { print TMP1 "shape=rectangle ";}
                    print TMP1 "label = \"$word{$indx}\"]\n";
		    $word_used{$node} = 1;
              }

	 for ($z=0;$z<=$tot_words[$sentence];$z++){
	   if($word_used{$z} != 1) {
		    $indx = $sentence.".".$z.".0";
                    print TMP1 "Node$z [style=filled, color=\"$wcolor{$indx}\" ";
		    if($wcolor{$indx} eq "#FFAEB9") { print TMP1 "shape=rectangle ";}
                    print TMP1 "label = \"$word{$indx}\"]\n";
	   }
         }
         @rel_str = split(/\n/,$rel_str);
         $rel_str = "";
         foreach $r (@rel_str) {
	      $r =~ /Node([0-9]+) \-> Node([0-9]+).*label="([^"]+)"/;
              $from = $1;
              $to = $2;
              $label = $3;
              for($z=0;$z<=$cluster_no;$z++){
                if(($cluster[$z] =~ /#$from;/) && ($cluster[$z] !~ /#$to;/)){
                    $r =~ s/]/ ltail=cluster_$z]/;
                }
              }
              $rel_str .= "\n".$r;
         }
         print TMP1 $rank;
         print TMP1 "/* Start of Relations section */\n";
         print TMP1 $rel_str,"\n}\n";
         $rel_str = "";
         $filehandle_status = "close";
         close(TMP1);
         if($parse == 2) {
            system("GraphvizDot/dot -Tjpg -o${path}/$sentence.1.jpg ${path}/$sentence.1.dot");
         }
#Restrict the number of diagrams to 100
         $max = 10;
         if($total_parses < $max) { $max = $total_parses;}

         if($parse <= $max) {
            $dotfl_nm = "$sentence.$parse.dot"; 
            open(TMP1,">${path}/${dotfl_nm}") || die "Can't open ${path}/${dotfl_nm} for writing";
            $indx = $sentence; 
            print TMP1 $hdr;
         }
	 $cluster_no = 0;
	 $rel_str = "";
         @cluster = ();
	 $non_cluster = "";
    } else { 
	    print TMP1 "A [shape=rectangle label=\"No Solution Found\"]";
            print TMP1 "\n}\n";
            close(TMP1);
            if($parse == 2) {
              system("GraphvizDot/dot -Tjpg -o${path}/$sentence.1.jpg ${path}/$sentence.1.dot");
            }
    }
  }
}
 
if($rel_str) {

          for($i=1; $i <= $cluster_no;$i++){

              print TMP1 "\nsubgraph cluster_",$i,"{\n";

              $nodes = $cluster[$i];
              $nodes =~ s/^#//;
              @nodes = split(/#/,$nodes);
              foreach $node (@nodes) {
		    $node =~ s/,//;
		    $node =~ s/;/./;
		    $indx = $sentence.".".$node;
		    $node =~ s/\..*//;
                     print TMP1 "Node$node [style=filled, color=\"$wcolor{$indx}\" ";
		    if($wcolor{$indx} eq "#FFAEB9") { print TMP1 "shape=rectangle ";}
                     print TMP1 "label = \"$word{$indx}\"]\n";
		    $word_used{$node} = 1;
              } 
          }
              $nodes = $non_cluster;
              $nodes =~ s/^#//;
              @nodes = split(/#/,$nodes);
              foreach $node (@nodes) {
		    $node =~ s/,//;
		    $node =~ s/;/./;
		    $indx = $sentence.".".$node;
		    $node =~ s/\..*//;
                     print TMP1 "Node$node [style=filled, color=\"$wcolor{$indx}\" ";
		    if($wcolor{$indx} eq "#FFAEB9") { print TMP1 "shape=rectangle ";}
                     print TMP1 "label = \"$word{$indx}\"]\n";
		    $word_used{$node} = 1;
              } 
	 for ($z=0;$z<=$tot_words[$sentence];$z++){
	   if($word_used{$z} != 1) {
		    $indx = $sentence.".".$z.".0";
                    print TMP1 "Node$z [style=filled, color=\"$wcolor{$indx}\" ";
		    if($wcolor{$indx} eq "#FFAEB9") { print TMP1 "shape=rectangle ";}
                    print TMP1 "label = \"$word{$indx}\"]\n";
	   }
         }
         @rel_str = split(/\n/,$rel_str);
         $rel_str = "";
         foreach $r (@rel_str) {
	      $r =~ /Node([0-9]+) \-> Node([0-9]+).*label="([^"]+)"/;
              $from = $1;
              $to = $2;
              $label = $3;
              for($z=0;$z<=$cluster_no;$z++){
                if(($cluster[$z] =~ /#$from;/) || ($cluster[$z] =~ /#$to;/)) {
                    $r =~ s/]/ ltail=cluster_$z]/;
                }
              }
              $rel_str .= "\n".$r;
         }
 print TMP1 $rel_str,"\n}\n";
 $rel_str = "";
 $filehandle_status = "close";
 close(TMP1);
} else { 
	    print TMP1 "A [shape=rectangle label=\"No Solution Found\"]";
            print TMP1 "\n}\n";
            close(TMP1);
    }
system("GraphvizDot/dot -Tjpg -o${path}/$sentence.1.jpg ${path}/$sentence.1.dot");
