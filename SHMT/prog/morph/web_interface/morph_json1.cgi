#!/usr/bin/perl -I /usr/lib/perl/5.18.2/

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

use strict;
use warnings;
use CGI qw( :standard );
use Date::Format;

#my $tmppath = "TFPATH";
#my $sclpath = "SCLINSTALLDIR";
#my $mode = "MODE";
use lib "SCLINSTALLDIR";

my $tmppath = "/tmp/SKT_TEMP";
my $sclpath = "/home/samskritam/scl/build";
my $mode = "LOCAL";
use lib "/home/samskritam/scl";
use SCLResultParser;

if (! (-e "$tmppath")){
    mkdir "$tmppath" or die "Error creating directory $tmppath";
}

open(TMP1,">>$tmppath/morph.log") || die "Can't open $tmppath/morph.log for writing";

print header(-type=>"text/html" , -charset=>"utf-8");

#Declaration of all the variables
my $word1;
my $wordutf="";
my $ans="";
my $encoding="";
my $rt;
my $rt_XAwu_gaNa;
my $XAwu;
my $gaNa;
my $lifga;
my $ref;

if (param()){ 
    $word1 = param('morfword');
    $encoding=param("encoding");
}
#binmode STDOUT, ":encode(utf8)";

$ans = `$sclpath/SHMT/prog/morph/callmorph.pl $word1 $encoding $mode`;
#$ans = `SCLINSTALLDIR/SHMT/prog/morph/callmorph.pl $word1 $encoding MODE`;

print TMP1 $ENV{'REMOTE_ADDR'}."\t".$ENV{'HTTP_USER_AGENT'}."\n"."encoding:$encoding\t"."morfword:$word1\n"."output::wordutf:$wordutf\t"."tempnew_data:$ans\n############################\n\n";

chomp($ans);

#print $ans . "\n";
my $result = parse_morph_output($word1, $encoding, $ans);
my $result_json = to_json($result);
#print (utf8::is_utf8($result_json) ? "UTF8" : "OCTETS") . "\n";

print $result_json ."\n";

close(TMP1);
