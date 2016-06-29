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

use GDBM_File;

tie(%kAraka_name,GDBM_File,"$ARGV[0]/kAraka_name.gdbm",GDBM_READER,0644) || die "Can't open $ARGV[0]/kAraka_name.dbm for reading";

open(TMP,$ARGV[1]) || die "Can't open $ARGV[1] for reading";
$Max_Parses = $ARGV[2];
$GH_input = $ARGV[3];

$sent = 0;
$parse = 0;
while ($in = <TMP>) {
	if($in =~ /^([0-9]+).minion/) {
           if($parse == 1) { $parse = 2;} # To print the analysis
           $PARSE{$sent} = $parse; 
	#print "$sent=$PARSE{$sent}\n"; 
           $sent = $1; 
           $parse = 1;
        } elsif($in =~ /\(/) {
            #$in =~ /^\(([0-9]+) ([0-9]+)\)/;
            $in =~ /^\(([0-9]+),([0-9]+),([0-9]+),([0-9]+),([0-9]+)\)/;
            $wrd = $1;
            $ana = $2;
            $rel = $3;
            $wrd1 = $4;
            $wrd1_order = $wrd1+1;
            $ana1 = $5;
            $key = $parse."_".$sent."_".$wrd;
            $key1 = $parse."_".$sent."_".$wrd1;
            if($ANA{$key} eq "") { $ANA{$key} = $ana;}
            if($ANA{$key1} eq "") { $ANA{$key1} = $ana1;}
            if($REL{$key} eq "") { $REL{$key} = $kAraka_name{$rel}.",".$wrd1_order;}
#            $ANA{$key} = $ana;
            #print  "key val = ",$key," ",$ana,"\n";
           #print  "key1 val1 = ",$key1," ",$ana1,"\n";
        } elsif ($in =~ /Cost/) { $parse++;
	#%REL=();
	#%ANA=();
        } else {} # print $in?
}
close(TMP);

if($parse == 1) { $parse = 2;} # To print the analysis
#print "parse = $parse\n";
#print "Max_Parses = $Max_Parses\n";
#print "$sent=$PARSE{$sent}\n";
$/ = "\n\n";
$sent = 1;
while($in = <STDIN>){

#print "Max_Parses = $Max_Parses\n";
#print "PARSE{sent} = $PARSE{$sent}\n";
     if(!defined($PARSE{$sent})) { $PARSE{$sent} = 2;}
     if($Max_Parses < $PARSE{$sent}) {$max_limit = $Max_Parses+1;} else { $max_limit = $PARSE{$sent};}
#     print "max_limit = $max_limit\n";
     #print "in = $in\n";
     for ($i=1; $i < $max_limit; $i++) {
     @ana = split(/\n/,$in);

     $word_count = 0;
     foreach $ana (@ana) {
        chomp($ana);
        @w_ana = split(/\t/,$ana);
        if($GH_input eq "YES") {
           if($i == 1) { $w_ana[1] =~ s/<p><a>/<p><s><a>/;} #Added for GH interface
           if($i != 1) { $w_ana[1] =~ s/<s>/<s><a>/;} #Added for GH interface
        } else {
        if($i == 1) { $w_ana[1] =~ s/<s>/<s><a>/;}
        if($i != 1) { $w_ana[1] =~ s/<s>/<a>/;}
        if($i != 1) { $w_ana[1] =~ s/<p>//;}
        }
        if($GH_input eq "YES") {
        if($i == $max_limit-1) { $w_ana[4] =~ s/<\/a><\/p>/<\/a><\/s><\/p>/;} #Added for GH interface
        if($i != $max_limit-1) { $w_ana[4] =~ s/<\/s>/<\/s><\/a>/;} #Added for GH interface
        } else {
        if($i == $max_limit-1) { $w_ana[4] =~ s/<\/s>/<\/a><\/s>/;}
        if($i != $max_limit-1) { $w_ana[4] =~ s/<\/s>/<\/a>/;}
        if($i != $max_limit-1) { $w_ana[4] =~ s/<\/p>//;}
        }
        #print $sent, "\t",$PARSE{$sent}, "\t",$i,"\n";
        #print "w_ana 3 =",$w_ana[3], "\n";
        print $w_ana[0],"\t",$w_ana[1],"\t",$w_ana[2],"\t",$w_ana[3],"\t",$w_ana[4],"\t",$w_ana[5],"\t",$w_ana[6],"\t",$w_ana[7],"\t";
        if($w_ana[7] =~ /-/) {
           $w_ana[7] =~ s/^(.*)\-([^\-]+)/$2/;
           $samAsa_pUrvapaxa = $1;
           $samAsa_pUrvapaxa =~ s/<[^>]+>//g;
           $samAsa_pUrvapaxa =~ s/\/[^-]+//g;
        } else {$samAsa_pUrvapaxa = "";}
        #print "s pU = $samAsa_pUrvapaxa\n";
        #print "w ana = $w_ana[6]\n";
        $w_ana[7] =~ s/\/[a-zA-Z]+<vargaH:sa\-u\-pa\-[^>]+>[^\/]+<level:0>//g;
        $w_ana[7] =~ s/^[a-zA-Z]+<vargaH:sa\-u\-pa\-[^>]+>[^\/]+<level:0>//g;
        $w_ana[7] =~ s/^\///;
        if($samAsa_pUrvapaxa ne "") { print $samAsa_pUrvapaxa,"-";}
        @mo_ana = split(/\//,$w_ana[7]);
        $ana_count = 0;
        $found=0; 
        foreach $mo_ana (@mo_ana) {
          $key = $i."_".$sent."_".$word_count;
           #print  "key ana1 = ",$key,"# ",$ANA{$key},"=",$ana_count,"\n";
          if(defined($ANA{$key}) && ($ANA{$key} == $ana_count)) {
           print $mo_ana;         
           print "\t",$REL{$key};
           #print  "key ana2 = ",$key,"* ",$ana_count,"\n";
           $found=1;
          }
          $ana_count++;
        }
        if(!$found) { print $w_ana[7],"\t";}
        $word_count++;
        print "\n";
      }
      print "\n";
  }
  $sent++;
}

untie(%kAraka_name);
