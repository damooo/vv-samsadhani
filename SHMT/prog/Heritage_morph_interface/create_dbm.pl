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
tie(%LEX,GDBM_File,$ARGV[0],GDBM_WRCREAT,0644)|| die "Can't open $ARGV[0] for writing";

while($in = <STDIN>) {
chomp($in);
if($in !~ /^#/) {
 @flds = split(/\t/,$in);
 $flds[3] =~ s/\(gana diff\)//;
 if($flds[3] =~ /\(/) { 
    $flds[3] =~ /(^.*)\((.*)\)/; 
    $one = $1; 
    $two = $2;
    if($two =~ / /) { $two = "";}
    $one =~ s/#//;
    $two =~ s/#//;
 }
 else { $one = $flds[3]; $one =~ s/#//; $two = "";}
 if($one ne "-") {
 # $key =$one."_".$flds[2]; #Earlier I took both the rt as well as gana.
 # But I noticed that the ganas of GH do not match with the Ganas of our dhatupatha.
 # e.g. for paS, GH's morph produces xivAxi gaNa, while xqS is in BvAxi gaNa.
 #Instead now gaNa is produced as a value.
  $key =$one;
  $value = $flds[0]."_".$flds[1]."_".$flds[2];
  $LEX{$key} = $value;
 }
 if($two) {
 #$key =$two."_".$flds[2];
 $key =$two;
 $value = $flds[0]."_".$flds[1]."_".$flds[2];
 $LEX{$key} = $value;
 }
}
}
untie(%LEX);
