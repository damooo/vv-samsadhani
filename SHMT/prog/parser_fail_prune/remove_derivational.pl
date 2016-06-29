#!PERLPATH

#  Copyright (C) 2009-2016 Amba Kulkarni (ambapradeep@gmail.com)
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

if($in =~ /\//) {
   chomp($in);
   $in = &remove_deri($in);
   print $in,"\n";
}
else { print $in;}
}

sub remove_deri{
my($in) = @_;

my($ans) = "";

@in = split(/\//,$in);
foreach $in (@in){
  if($in =~ /<level:[1234]>/) { $ans .= "/".$in;}
  elsif(($in =~ /<level:0>/) && ($in !~ /<kqw_prawyayaH:Sawq>/)){ 
     $in =~ s/.*<level:0><kqw_pratipadika:([^>]+)>/$1/;
     $ans .= "/".$in;
  }
}
$ans =~ s/^\///;
$ans;
}
