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

package main;
use CGI qw/:standard/;
use lib "/home/samskritam/scl";
use SCLResultParser;

$sclinstalldir = "/home/samskritam/scl";
$tfpath = "/tmp/SKT_TEMP";

    if (! (-e "$tfpath")){
        mkdir "$tfpath" or die "Error creating directory $tfpath";
    }
    open(TMP1,">>$tfpath/verb.log") || die "Can't open $tfpath/verb.log for writing";
    if (param) {

      $word=param("vb");
      $prayoga=param("prayoga");
      $encoding=param("encoding");
      $json_out=param("json_out");

      my $result = `/home/samskritam/scl/build/skt_gen/verb/gen_verb.pl $encoding $prayoga $word LOCAL`;

      my $cgi = new CGI;
      print $cgi->header (-charset => 'UTF-8');

    if ($json_out && ($json_out ne 'false')) {
        $res = parse_verb_gen($word, $prayoga, $encoding, $result);
        print "<pre>" . to_json($res) . "</pre>";
    }
    else {
      print "<head>\n";
      print "<script type=\"text/javascript\">\n";
      print "function show(word){\n";
      print "window.open('/cgi-bin/scl/SHMT/options1.cgi?word='+word+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no, status=yes');\n }\n </script>";

 print "</head>\n";
      print "<body onload=\"register_keys()\"> <script src=\"/html/scl/SHMT/wz_tooltip.js\" type=\"text/javascript\"></script>\n";

      print $result;
      print TMP1 "running:","calling gen_verb.pl from noun generator";
      print TMP1 $ENV{'REMOTE_ADDR'}."\t".$ENV{'HTTP_USER_AGENT'}."\n"."word:$word\t"."prayoga:$prayoga\n#######################\n\n";
      }
    }
      close(TMP1);
