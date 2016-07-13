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

my $myPATH = "/home/samskritam/scl/build/skt_gen/noun";
    if (! (-e "/tmp/SKT_TEMP")){
        mkdir "/tmp/SKT_TEMP" or die "Error creating directory /tmp/SKT_TEMP";
    }

    open(TMP1,">>/tmp/SKT_TEMP/noun.log") || die "Can't open /tmp/SKT_TEMP/noun.log for writing";
      if (param) {
        $encoding=param("encoding");
        $rt=param("rt");
        $gen=param("gen");
        $level=param("level");
        $json_out=param("json_out");

        my $cgi = new CGI;
        print $cgi->header (-charset => 'UTF-8');

        $ans = `$myPATH/gen_noun.pl $rt $gen $encoding $level LOCAL`;

        if ($json_out && ($json_out ne 'false')) {
            my $alltables = html_tables($ans); 
            my $vibhaktis = $alltables->[0]->{"data"};
            print "<pre>" . to_json($vibhaktis) . "</pre>";
            foreach my $r (@$vibhaktis) {
                print TMP1 join("\t", @$r) . "\n";
            }
        }
        else {

        print "<head>\n";
        print "<script type=\"text/javascript\">\n";
        print "function show(word){\n";
        print "window.open('/cgi-bin/scl/SHMT/options1.cgi?word='+word+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no, status=yes').focus();\n }\n </script>";

        print "</head>\n";

        print "<body onload=\"register_keys()\"> <script src=\"/scl/SHMT/wz_tooltip.js\" type=\"text/javascript\"></script>\n";

        print TMP1 "running:","calling gen_noun.pl from noun generator";
        print TMP1 $ENV{'REMOTE_ADDR'}."\t".$ENV{'HTTP_USER_AGENT'}."\n"."rt:$rt\t"."gen:$gen\t"."encoding:$encoding\n##########################\n\n";
        print $ans;
        }
      }
      close(TMP1);
