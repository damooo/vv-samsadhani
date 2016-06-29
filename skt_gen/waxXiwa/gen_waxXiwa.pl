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


my $myPATH="SCLINSTALLDIR";
require "$myPATH/converters/convert.pl";

package main;
use CGI qw/:standard/;
#use CGI::Carp qw(fatalsToBrowser);

@avy_waxXiwa_prawyayaH = ("vaw","wasil");
#,"karam","arWam","pUrvaka");
@nA_waxXiwa_prawyayaH = ("mawup","warap","wamap","mayat");
@nA_napuM_waxXiwa_prawyayaH = ("wva");
@nA_swrI_waxXiwa_prawyayaH = ("wal");

@lifga =("puM","swrI","napuM");

print "<script>\n";
print "function generate_waxXiwa_noun_forms(encod,prAwi,lifga,suff){\n";
print "  window.open('CGIURL/skt_gen/waxXiwa/noun_gen.cgi?encoding='+encod+'&rt='+prAwi+'&gen='+lifga+'&suffix='+suff+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();\n";
print "}\n";

print "function generate_kqw_forms(encod,vb){\n";
print "  window.open('CGIURL/skt_gen/kqw/kqw_gen.cgi?encoding='+encod+'&vb='+vb+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();\n";
print "}\n";

print "function generate_waxXiwa_forms(encod,rt,gen){\n";
print "  window.open('CGIURL/skt_gen/waxXiwa/waxXiwa_gen.cgi?encoding='+encod+'&rt='+rt+'&gen='+gen+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();\n";
print "}\n";
print "</script>\n";

$rt = $ARGV[0];
$encoding = $ARGV[1];

$pid = $$;

$rt_wx=&convert($encoding,$rt);
chomp($rt_wx);

$LTPROC_IN = "";
$ltproc_cmd3 = "/usr/bin//lt-proc -c -t $myPATH/morph_bin/skt_taddhita_gen.bin | pr --columns=3 --across --omit-header | $myPATH/converters/ri_skt | $myPATH/converters/iscii2utf8.py 1";
$ltproc_cmd1 = "/usr/bin//lt-proc -c -t $myPATH/morph_bin/skt_taddhita_gen.bin | pr --columns=1 --across --omit-header | $myPATH/converters/ri_skt | $myPATH/converters/iscii2utf8.py 1";

$rtutf8 = `echo $rt_wx | $myPATH/converters/wx2utf8.sh`;

  print "<center>\n";
  print "<a href=\"javascript:show('$rtutf8')\">$rtutf8<\/a>\n";
  print "<\/center>\n";

  for($l=0;$l<4;$l++) {
      for($g=0;$g<3;$g++) {
          $lifga = $lifga[$g];
	  $str = "$rt_wx<vargaH:nA><waxXiwa_prawyayaH:$nA_waxXiwa_prawyayaH[$l]><lifgam:$lifga><level:0>";
          $LTPROC_IN .=  $str."\n";
      } 
   }

   $str1 = "echo '".$LTPROC_IN."' | $ltproc_cmd3 | SCLINSTALLDIR/skt_gen/waxXiwa/waxXiwa_format_html.pl";

  $LTPROC_IN2 = "$rt_wx<vargaH:nA><waxXiwa_prawyayaH:wal><lifgam:swrI><level:0>";
  $LTPROC_IN2 .= "\n$rt_wx<vargaH:nA><waxXiwa_prawyayaH:wva><lifgam:napuM><level:0>";

   $str2 = "echo '".$LTPROC_IN2."' | $ltproc_cmd1 | SCLINSTALLDIR/skt_gen/waxXiwa/waxXiwa_ind_html.pl";

   $LTPROC_IN1 = "";
  for($l=0;$l<2;$l++){
      $str = "$rt_wx<vargaH:avy><waxXiwa_prawyayaH:$avy_waxXiwa_prawyayaH[$l]><level:0>";	  
      $LTPROC_IN1 .=  $str."\n";
  }

   $str3 = "echo '".$LTPROC_IN1."' | $ltproc_cmd1 | SCLINSTALLDIR/skt_gen/waxXiwa/waxXiwa_avy_html.pl";

print "<html><body>\n";
  print "<table border=0 width=100%>\n";
  print "<tr><td width=50%>\n";
  system($str1);
  print "<hr />\n";
  system($str2);
  print "</td>\n";
  print "<td width=50% valign=\"top\">\n";
  system($str3);
  print "</body></html>\n";
