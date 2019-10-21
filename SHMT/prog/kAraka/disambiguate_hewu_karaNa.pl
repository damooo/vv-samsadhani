#!/usr/bin/env perl

#  Copyright (C) 2010-2019 Amba Kulkarni (ambapradeep@gmail.com)
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

#BEGIN{require "$ARGV[0]/paths.pl";}

#use lib $GlblVar::LIB_PERL_PATH;

#use GDBM_File;

#tie(%amUrwa,GDBM_File,"$ARGV[1]/amUrwa.dbm",GDBM_READER,0644) || die "Can't open $ARGV[1]/amUrwa.dbm for reading";

open(TMP,"$ARGV[1]/amUrwa.txt") || die "Can't open $ARGV[1]/amUrwa.txt for reading";
while(<TMP>) {
chomp;
$key = $_;
$amUrwa{$key}=1;
}
close(TMP);

$/ = "\n\n";
while($in = <STDIN>){

   @in = split(/\n/,$in);
   for($i=0;$i<=$#in;$i++){
      if($in[$i] =~ /karaNa,/) {
          $rt = &get_rt_lifga($in[$i]);
#         print STDERR "rt = $rt\n";
         if($amUrwa{$rt}) {
#         print STDERR "amUrwa = $rt\n";
            $in[$i] =~ s/\tkaraNa,/\thewu,/;
         }
      }
   }
   for($i=0;$i<=$#in;$i++){
      print $in[$i],"\n";
   }
   print "\n";
}

sub get_rt_lifga {
  my($in) = @_;
  my($rt) = "";
  @flds = split(/\t/,$in);
  $flds[7] =~ /^([^<]+).*<lifgam:([^>]+)/;
  $rt = $1.",".$2;
$rt;
}
1;
