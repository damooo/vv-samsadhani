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

  $ltproc_cmd = "LTPROCBINDIR/lt-proc -ct $myPATH/morph_bin/kqw_lyap_gen.bin | pr --columns=3 --across --omit-header | $myPATH/converters/ri_skt | $myPATH/converters/iscii2utf8.py 1";
  $ltproc_cmd1 = "LTPROCBINDIR/lt-proc -ct $myPATH/morph_bin/kqw_lyap_gen.bin | $myPATH/converters/ri_skt | $myPATH/converters/iscii2utf8.py 1";

package main;
use CGI qw/:standard/;
#use CGI::Carp qw(fatalsToBrowser);
print "<script>\n";
print "function generate_noun_forms(encod,prAwi,lifga,level){\n";
print "  window.open('CGIURL/skt_gen/noun/noun_gen.cgi?encoding='+encod+'&rt='+prAwi+'&gen='+lifga+'&level='+level+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();\n";
print "}\n";

print "function generate_kqw_forms(encod,vb){\n";
print "  window.open('CGIURL/skt_gen/kqw/kqw_gen.cgi?encoding='+encod+'&vb='+vb+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();\n";
print "}\n";

print "function generate_waxXiwa_forms(encod,rt,gen){\n";
print "  window.open('CGIURL/skt_gen/waxXiwa/waxXiwa_gen.cgi?encoding='+encod+'&rt='+rt+'&gen='+gen+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();\n";
print "}\n";
print "</script>\n";

@kqw_prawyayaH = ("wqc","wavyaw","yak","Sawq_lat","SAnac_lat","GaF","Nvul","Nyaw","lyut","yaw","kwa","kwavawu","anIyar");
@kqw_avy_prawyayaH = ("wumun","Namul","kwvA");
@lifga =("puM","swrI","napuM");

$LTPROC_IN = "";

   my $encoding = $ARGV[0];
   my $rt = $ARGV[1];
   $pid = $$;

   if($encoding ne "WX") {
     $rt_XAwu_gaNa = &convert("Unicode",$rt);
   } else { $rt_XAwu_gaNa = $rt;}
   chomp($rt_XAwu_gaNa);

    ($rt,$XAwu,$gaNa,$mean) = split(/_/,$rt_XAwu_gaNa);

    for($l=0;$l<13;$l++) {
       for($g=0;$g<3;$g++) {
           $lifga = $lifga[$g];
	   $str = "$rt<lifgam:$lifga><kqw_prawyayaH:$kqw_prawyayaH[$l]><XAwuH:$XAwu><gaNaH:$gaNa><level:0>"; 
           $LTPROC_IN .=  $str."\n"; 
       }         
    }
   $rtutf8 = `echo $rt | sed 's/[1-5]//' |$myPATH/converters/wx2utf8.sh`;
   print "<center>\n";
   print "<a href=\"javascript:show('$rtutf8')\">$rtutf8<\/a>\n";
   print "<\/center>\n";
   $str = "echo '".$LTPROC_IN."' | $ltproc_cmd | $myPATH/skt_gen/kqw/kqw_format_html.pl";

   $LTPROC_IN1 = "";
   for($l=0;$l<3;$l++){
      $str1 = "$rt<vargaH:avy><kqw_prawyayaH:$kqw_avy_prawyayaH[$l]><XAwuH:$XAwu><gaNaH:$gaNa><level:0>";	  
      $LTPROC_IN1 .=  $str1."\n";
  }

   $str1 = "echo '".$LTPROC_IN1."' | $ltproc_cmd1 | $myPATH/skt_gen/kqw/kqw_avy_html.pl";
  print "<html><body>\n";
  print "<table border=0 width=100%>\n";
  print "<tr><td width=50%>\n";
  system($str);
  print "</td>\n";
  print "<td width=50% valign=\"top\">\n";
  system($str1);
  print "</body></html>\n";
