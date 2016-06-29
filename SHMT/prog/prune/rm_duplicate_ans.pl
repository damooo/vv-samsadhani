#!PERLPATH

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



while($in = <STDIN>){
 chomp($in);
 if($in) {
 $in =~ s/\$//;
 $in =~ s/=/\//;
 ($word,@analysis) = split(/\//, $in);
 #print "analysis = ",@analysis,"\n";

# print $word,"=";
 
print $word,"=",$analysis[0];
#print "\n";
 
# Split the word and its analysis.
# remove the analysis that are repeated.
# If same analysis with both level 1 and 2, or level 1 and 3, or level 1 and 4 then remove the analysis with level 2 or 3 or 4.
# Earlier it used to retain level 1 analysis. But it is changed to level 2/3/4, because many of the words in the MW dictionary are derived nouns, and we require the deeper analysis for kaaraka analysis.

# Algo: For each of the analysis, check whether it has been repeated earlier.
# If not, then print.

  foreach ($i=1; $i<=$#analysis;$i++){
#     print "i=$i", $analysis[$i],"\n";
     $diff = 1;
     foreach ($j=0; $j<$i && $diff; $j++){
#       print "j = $j", $analysis[$j],"\n";
       if($analysis[$i] eq $analysis[$j]) { $diff = 0;}
       else {
              $tmp = $analysis[$j];
              $tmp1 = $analysis[$i];
              $tmp =~ s/<level:[234]>/<level:1>/;
              $tmp1 =~ s/<level:[234]>/<level:1>/;
# Taddhita analysis is removed, since we do not require it for kaaraka analysis
	      $tmp =~ s/nA_[^>]+>/nA>/;  # This is to remove the taddhita analysis, if present
	      $tmp1 =~ s/nA_[^>]+>/nA>/;  # This is to remove the taddhita analysis, if present
              if ($tmp eq $tmp1) { $diff = 0;}
           }
     } 
     if($diff) { print "/"; print $analysis[$i];}
  }
 }
 print "\n";
}
