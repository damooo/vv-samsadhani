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

package main;
use CGI qw/:standard/;
use lib "SCLINSTALLDIR";
use SCLResultParser;

my $myPATH = "SCLINSTALLDIR/skt_gen/noun";
    if (! (-e "TFPATH")){
        mkdir "TFPATH" or die "Error creating directory TFPATH";
    }

    open(TMP1,">>TFPATH/noun.log") || die "Can't open TFPATH/noun.log for writing";
      if (param) {
        $encoding=param("encoding");
        $genencoding=param("genencoding");
        $genencoding = $encoding unless $genencoding;
        $rt=param("rt");
        $gen=param("gen");
        $level=param("level");
        $json_out=param("json_out");

        print TMP1 "running:","calling gen_noun.pl from noun generator\n";
        print TMP1
        $ENV{'REMOTE_ADDR'}."\t".$ENV{'HTTP_USER_AGENT'}."\n"."rt:$rt\t"."gen:$gen\t"."encoding:$encoding\t"."genencoding=$genencoding\n##########################\n\n";

        my $cgi = new CGI;
        my $out_format = ($json_out && ($json_out ne 'false')) ? "json" : "html";

        $ans = `$myPATH/gen_noun.pl $rt $gen $encoding $genencoding $level LOCAL $out_format`;

        if ($out_format eq 'json') {
            print $cgi->header (-charset => 'UTF-8', -type => 'application/json');
            my $alltables = html_tables($ans); 
            my $vibhaktis = table_filter($alltables->[0]->{"data"}, 1, 1);
            print to_json($vibhaktis);
            foreach my $r (@$vibhaktis) {
                print TMP1 join("\t", @$r) . "\n";
            }
        }
        else {
        print $cgi->header (-charset => 'UTF-8');

        print "<head>\n";
        print "<script type=\"text/javascript\">\n";
        print "function show(word){\n";
        print "window.open('/cgi-bin/scl/SHMT/options1.cgi?word='+word+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no, status=yes').focus();\n }\n </script>";

        print "</head>\n";

        print "<body onload=\"register_keys()\"> <script src=\"/scl/SHMT/wz_tooltip.js\" type=\"text/javascript\"></script>\n";
        print $ans;
        }
      }
      close(TMP1);
