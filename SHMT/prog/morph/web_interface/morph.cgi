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

use strict;
use warnings;
#use Shell;
use CGI qw( :standard );
#use LWP::Simple qw/!head/;
#$VERSION = "2.0";
use Date::Format;

my $tmppath = "TFPATH";
my $sclpath = "SCLINSTALLDIR";
my $mode = "MODE";
use lib "SCLINSTALLDIR";
use SCLResultParser;
#use Log::Log4perl qw(:easy);
    if (! (-e "TFPATH")){
        mkdir "TFPATH" or die "Error creating directory TFPATH";
    }

open(TMP1,">>TFPATH/morph.log") || die "Can't open TFPATH/morph.log for writing";

#Declaration of all the variables
my $word1;
my $wordutf="";
my $ans="";
my $encoding="";
my $rt;
my $rt_XAwu_gaNa;
my $XAwu;
my $gaNa;
my $lifga;
my $ref;
my $json_out;
my $out_format = "html";

if (param()){ 
    $word1 = param('morfword');
    $encoding=param("encoding");
    my $json_out=param("json_out");
    $out_format = "json" if $json_out && ($json_out ne 'false');
}

$ans = `$sclpath/SHMT/prog/morph/callmorph.pl $word1 $encoding MODE`;

print TMP1 $ENV{'REMOTE_ADDR'}."\t".$ENV{'HTTP_USER_AGENT'}."\n"."encoding:$encoding\t"."morfword:$word1\n"."tempnew_data:$ans\n############################\n\n";
chomp($ans);

if ($out_format eq 'json') {
    print header(-charset => 'UTF-8', -type => 'application/json');

    my $result = parse_morph_output($word1, $encoding, $ans);
    my $result_json = to_json($result);
    print $result_json ."\n";
    exit(0);
}

close(TMP1);

print header(-type=>"text/html" , -charset=>"utf-8");
print "<script>\n";
print "function analyse_noun_forms(encod,word){
  window.open('CGIURL/morph/morph.cgi?encoding='+encod+'&morfword='+word+'','popUpWindow','height=200,width=600,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();}\n";

print "function generate_noun_forms(encod,prAwi,lifga,level){
  window.open('CGIURL/skt_gen/noun/noun_gen.cgi?encoding='+encod+'&rt='+prAwi+'&gen='+lifga+'&level='+level+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();
}\n";

print "function generate_kqw_forms(encod,vb){
  window.open('CGIURL/skt_gen/kqw/kqw_gen.cgi?encoding='+encod+'&vb='+vb+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();
}\n";

print "function generate_waxXiwa_forms(encod,rt,gen){
  window.open('CGIURL/skt_gen/waxXiwa/waxXiwa_gen.cgi?encoding='+encod+'&rt='+rt+'&gen='+gen+'','popUpWindow','height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes').focus();
}\n";

print "</script>\n";
print "<table style=\"border-collapse: collapse;\" bordercolor='brown' valign='middle' bgcolor='#297e96' border='1' cellpadding='2' cellspacing='2' >
<tr>";
$ans =~ s/</{/g;
$ans =~ s/>/}/g;
$ans =~ s/{वर्गः:ना}//g;
$ans =~ s/\$//g;
my @ans=split(/\//,$ans);
my $i = 0;
if($ans ne "") {
 foreach $ans (@ans) {
   $ans =~ s/:/ /g;
   if($ans =~ /^[^{]+{लेवेल् 4}/) { $ans =~ s/^[^{]+{लेवेल् 4}//;}
   $ans =~ s/^([^ ]+) / /;
   $rt = $1;
   if($ans =~ /लेवेल् 2/) { $ans =~ s/लेवेल् 2/कृदन्त/;}
   if($ans =~ /लेवेल् 3/) { $ans =~ s/लेवेल् 3/तद्धित/;}
   if($ans =~ /लेवेल् [01]/) { $ans =~ s/{लेवेल् [01]}//;}

   if($ans =~ /कृत्_प्रत्ययः/ ){
     if($ans =~ /{धातुः ([^}]+)/) { $XAwu = $1;}
     if($ans =~ /{गणः ([^}]+)/) { $gaNa = $1;}
      $rt_XAwu_gaNa = $rt."_".$XAwu."_".$gaNa;
 #   $ref = "<a href=\"CGIURL/skt_gen/kqw/kqw_gen.cgi?encoding=Unicode&vb=$rt_XAwu_gaNa\" target=\"_blank\">$rt</a>";
      if($rt ne $word1) {
         $ref = "<a href=\"javascript:generate_kqw_forms('Unicode','$rt_XAwu_gaNa')\">$rt</a>";
      } else { $ref = $rt;}
      if(($rt ne "") && ($ans ne "")) {
        print "<td bgcolor='lavendar'>",$ref,$ans,"</td>";
      }
    }elsif ($ans =~ /तद्धित_प्रत्यय/){
      if($rt ne $word1) {
       $ref = "<a href=\"javascript:generate_waxXiwa_forms('Unicode','$rt','$lifga')\">$rt</a>";
      } else { $ref = $rt;}
  #  $ref = "<a href=\"CGIURL/skt_gen/waxXiwa/waxXiwa_gen.cgi?encoding=Unicode&rt=$rt&gen=$lifga\" target=\"_blank\">$rt</a>";
       if(($rt ne "") && ($ans ne "")) {
         print "<td bgcolor=''>",$ref,$ans,"</td>";
       }
     } elsif ($ans =~ /(पुं|नपुं|स्त्री)/) {
       $lifga = $1;
       if($ans =~ /कृदन्त|तद्धित/) { 
          if($rt ne $word1) {
             $ref = "<a href=\"javascript:analyse_noun_forms('Unicode','$rt')\">$rt</a>";
          } else { $ref = $rt;}
    # $ref = "<a href=\"CGIURL/morph/morph.cgi?encoding=Unicode&morfword=$rt\">$rt</a>";
       } else {
  #    $ref = "<a href=\"CGIURL/skt_gen/noun/noun_gen.cgi?encoding=Unicode&rt=$rt&gen=$lifga\" target=\"morfoutput\" onclick=\"window.open('CGIURL/skt_gen/noun/noun_gen.cgi?encoding=Unicode&rt=$rt&gen=$lifga')\">$rt</a>";
      if(($rt ne $word1) && ($ans !~ /{धातुः ([^}]+)/) ){
         $ref = "<a href=\"javascript:generate_noun_forms('Unicode','$rt','$lifga','1')\">$rt</a>";
      } else { $ref = $rt;}
       }
       if(($rt ne "") && ($ans ne "")) {
           print "<td bgcolor='skyblue'>",$ref,$ans,"</td>";
       }
     }
     elsif ($ans =~ /(लट्|लिट्|लुट्|लोट्|लृट्|लङ्|लृङ|लुङ्|लिङ्)/) {
        if($ans =~ /{धातुः ([^}]+)/) { $XAwu = $1;}
        if($ans =~ /{गणः ([^}]+)/) { $gaNa = $1;}
        $rt_XAwu_gaNa = $rt."_".$XAwu."_".$gaNa;
    #$ref = "<a href=\"CGIURL/skt_gen/verb/verb_gen.cgi?encoding=Unicode&vb=$rt_XAwu_gaNa&prayoga=कर्तरि\" target=\"_blank\">$rt</a>";
        $ref = $rt; # verb generator needs mng also. Hence temporarily disconnected
        if(($rt ne "") && ($ans ne "")) {
            print "<td bgcolor='pink'>",$ref,$ans,"</td>";
        }
     }
     else {
        if(($rt ne "") && ($ans ne "")) {
            print "<td bgcolor='lightgreen'>",$rt,$ans,"</td>";
        }
     }
 $i++;
 if($i % 6 == 0) { print "</tr><tr>";}
} # endof foreach
} else { print "No answer found\n";}
print "</table>\n";
