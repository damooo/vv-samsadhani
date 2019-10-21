#!/usr/bin/env perl

#  Copyright (C) 2010-2019 Amba Kulkarni (ambapradeep@gmail.com)
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

#BEGIN{require "$ARGV[0]/paths.pl";}

#use lib $GlblVar::LIB_PERL_PATH;

#use GDBM_File;

$SCLINSTALLDIR = $ARGV[0];
$GraphvizDot = $ARGV[1];

$SCRIPT=$ARGV[2]; # Script : DEV / IAST 
$sentence = $ARGV[3]; #sentence number
#ARGV[2]: morph input file:
#ARGV[3]: file name containing names of the kaaraka tags
#tie(%kAraka_name,GDBM_File,"$ARGV[5]",GDBM_READER,0644) || die "Can't open $ARGV[5] for reading";
open(TMP,"$ARGV[5]") || die "Can't open $ARGV[5] for reading";
while(<TMP>) {
chomp;
if(/^([^ ]+) ([0-9]+)/){
$num = $2;
$name = $1;
$kAraka_name{$num}=$name;
}
}
$path = $ARGV[6]; # path for temporary files
#$parse = $ARGV[7]; # parse no
$parse = 1;


if($SCRIPT eq "DEV") {
   require "$SCLINSTALLDIR/SHMT/prog/interface/modify_mo_fn_dev.pl";
}
if($SCRIPT eq "IAST") {
   require "$SCLINSTALLDIR/SHMT/prog/interface/modify_mo_fn_roman.pl";
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

#ARGV[2]: morph input file:
&read_mo($ARGV[4]);

$/ = "\n";
$cluster_no = 0;
$rel_str = "";
$solnfound = 0;

$hdr = "digraph G\{\nrankdir=BT;\n compound=true;\n bgcolor=\"lemonchiffon1\";";
$dir = "back";

## STDIN : parser output as a set of 5 tuples
while(($in = <STDIN>) && !$solnfound){
  chomp($in);
  if ($in =~ /./){
      if($in =~ /^([0-9]+).minion$/){
         $dotfl_nm = "$sentence.$parse.dot"; 
         if ($filehandle_status == "open") { 
            # This condition is encountered when there is no solution.
            &print_no_solution();
         }
         open TMP1, ">${path}/${dotfl_nm}" || die "Can't open ${path}/${dotfl_nm} for writing";
         $indx = $sentence; 
	 %word_used = ();
         $filehandle_status = "open";
         print TMP1 $hdr;
      } elsif($in =~ /Total (Complete|Partial) Solutions=([0-9]+)/){
        $total_parses = $2;
      } elsif($in =~ /Cost = (.*)/){
        $distance = $1;
        print TMP1 "A [shape=rectangle label=\"Parse: $parse of $total_parses; Cost = $distance\"]\n";
      } elsif($in =~ /Solution:([0-9]+)/){
       #      if($parse == $1) { $solnfound = 1;} else {$solnfound = 0;}
       #       if ($solnfound == 0) { $solnfound = 1;} else {$solnfound = 0;}
      }
      elsif($in =~ /\(/){
         $in =~ s/\(//;
         $in =~ s/\)//;
         if($in =~ /^([0-9]+),([0-9]+),([0-9]+),([0-9]+),([0-9]+)/){
            $is_cluster = 0;
            $s_w_no = $1;
            $s_w_a_no = $2;
            $rel_nm = $3;
            $d_w_no = $4;
            $d_w_a_no = $5;
          # if($rel_nm == 0) 
          #    my $tmp = $sentence.".".$d_w_no.".".$d_w_a_no;
          #    my $tmp1 = $sentence.".".$s_w_no.".".$s_w_a_no;
          #    $word{$tmp} .= "_".$word{$tmp1};
          #    $word_used{$s_w_no} = 1;
          # } elsif($rel_nm == 1) {
            if($rel_nm == 0) {
              my $tmp = $sentence.".".$d_w_no.".".$d_w_a_no;
              my $tmp1 = $sentence.".".$s_w_no.".".$s_w_a_no;
              $word{$tmp} = $word{$tmp1}."_".$word{$tmp};
              $word_used{$s_w_no} = 1;
             # $word_used{$d_w_no} = 1;
           } elsif($rel_nm == 1) {
              my $tmp = $sentence.".".$d_w_no.".".$d_w_a_no;
              my $tmp1 = $sentence.".".$s_w_no.".".$s_w_a_no;
              $word{$tmp} .= "_".$word{$tmp1};
              $word_used{$s_w_no} = 1;
           } else {
            if (($rel_nm == 2) || ($rel_nm == 90)){
               $style = "dashed color=\"red\"";
               $rank = "{rank = same; Node$s_w_no; Node$d_w_no;}"; 
               $dir = "both";
            } elsif(($rel_nm > 100) && ($rel_nm < 1000)) {
              $rel_nm = $rel_nm - 100; 
              $style = "dotted";
            } else {
              $style = ""; 
              $dir = "back";
            }
            $k_rel_nm = $kAraka_name{$rel_nm};
            if (&cluster_relations($k_rel_nm)) {
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
      }
  } else { $solnfound = 1;}
}
 #else
        if ($solnfound) {
          if ($rel_str ne "") {

             &draw_clusters($non_cluster,$cluster_no,$sentence,$rel_str,@cluster);

             print TMP1 $rank;
             print TMP1 "/* Start of Relations section */\n";
             &writeNclose($rel_str);
             $filehandle_status = "close";
             $rel_str = "";
             system("$GraphvizDot -Tsvg -o${path}/$sentence.$parse.svg ${path}/$sentence.$parse.dot");

          } elsif($filehandle_status eq "open"){

             &print_no_solution();

             system("$GraphvizDot -Tsvg -o${path}/$sentence.$parse.svg ${path}/$sentence.$parse.dot");
          }
    }
#  }
#}
 
## When is the following code needed ? 
## Add clusters
## if($rel_str) {
## &draw_clusters($non_cluster,$cluster_no,$sentence,$rel_str,@cluster);
## &writeNclose($rel_str);
## $rel_str = "";
## $filehandle_status = "close";
##} else { 
##         if($filehandle_status eq "open"){
##            &print_no_solution();
##            system("$GraphvizDot/dot -Tsvg -o${path}/$sentence.$parse.svg ${path}/$sentence.$parse.dot");
##         }
##}
##
##

sub get_color{
  my($ana) = @_;

  my ($color);
  if($ana =~ /^([^<]+).*<(विभक्तिः|vibhaktiḥ|vibhakti\.h):([1-8])>/){
     $color = $color{"N".$3};
  } elsif($ana =~ /^([^<]+).*<(कृत्_प्रत्ययः|kṛt_pratyayaḥ|k\.rt_pratyaya\.h)/){
     $color = $color{"NA"};
  } elsif($ana =~ /^([^<]+).*<(लकारः|lakāraḥ|lakaara\.h):/){
     $color = $color{"KP"};
  }
$color;
}
1;

## Read the morph output
# Relevant fields:
# First field: paragraph/line/word_no
# Second field: word
# Seventh field : morph analysis

sub read_mo {

 my($file) = @_;

 my($in,@in,@flds,$s_no,$pos,$w_no,$indx,$tmp,$samAsa_pUrvapaxa,$mindx,$i,@ana,$mana);

#Global variables
# %wcolor, %word, $tot_words
$/ = "\n\n";
open(IN, "<$file") || die "Can't open $file for reading";
while($in = <IN>){
      @in = split(/\n/,$in);
      foreach $in (@in) {
          @flds = split(/\t/,$in);
          if(($flds[0] =~ /^([0-9]+)।([0-9]+)/) || ( $flds[0] =~ /^([0-9]+).([0-9]+)/)){
           $s_no = $1; 
           $pos = $2; 
           $w_no = $pos-1;  #index starts with 0
           $indx = $s_no.".".$w_no;
           $word = $flds[2];
           $tmp = $flds[7];
           if($tmp =~ /\-/) {
              $tmp =~ s/स\-पू\-प/स_पू_प/g;
              $tmp =~ s/sa\-puu\-pa/sa_puu_pa/g;
              $tmp =~ s/<वर्गः:स\-उ\-प\-[^>]+>//g;
              $tmp =~ s/<vargaḥ:sa\-u\-pa\-[^>]+>//g;
              $tmp =~ s/^\///;
           }
           if( $tmp =~ /^([^>]+)\-/) { 
               $samAsa_pUrvapaxa = $1;
               $tmp =~ s/^([^>]+)\-//;
           } else { $samAsa_pUrvapaxa = "";}
           @ana = split(/\//,$tmp);
           for ($i=0;$i <= $#ana; $i++) {
                $mindx = $indx.".".$i;
                if($samAsa_pUrvapaxa) { 
                  $ana[$i] = $samAsa_pUrvapaxa."-".$ana[$i];
                }
                $mana = &modify_mo($ana[$i]);
                $mana =~ s/<(level|लेवेल्):[0-4]>//g;
                $mana =~ s/<(kqw_prawyayaH|कृत्_प्रत्ययः):([^>]+)>/ $2/g;
	        $mana =~ s/ /{/;
	        $mana =~ s/$/}/;
                $word{$mindx} = $word."($pos)";
                $word_ana{$mindx} = $mana;
                $wcolor{$mindx} = &get_color($ana[$i]);
           }
           if($tot_words[$s_no] < $w_no) { $tot_words[$s_no] = $w_no;}
          }
      }
}
close(IN);
}
1;

sub draw_clusters{
my($non_cluster,$cluster_no,$sentence,$rel_str,@cluster) = @_;

my($i,@rel_str,$node,$nodes,@nodes,$node_id,$indx_id,$z,$r,$from,$to);

#Global variables: %word, %word_ana, $wcolor,%word_used, @tot_words,

    for($i=1; $i <= $cluster_no;$i++){

      print TMP1 "\nsubgraph cluster_",$i,"{\n";

      $nodes = $cluster[$i];
      &print_all_nodes_info($nodes,$sentence);
      print TMP1 "\n}\n";
    }

    $nodes = $non_cluster;
    &print_all_nodes_info($nodes,$sentence);

 ## Add all the nodes that were not printed earlier.
    for ($z=0;$z<=$tot_words[$sentence];$z++){
         if($word_used{$z} != 1) {
	    $indx = $sentence.".".$z.".0";
            &print_node_info($z,$word{$indx},$word_ana{$indx},$wcolor{$indx});
	 }
    }
         @rel_str = split(/\n/,$rel_str);
         $rel_str = "";
         foreach $r (@rel_str) {
	      $r =~ /Node([0-9]+) \-> Node([0-9]+).*label="[^"]+"/;
              $from = $1;
              $to = $2;
              for($z=0;$z<=$cluster_no;$z++){
                if(($cluster[$z] =~ /#$from;/) && ($cluster[$z] !~ /#$to;/)){
                    $r =~ s/]/ ltail=cluster_$z]/;
                }
              }
              $rel_str .= "\n".$r;
         }
$rel_str;
}
1;

sub print_no_solution{
    print TMP1 "A [shape=rectangle label=\"No Solution Found\"]";
    print TMP1 "\n}\n";
    close(TMP1);
}
1;

sub print_all_nodes_info{
 my($nodes,$sentence) = @_;
 my(@nodes,$node,$node_id,$indx_id);

#Global variables: %word, %wcolor, %word_used
   $nodes =~ s/^#//;
   @nodes = split(/#/,$nodes);
   foreach $node (@nodes) {
     ($node_id, $indx_id) = split(/#/,&get_node_indx_ids($node,$sentence));
     if($word_used{$node_id} != 1) {
      &print_node_info($node_id,$word{$indx_id},$word_ana{$indx_id},$wcolor{$indx_id});
      $word_used{$node_id} = 1;
     }
   }
}
1;

sub print_node_info{
    my($node,$word,$word_ana,$color) = @_;
    print TMP1 "Node$node [style=filled, color=\"$color\" ";
    if($color eq "#FFAEB9") { print TMP1 "shape=rectangle ";}
    print TMP1 "label = \"$word\"";
    print TMP1 " tooltip = \"$word_ana\"]\n";
}
1;

sub writeNclose{
   my($rel_str) = @_;
   print TMP1 $rel_str,"\n}\n";
   close(TMP1);
 }
1;

sub cluster_relations{
  my($rel) = @_;
  if(   ($k_rel_nm =~ /सुप्_समुच्चित/) 
     || ($k_rel_nm =~ /अन्यतरः/)
     || (   ($k_rel_nm =~ /विशेषणम्/) 
          && ($k_rel_nm !~ /क्रियाविशे/) )
 #   || ($k_rel_nm =~ /^वाक्यकर्म$/) 
 #   || ($k_rel_nm =~ /^vākyakarma$/)
     || ($k_rel_nm =~ /sup_samuccitam/) 
     || ($k_rel_nm =~ /anyataraḥ/)
     || ($k_rel_nm =~ /anyatara\.h/) 
     || (   ($k_rel_nm =~ /viśeṣaṇam/) 
          && ($k_rel_nm !~ /kriyāvi/))) { 
    return 1;
  } else { return 0;}
}
1;

 sub get_node_indx_ids{
 my($node,$sentence) = @_;
 my($sid);
     $node =~ s/,//;
     $node =~ s/;/./;
     $sid = $sentence.".".$node;
     $node =~ s/\..*//;
 $node."#".$sid;
}
1;
