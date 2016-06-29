#!GraphvizDot/perl -I LIB_PERL_PATH/

#  Copyright (C) 2002-2016 Amba Kulkarni (ambapradeep@gmail.com)
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
#use CGI::Carp qw(fatalsToBrowser);

      if (param) {
          $filename=param("filename");
          $sentnum=param("sentnum");
          my $cgi = new CGI;
          print $cgi->header (-charset => 'UTF-8');
	  print "<head>\n";
	  print "</head>\n<body>";
	  print "<div id=\"imgitems\" class=\"parsetrees\">\n<center>\n<ul id=\"trees\">\n"; 
          $filename =~ s/^..//;
          $filename =~ s/\/$//;
          if(-e "HTDOCSDIR/SHMT/DEMO/$filename/$sentnum.dot") {
               system("GraphvizDot/dot -Tjpg -oHTDOCSDIR/SHMT/DEMO/$filename/$sentnum.jpg HTDOCSDIR/SHMT/DEMO/$filename/$sentnum.dot");
               #print "<img src=\"CGIURL/SHMT/software/webdot.pl/SCLURL/SHMT/DEMO/$filename/$sentnum.dot.dot.jpg\" width=\"\" height=\"\" kddalt=\"graph from public webdot server\"></li>\n";
               print "<img src=\"SCLURL/SHMT/DEMO/$filename/$sentnum.jpg\" width=\"\" height=\"\" kddalt=\"graph showing all relations\"></li>\n";
              }
           print "</ul> </center> </div> </body> </html>\n";
      }
