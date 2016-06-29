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

#This program removes the Sawq + 7, in case there is no other word in 7th case, (and a verb.)
# rAme vanam gawe sIwA anusarawi.

$/ = "\n\n";

while($in = <STDIN>){
 chomp($in);
 if($in) {
 @in = split(/\n/,$in);
 for ($k=0;$k <=$#in; $k++) {
    $in[$k] =~ s/\$//;
    $in[$k] =~ s/=/\//;
    ($word,@analysis) = split(/\//, $in[$k]);

    print $word,"=";
 
     foreach ($i=0; $i<=$#analysis;$i++){
        if ($analysis[$i] =~ /viBakwiH:7.*level:2/) {
             $found = 0;
             foreach ($j=0; $j<=$#in; $j++){
               if($j != $k) {
                  if ($in[$j] =~ /viBakwiH:7/) { 
                      $found = 1;
                  }
               } 
             }
             if($found) { if($i>0) { print "/";} print $analysis[$i];}
        } else { if($i>0) { print "/";} print $analysis[$i];}
     }
     print "\n";
  }
 }
 print "\n";
}
