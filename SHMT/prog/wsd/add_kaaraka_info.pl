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
    ($word,$ana,$kaaraka) = split(/\t/,$in);
    $ana =~ s/</></;
    $ana =~ s/^/<rt:/;
    print "<word:$word>",$ana;
    if($kaaraka) {
       $kaaraka =~ s/^/<rel_nm:/;
       $kaaraka =~ s/;.*//; #Remove the shared kaaraka info
       $kaaraka =~ s/,/><relata_pos:/;
       $kaaraka =~ s/$/>/;
       print $kaaraka;
    }else { print "<rel_nm:><relata_pos:>";}
 }
 print "\n";
}
