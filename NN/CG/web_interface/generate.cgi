#!GraphvizDot/perl -I LIB_PERL_PATH/

#  Copyright (C) 2013-2016 Amba Kulkarni (ambapradeep@gmail.com)
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

my $tmp_path="TFPATH/NN/CG";
my $converters_path="SCLINSTALLDIR/converters";
my $NNCG_path="SCLINSTALLDIR/NN/CG";
my $CG_htdocspath="SCLURL/NN/CG";

      my $cgi = new CGI;
      print $cgi->header (-charset => 'UTF-8');
    #  print "<span><font size=\"3px\"><p><b>Instructions:</b> </font></span><br />
#	<span>In Conceptual Graph, 'Relations' are in oval shaped nodes and 'Concepts' are in Rectangle shaped nodes. </span><br/>
#	<span>In Compressed Conceptual Graph, 'Concepts' are in Rectangle shaped nodes and 'relations' viewed through arrows. </span><br/>
#        <span>If the relation between the concepts is not mentioned explicitly, by default a relation \"R\"is introduced in between them.</span>
#        ";
#        print "</center><br>";

      if (param) {
        $nne=param("nne");
        $type=param("type");
        $pid = $$;

        system("mkdir -p $tmp_path/tmp_in$pid");
	
	open(TMP,">$tmp_path/tmp_in$pid/in.txt") || die "Can't open $tmp_path/tmp_in$pid/in.txt for writing";
        print TMP $nne,"\n";
        close(TMP);
        system("$converters_path/utf82wx.sh < $tmp_path/tmp_in$pid/in.txt | $NNCG_path/nne2diagram.out $type | $converters_path/wx2utf8.sh | GraphvizDot/dot -Tjpg > $tmp_path/tmp_in$pid/a.jpg");
        $nne =~ s/</\&lt;/g;
        $nne =~ s/>/\&gt;/g;

        print "<center><br>";
        print "$nne<br><br><br>";
        print "<img src=\"$CG_htdocspath/DOT/tmp_in$pid/a.jpg\">\n";
        print "<br>";
   #     print "<a href=\"SCLURL/NN/segmenter/index.html\"> Try Another<\/a>";
      }
