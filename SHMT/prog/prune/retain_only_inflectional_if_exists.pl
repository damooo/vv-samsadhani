#!PERLPATH

#  Copyright (C) 2010-2014 Amba Kulkarni (ambapradeep@gmail.com)
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
  if($in =~ /<level:1>/){
     chomp($in);
     $in =~ s/=/\//;
    ($word,@analysis) = split(/\//, $in);
 
    print $word,"=";
 
# Split the word and its analysis.
# If it has more than one analysis, and has one of the analysis has level 1
# then remove all other higher level analysis
# But this solution is not good, in case of 'sawi sapwami'
# E.g. rAme vanam gacCawi sawi ...
# Here the correct analysis of gacCawi is with Sawq prawyaya.
# Hence this module is modified accordingly by allowing nA_Sawq case as well
    $tmp = "";    
    foreach ($i=0; $i<=$#analysis;$i++){
       if(($analysis[$i] =~ /<level:1>/) || ($analysis[$i] =~ /Sawq_lat/)){
           $tmp .= "/".$analysis[$i];
       }
    }
    if($tmp ne "") { $analysis[$i] = $tmp;}
    $analysis[$i] =~ s/^\///;
    print $analysis[$i],"\n";
  } else { print $in;}
}
