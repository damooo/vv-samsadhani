#!/usr/bin/env perl

#  Copyright (C) 2002-2018 Amba Kulkarni (ambapradeep@gmail.com)
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

require "../../paths.pl";

package main;
use CGI qw/:standard/;

my $version = "DEVELOP";

    if (! (-e "$GlblVar::TFPATH")){
        mkdir "$GlblVar::TFPATH" or die "Error creating directory $GlblVar::TFPATH";
    }
  if($version eq "DEVELOP"){
    open(TMP1,">>$GlblVar::TFPATH/waxXiwa.log") || die "Can't open $GlblVar::TFPATH/waxXiwa.log for writing";
  }
      if (param) {
      my $encoding=param("encoding");
      my $word=param("rt");

      my $cgi = new CGI;
      print $cgi->header (-charset => 'UTF-8');
     
      print "<head>\n";
      print "<script type=\"text/javascript\">\n";
      print "function show(word,encod){\n";
      print "window.open('/cgi-bin/scl/SHMT/options1.cgi?word='+word+'&outencoding='+encod+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no, status=yes').focus();\n }\n </script>";

      print "</head>\n";
      print "<body onload=\"register_keys()\"> <script src=\"/scl/SHMT/wz_tooltip.js\" type=\"text/javascript\"></script>\n";

      my $result = `$GlblVar::SCLINSTALLDIR/skt_gen/waxXiwa/gen_waxXiwa.pl $word $encoding`;
      print $result;
      if($version eq "DEVELOP"){
        print TMP1 "running:","calling gen_waxXiwa.pl from waxXiwa generator";
        print TMP1 $ENV{'REMOTE_ADDR'}."\t".$ENV{'HTTP_USER_AGENT'}."\n"."word:$word\t"."encoding:$encoding\n#######################\n\n";
      }
     }

 if($version eq "DEVELOP"){
   close(TMP1);
 }
