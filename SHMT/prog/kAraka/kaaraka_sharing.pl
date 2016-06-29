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

tie(%kAraka_name,GDBM_File,"$ARGV[0]",GDBM_READER,0644) || die "Can't open $ARGV[0] for reading";
tie(%kAraka_num,GDBM_File,"$ARGV[1]",GDBM_READER,0644) || die "Can't open $ARGV[1] for reading";

$ans = "";
$i=0;

while($in = <STDIN>){
  chomp($in);
  if($in =~ /./) {
      if($in =~ /Cost/){
         $lans = $in."\n";
      }elsif($in !~ /^\(/){
         $ans .= $in."\n";
      } elsif($in =~ /\(/){
         $in =~ /([0-9]+),([0-9]+),([0-9]+),([0-9]+),([0-9]+)/;
         $rel_nm = $3;
         $k_rel_nm[$i] = $kAraka_name{$rel_nm};
         $in[$i] = $in;
         $i++;
      }
  } else {
    for($j=$i-1;$j>=0;$j--){
#If it is pUrvakAla
       if($k_rel_nm[$j] eq "pUrvakAlaH") {
         $in[$j] =~ /([0-9]+),([0-9]+),([0-9]+),([0-9]+),([0-9]+)/;
# Get main verb position
         $verb_pos = $4.",".$5;
         $pUrvakAla_pos = $1.",".$2;
         #print "Calling sub routine karwA \n";   
       if(!&karwA($i, $pUrvakAla_pos)) {
         for($k=0;$k<$i;$k++){
            $in[$k] =~ /([0-9]+),([0-9]+),([0-9]+),$verb_pos/;
            $rel = $3;
            if(($in[$k] =~ /([0-9]+),([0-9]+),$rel,$verb_pos/) &&
               (($k_rel_nm[$k] eq "karwA") || ($rel == $kAraka_num{"karwA"}+100))) {
#Get the karwA of main verb
               $in[$i] = $in[$k];
               if($rel < 100) { $rel += 100;}
#Share it with the verb in kwvA/pUrvakAlaH
               $in[$i] =~ s/,[0-9]+,$verb_pos/,$rel,$pUrvakAla_pos/;
               $i++;
            }
         }
       }
       }
       if($k_rel_nm[$j] eq "prayojanam") {
         $in[$j] =~ /([0-9]+),([0-9]+),([0-9]+),([0-9]+),([0-9]+)/;
# Get main verb position
         $verb_pos = $4.",".$5;
         $prayojana_pos = $1.",".$2;
         #print "Calling sub routine karwA \n";   
       if(!&karwA($i, $prayojana_pos)) {
         for($k=0;$k<$i;$k++){
            $in[$k] =~ /\(([0-9]+),([0-9]+),([0-9]+),/;
            $rel = $3;
            if(($in[$k] =~ /([0-9]+),([0-9]+),$rel,$verb_pos/) &&
               (($k_rel_nm[$k] eq "karwA") || ($rel == $kAraka_num{"karwA"}+100))) {
#Get the karwA of main verb
               $in[$i] = $in[$k];
               if($rel < 100) { $rel += 100;}
#Share it with the verb in wumun/prayojanam
               $in[$i] =~ s/,[0-9]+,$verb_pos/,$rel,$prayojana_pos/;
               $i++;
            }
         }
        }
       }
     }
     for($j=0;$j<$i;$j++){
         $ans .= $in[$j]."\n";
     }
     $ans .= $lans;
     print $ans,"\n";
     $ans = "";
     $i=0;
  }
 }
 print $ans;

sub karwA {
my($relations, $pos) = @_;

#print "relations = $relations\n";
#print "pos = $pos\n";
my($j, $k, $current_pos);
for($j=0;$j<=$relations;$j++){
  $in[$j] =~ /([0-9]+),([0-9]+),([0-9]+),([0-9]+),([0-9]+)/;
  $k = $3;
  $current_pos = $4.",".$5;
  #print "k = $k current_pos = $current_pos\n";
  #print "$k_rel_nm[$j]\n";
  if((($k_rel_nm[$j] eq "karwA") || ( $k == $k_rel_num{"karwA"}+100)) && ($pos eq $current_pos)){
     #print "found\n";
    return 1;
  }
}
return 0;
}
1;
