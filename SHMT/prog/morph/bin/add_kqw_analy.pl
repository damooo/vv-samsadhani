#!PERLPATH -I LIB_PERL_PATH/

#  Copyright (C) 2002-2016 Amba Kulkarni (ambapradeep@gmail.com)
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
tie(%RD_KQW,GDBM_File,"$ARGV[0]",GDBM_READER,0644) || die "Can't open $ARGV[0] for reading"; 
tie(%KQW_MO,GDBM_File,"$ARGV[1]",GDBM_READER,0644) || die "Can't open $ARGV[1] for reading"; 
open(TMP,"<$ARGV[2]") || die "Can't open $ARGV[2] for reading";

while($in = <TMP>){
chomp($in);
@in = split(/\//,$in);
 for($i=1;$i<=$#in;$i++){
     if(($in[$i] =~ /<level:0>/) && &frequent_kqw_suffix($in[$i])) {
        $in[$i] =~ s/<level:0>//g;
        $in[$i] =~ s/\$//;
        $KQW{$in[0]} .= "#". $in[$i];
     }
 }
 $KQW{$in[0]} =~ s/^#//;
}
close(TMP);

while($in = <STDIN>){
chomp($in);
  if($in) {
    @ana = split(/\//,$in);
    $ans = "";
    foreach $ana (@ana) {
       $ana =~ /^([^<]*\-)*([^<\-]+)</;
       $ppada = $1;$rt = $2;
       if((!$RD_KQW{$rt}) && ($ana !~ /<vargaH:nA_/)){
           $tmp = $ana;
           $ana =~ /<lifgam:([^>]+)>/;
           $ana_lifgam = $1;
           if($KQW_MO{$rt} || $KQW{$rt}) {
             if($KQW_MO{$rt}) {
                @kqw_ana = split(/\//,$KQW_MO{$rt});
             } elsif($KQW{$rt}) {
                @kqw_ana = split(/#/,$KQW{$rt});
             }
             foreach $kqw_ana (@kqw_ana) {
               $kqw_ana =~ /<lifgam:([^>]+)>/;
               $kqw_lifgam = $1;
               if($kqw_lifgam eq $ana_lifgam) {
                  $tmp =~ s/^$ppada$rt/$ppada${kqw_ana}<kqw_pratipadika:${rt}>/;
                  $tmp =~ s/<lifgam:[^>]+>//;
                  $tmp =~ s/<level:[01]>//;
                  $ans .= "/".$tmp;
                  $tmp = $ana;
               }
             } if($ans eq "") { $ans = $ana;}
           } else {$ans .= "/".$ana;}
       } else {$ans .= "/".$ana;}
     }
     $ans =~ s/^\///;
     #print $wrd,"=",$ans,"\n";    
     print $ans,"\n";    
  } else { print "\n";}
}
untie(%RD_KQW);
untie(%KQW_MO);

sub frequent_kqw_suffix {
my($in) = @_;
if($in =~ /kqw_prawyayaH:(Sawq_lat|SAnac_lat|wqc|Nvul|kwa|kwavawu|lyut|GaF|yak|Namul|wavya|wavyaw|anIyar|yaw|kyap|Nyaw|Kal|yuc|A)/) {
   return 1;
} else {return 0;}
}
1;
