#!PERLPATH -I /usr/local/lib/perl/5.18.2/

#  Copyright (C) 2013-2015 Amba Kulkarni (ambapradeep@gmail.com)
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

my $tmp_path="TFPATH/NN/type";
my $converters_path="SCLINSTALLDIR/converters";
my $NNtype_path="SCLINSTALLDIR/NN/Type_identifier";
my $type_htdocspath="SCLURL/NN/Type_identifier";
require "$NNtype_path/style.pl";

      my $cgi = new CGI;
      print $cgi->header (-charset => 'UTF-8');

	print $style_header;
	print $title;

      if (param) {
        $nne=param("nne");
#	$type=param("type");
        $pid = $$;

        system("mkdir -p $tmp_path/tmp_in$pid");
	
	open(TMP,">$tmp_path/tmp_in$pid/in.txt") || die "Can't open $tmp_path/tmp_in$pid/in.txt for writing";
        print TMP $nne,"\n";
        close(TMP);
        system("$converters_path/utf82wx.sh < $tmp_path/tmp_in$pid/in.txt | $NNtype_path/typeidentifier.out $type | $converters_path/wx2utf8.sh");

     print "<center><br>";
     print "<br>";
     print "<a href=\"SCLURL/NN/segmenter/index.html\"> Try Another<\/a>";

     print "<br />";
}
