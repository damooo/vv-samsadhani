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

@lakAra = ("lat","lit","lut","lqt","lot","laf","viXilif","ASIrlif","luf","lqf");
@person = ("pra","ma","u");

 $encoding = $ARGV[0];
 $prygH = $ARGV[1];
 $rt = $ARGV[2];
 $mode = $ARGV[3];

if($mode eq "MODE") { #Better name Non-Daemon
 $generator = "LTPROCBINDIR/lt-proc -ct $myPATH/morph_bin/skt_gen.bin";
} elsif($mode eq "SERVER") { #Better name Daemon
 $generator = "$myPATH/skt_gen/client_gen.sh";
}

$ltproc_cmd = "$generator | grep . | pr --columns=3 --across --omit-header --width=300| $myPATH/converters/ri_skt | $myPATH/converters/iscii2utf8.py 1";

 if($encoding ne "WX"){
   $rt_XAwu_gaNa_mng = &convert($encoding,$rt);
   chomp($rt_XAwu_gaNa_mng);
   $prayogaH = &convert($encoding,$prygH);
   chomp($prayogaH);
 } else { $rt_XAwu_gaNa_mng = $rt; $prayogaH = $prygH;}

   $LTPROC_IN = "";
   $LTPROC_IN1 = "";
   $str = "";
   $str1 = "";

#Since we are using only first 3 fields, $mean is removed.
    ($rt,$XAwu,$gaNa,$mng) = split(/_/,$rt_XAwu_gaNa_mng);
    $rtutf8 = `echo $rt | sed 's/[1-5]//' | $myPATH/converters/wx2utf8.sh`;
 print "<center>\n";
     print "<a href=\"javascript:show('$rtutf8')\">$rtutf8<\/a>\n";
 print "<\/center>\n";

          for($l=0;$l<10;$l++){
            $lakAra = $lakAra[$l];
             for($per=0;$per<3;$per++){
             $person = $person[$per];
               for($num=1;$num<4;$num++){
                    $str = "$rt<prayogaH:$prayogaH><lakAraH:$lakAra><puruRaH:$person><vacanam:$num><paxI:parasmEpaxI><XAwuH:$XAwu><gaNaH:$gaNa><level:1>";
                   $LTPROC_IN .=  $str."\n";
                } # number
            } #person
         } #lakAra

$str = "echo '".$LTPROC_IN."' | $ltproc_cmd | $myPATH/skt_gen/verb/verb_format_html.pl $rtutf8";

       for($l=0;$l<10;$l++){
             $lakAra = $lakAra[$l];
             for($per=0;$per<3;$per++){
                $person = $person[$per];
                for($num=1;$num<4;$num++){
                    $str1 = "$rt<prayogaH:$prayogaH><lakAraH:$lakAra><puruRaH:$person><vacanam:$num><paxI:AwmanepaxI><XAwuH:$XAwu><gaNaH:$gaNa><level:1>";
                   $LTPROC_IN1 .=  $str1."\n";
                } # number
            } #person
         } #lakAra

   $str1 = "echo '".$LTPROC_IN1."' | $ltproc_cmd | $myPATH/skt_gen/verb/verb_format_html.pl $rtutf8";

  print "<body><html>\n";
  print "<table border=0 width=100%>\n";
  print "<tr><td>\n";
  print "<center>\n";
  print "<font color=\"green\" size=\"6\"><b>परस्मैपदी</b></font>\n";
  print "</center></td>\n";

  print "<td>\n";
  print "<center>\n";
  print "<font color=\"green\" size=\"6\"><b>आत्मनेपदी</b></font>\n"; 
  print "</center></td></tr>\n";

  print "<tr><td width=50%>\n"; 
  system($str);
  print "</td>\n";
  print "<td width=50% valign=\"top\">\n"; 
  system($str1);
  print "</td></tr>\n";
  print "</table>\n";
  print "</body></html>\n";
