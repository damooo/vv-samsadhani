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

use strict;
use warnings;

require "../paths.pl";

use CGI qw( :standard );

  if($GlblVar::VERSION eq "SERVER"){
    if (! (-e "$GlblVar::TFPATH")){
        mkdir "$GlblVar::TFPATH" or die "Error creating directory $GlblVar::TFPATH";
    }
    open(TMP1,">>$GlblVar::TFPATH/amarakosha.log") || die "Can't open $GlblVar::TFPATH/amarakosha.log for writing";
  }

print CGI::header('-type'=>'text/html', '-expires'=>60*60*24, '-charset' => 'UTF-8');

my $word=param('word');
my $relation=param('relation');
my $encoding=param('encoding');
my $out_encoding=param('out_encoding');

print "<script>\n";
print "function generate_noun_forms(encod,prAwi,lifga){\n";
print "  window.open('/cgi-bin/scl/amarakosha/noun_gen.cgi?encoding='+encod+'&rt='+prAwi+'&gen='+lifga+'&jAwi=nA'+'&level=1'+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();\n";
print "}\n";
print "</script>\n";

  if($GlblVar::VERSION eq "SERVER"){
    print TMP1 $ENV{'REMOTE_ADDR'},"\t",$ENV{'HTTP_USER_AGENT'},"\n";
    print TMP1 "word:$word\tencoding:$encoding\trelation:$relation\tout_encoding:$out_encoding\n###################\n";
    close(TMP1);
  }

my $pid = $$;

my $result = `$GlblVar::SCLINSTALLDIR/amarakosha/callrel.pl $word $relation $encoding $out_encoding $pid`;
print $result;

print "<center><font size=5 color=\"white\">&nbsp;</font></center>";
print "</td></tr></table>";
