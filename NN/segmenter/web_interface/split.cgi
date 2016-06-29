#!PERLPATH -I LIB_PERL_PATH/

#  Copyright (C) 2014-2016 Amba Kulkarni (ambapradeep@gmail.com)
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
use warnings;
use CGI qw( :standard );

my $myPATH="SCLINSTALLDIR";
require "$myPATH/converters/convert.pl";
require "$myPATH/NN/segmenter/style.pl";

system("mkdir -p TFPATH");

      my $cgi = new CGI;
      print $cgi->header (-charset => 'UTF-8');

      print $style_header;
      print $title;

      if (param) {
        $textwx=param("nne");

        $text = `echo $textwx | $myPATH/converters/wx2utf8.sh`;

        print "<center>";
        $output = `$myPATH/NN/segmenter/start_server.sh; echo $textwx | $myPATH/NN/segmenter/split_samAsa_greedy.pl | $myPATH/converters/wx2utf8.sh | $myPATH/NN/segmenter/format.pl`;

       print "<font color=\"red\">$text</font>";
       print "$output";
       print "</center>";

print "
<div class=\"tail\"> &nbsp; </div>
<div id=\"copyright-lb\">
<table>
<tr>
<td id=\"copy-verify\">
<p>
    <a href=\"http://validator.w3.org/check?uri=referer\"><img
        src=\"DEPTURL/scl/imgs/w3c.jpg\"
        alt=\"Valid XHTML 1.0 Transitional\" height=\"31\" width=\"\" style=\"border-style:none;\" /></a>
  </p>
</td>
<td id=\"copy-info\">
<center>
<p> <span class=\"cons\">© 2012-15 <a href=\"DEPTURL/faculty/amba\">Arjuna S.R. &amp;Amba Kulkarni</a></span></p>
</center>
</td>
<td>
<center>
<p> <span class=\"cons1\"><a href=\"SCLURL/contributors.html\">Contributors</a></span></p>
</center>
</td>
</tr>
</table>";
      }

print "</div></section></div>
</body></html>";
