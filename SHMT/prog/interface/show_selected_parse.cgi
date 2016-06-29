#!GraphvizDot/perl -I LIB_PERL_PATH/

#  Copyright (C) 2012-2016 Amba Kulkarni (ambapradeep@gmail.com)
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
            $start=param("start");
          }

open(TMP,"<TFPATH/$filename/clips_files/parseop_new.txt") || die "Can't open $filename/clips_files/parseop_new.txt for reading";

$sent_found = 0;
$i=0;
$parse_nos="";
while($in = <TMP>){
  chomp($in);
  if($in =~ /./) {
      if($in =~ /Solution:([0-9]+)/) { $parse_nos .= "#".$1;}
  }
}
close(TMP);

          my $cgi = new CGI;
          print $cgi->header (-charset => 'UTF-8');
          print "<head>\n";
          print "</head>\n<body>";
          print "<div id=\"imgitems\" class=\"parsetrees\">\n<center>\n<ul id=\"trees\">\n";
          $parse_nos =~ s/^#//;
          @parse_nos = split(/#/,$parse_nos);

          foreach $i (@parse_nos) {
            if(-e "HTDOCSDIR/SHMT/DEMO/$filename/${sentnum}.$i.dot") {
              system("GraphvizDot/dot -Tjpg -oTFPATH/$filename/${sentnum}.$i.jpg TFPATH/$filename/${sentnum}.$i.dot");
              #print "<li> <img src=\"CGIURL/SHMT/software/webdot.pl/SCLURL/SHMT/DEMO/$filename/${sentnum}$i.dot.dot.jpg\" width=\"\" height=\"\" kddalt=\"graph from public webdot server\"></li>\n";
              print "<li> <img src=\"SCLURL/SHMT/DEMO/$filename/${sentnum}.$i.jpg\" width=\"\" height=\"\" kddalt=\"graph for parse number $i\"></li>\n";
            }
          }
