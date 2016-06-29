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



=head1 lwg.pl

This program does local word grouping. 

=head1 DESCRIPTION

We do the grouping in the following two cases:

a)verb with lat lakaara followed by 'sma'.

b) verb in Sawq foillowed by any form of 'as'.

=head1 EXAMPLES

This is used after the parsing has been done.

Usage:
./lwg.pl < input_file > output_file

=head1 AUTHORS

Amba Kulkarni

ambapradeep@gmail.com

License: GPL

=cut

$/ = "\n\n";

while($in = <STDIN>){

    @in = split(/\n/,$in);
  
    $i = 0;
    while($i <= $#in) {
       @f = split(/\t/,$in[$i]);
       $last[$i] = $f[11];
       @s = split(/\t/,$in[$i+1]);
       $last[$i+1] = $s[11];
       if(($f[11] =~ /<lakAraH:lat>/) &&
          ($s[11] =~ /^sma<word:sma><vargaH:avy><level:1>/)) {
           if ($s[11] =~ /<rel_nm:([^>]+)><relata_pos:([^>]+)>/){
               $rel_nm = $1;
               $relata_pos = $2;
               $last[$i] =~ s/<lakAraH:lat>/<lakAraH:lat_sma>/;
           }
       }
       elsif(($f[11] =~ /<kqw_prawyayaH:Sawq_lat>/) &&
          ($s[11] =~ /^as[123].*<lakAraH:(l[auiq][tf]|ASIrlif)>/)) {
          $f[11] =~ s/<kqw_prawyayaH:Sawq_lat>/<kqw_prawyayaH:Sawq_lat_$1>/;
           if($s[11] =~ /<rel_nm:([^>]+)><relata_pos:([^>]+)>/){
              $rel_nm = $1;
              $relata_pos = $2;
              $last[$i+1] = "-";
           }
       }
       if($last[$i+1] eq "-") {
         $j=0;
         $pos1 = $i+1; #Pos is counted from 1
         $pos = $i+1+1;
         while($j <= $#in) {
           $in[$j] =~ s/<relata_pos:$pos>/<relata_pos:$pos1>/;
           $j++;
        }
         $in[$i] =~ s/<rel_nm:[^>]+><relata_pos:[^>]+>/<rel_nm:$rel_nm><relata_pos:$relata_pos>/;
       }
       $i++;
    }
    $i = 0;
    while($i <= $#in) {
       if($in[$i] !~ /^$/) {
         print $in[$i],"\t",$last[$i],"\n";
         $i++;
       } else { print $in[$i],"\n";}
    }
    print "\n";
}
