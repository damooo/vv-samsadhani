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

require "SCLINSTALLDIR/SHMT/prog/interface/modify_mo_fn.pl";

$| = 1;
while($in = <STDIN>){
chomp $in;

if($in =~ /./) {
 while($in =~ /([a-zA-Z]+)<vargaH:sa\-pU\-pa><lifgam:(napuM|puM|swrI)><level:0>/) {
  $in =~ s/\-([a-zA-Z]+<vargaH:sa\-pU\-pa><lifgam:[^>]+><level:0>\/)*([a-zA-Z]+)<vargaH:sa\-pU\-pa><lifgam:[^>]+><level:0>\$/-$2/g;
  $in =~ s/\t([a-zA-Z]+<vargaH:sa\-pU\-pa><lifgam:[^>]+><level:0>\/)*([a-zA-Z]+)<vargaH:sa\-pU\-pa><lifgam:[^>]+><level:0>\$/\t$2/g;
  $in =~ s/\-([a-zA-Z]+<vargaH:sa\-pU\-pa><lifgam:[^>]+><level:0>\/)*([a-zA-Z]+)<vargaH:sa\-pU\-pa><lifgam:[^>]+><level:0>/-$2/g;
  $in =~ s/\t([a-zA-Z]+<vargaH:sa\-pU\-pa><lifgam:[^>]+><level:0>\/)*([a-zA-Z]+)<vargaH:sa\-pU\-pa><lifgam:[^>]+><level:0>/\t$2/g;
  print "in = $in\n";
 }

@in = split(/\t/,$in);

 for($i=0;$i<=4;$i++){
 print $in[$i],"\t";
 }
 $in = &modify_mo($in[5]);
 $in =~ s/<level:[0-4]>//g;
 $in =~ s/<XAwuH:([^>]+)>/ $1/g;
 $in =~ s/<gaNaH:([^>]+)>/ $1/g;
 $in =~ s/<upapaxa_cp:([^>]+)>/ $1/g;
 print $in,"\t";
 $in = &modify_mo($in[6]);
 $in =~ s/<level:[0-4]>//g;
 $in =~ s/<XAwuH:([^>]+)>/ $1/g;
 $in =~ s/<gaNaH:([^>]+)>/ $1/g;
 $in =~ s/<upapaxa_cp:([^>]+)>/ $1/g;
 print $in,"\t";
 $in = &modify_mo($in[7]);
 $in =~ s/<level:[0-4]>//g;
 $in =~ s/<XAwu:([^>]+)>/ $1/g;
 $in =~ s/<gaNaH:([^>]+)>/ $1/g;
 $in =~ s/<upapaxa_cp:([^>]+)>/ $1/g;
 print $in,"\t";
 $in = &modify_mo($in[8]);
 $in =~ s/<level:[0-4]>//g;
 $in =~ s/<XAwuH:([^>]+)>/ $1/g;
 $in =~ s/<gaNaH:([^>]+)>/ $1/g;
 $in =~ s/<upapaxa_cp:([^>]+)>/ $1/g;
 print $in,"\t";
 print $in[9],"\t";
 print $in[10],"\t";
 $in = &modify_mo($in[11]);
 $in =~ s/<rt:([^>]+)>/$1/g;
 $in =~ s/<level:[0-4]>//g;
 $in =~ s/<XAwuH:([^>]+)>/ $1/g;
 $in =~ s/<gaNaH:([^>]+)>/ $1/g;
 $in =~ s/<upapaxa_cp:([^>]+)>/ $1/g;
 print $in,"\t";
 print $in[12],"\t";
 print $in[13],"\t";
 $in = &modify_mo($in[14]);
 $in =~ s/<level:[0-4]>//g;
 $in =~ s/<XAwuH:([^>]+)>/ $1/g;
 $in =~ s/<gaNaH:([^>]+)>/ $1/g;
 $in =~ s/<upapaxa_cp:([^>]+)>/ $1/g;
 print $in;
 for($i=15;$i<=$#in;$i++){
  print "\t",$in[$i];
 }
}
 print "\n";
}
