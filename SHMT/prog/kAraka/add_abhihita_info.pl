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



$/ = "\n\n";
while($in = <STDIN>){
  
  @in = split(/\n/,$in);
  $verb_pos = -1;
  $abhihita_pos = -1;
  
  for($i=0;$i<=$#in;$i++){
      if($in[$i] =~ /prayogaH:([^>]+)/) {
         $tmp = $in[$i];
         $tmp =~ s/\t$//;
         $tmp =~ s/.*\t//;
         if($tmp =~ /prayogaH:([^>]+)/) {
            $prayogaH = $1;
         }
         if($prayogaH eq "karwari")  { $abhihita = "karwA";}
         elsif($prayogaH eq "karmaNi")  { $abhihita = "karma";}
	 else { $abhihita = "";}
      }
  }

  for($i=0;$i<=$#in;$i++){
      if(($in[$i] =~ /$abhihita,([0-9]+)/) && ($abhihita ne "")){
         $verb_pos = $1-1;
         $abhihita_pos = $i+1;
         if($in[$verb_pos] =~ /\t$/) {
            $in[$verb_pos] =~ s/\t$/\taBihiwa_$abhihita,$abhihita_pos/;
         }
      }
  }

  for($i=0;$i<=$#in;$i++){
      print $in[$i],"\n";
  }

  print "\n";
}
