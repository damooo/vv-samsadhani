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
use lib "SCLINSTALLDIR";
use SCLResultParser;

my $myPATH="SCLINSTALLDIR";
require "$myPATH/converters/convert.pl";

package main;
use CGI qw/:standard/;

@lakAra = ("lat","lit","lut","lqt","lot","laf","viXilif","ASIrlif","luf","lqf");
@person = ("pra","ma","u");
my @lakAra_utf8 = ("लट्","लिट्","लुट्","लृट्","लोट्","लङ्","विधिलिङ्","आशीर्लिङ्","लुङ्","लृङ्");
my @person_utf8 = ("प्रथमपुरुषः","मध्यमपुरुषः","उत्तमपुरुषः");

 $encoding = $ARGV[0];
 $prygH = $ARGV[1];
 $rt = $ARGV[2];
 $mode = $ARGV[3];
 $format = ($#ARGV >= 4) ? $ARGV[4] : "html";

if($mode eq "LOCAL") { #Better name Non-Daemon
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
    $rtutf8_orig = `echo $rt | $myPATH/converters/wx2utf8.sh`;
    chop($rtutf8);
    chop($rtutf8_orig);

    for($l=0;$l<10;$l++){
        $lakAra = $lakAra[$l];
            for($per=0;$per<3;$per++){
            $person = $person[$per];
            for($num=1;$num<4;$num++){
                my $str = "$rt<prayogaH:$prayogaH><lakAraH:$lakAra><puruRaH:$person><vacanam:$num><paxI:parasmEpaxI><XAwuH:$XAwu><gaNaH:$gaNa><level:1>";
                $LTPROC_IN .=  $str."\n";
            } # number
        } #person
    } #lakAra

    open($fh, "echo '".$LTPROC_IN."' | $ltproc_cmd | ") || 
        die "Cannot open $ltproc_cmd\n";
    my $parasmai_vforms = gen_verb_forms($fh);
    $fh->close();
$str = "echo '".$LTPROC_IN."' | $ltproc_cmd | $myPATH/skt_gen/verb/verb_format_html.pl $rtutf8";

       for($l=0;$l<10;$l++){
             $lakAra = $lakAra[$l];
             for($per=0;$per<3;$per++){
                $person = $person[$per];
                for($num=1;$num<4;$num++){
                    my $str1 = "$rt<prayogaH:$prayogaH><lakAraH:$lakAra><puruRaH:$person><vacanam:$num><paxI:AwmanepaxI><XAwuH:$XAwu><gaNaH:$gaNa><level:1>";
                   $LTPROC_IN1 .=  $str1."\n";
                } # number
            } #person
         } #lakAra

    open($fh, "echo '".$LTPROC_IN1."' | $ltproc_cmd | ");
    my $aatmane_vforms = gen_verb_forms($fh);

if ($format eq 'json') {
    $dhatuutf8 = `echo $XAwu | $myPATH/converters/wx2utf8.sh`;
    chop($dhatuutf8);
    $prayogaHutf8 = `echo $prayogaH | $myPATH/converters/wx2utf8.sh`;
    chop($prayogaHutf8);
    $ganautf8 = `echo $gaNa | $myPATH/converters/wx2utf8.sh`;
    chop($ganautf8);
    $mngutf8 = `echo $mng | $myPATH/converters/wx2utf8.sh`;
    chop($mngutf8);
    my %dict = (
        'root' => $rtutf8_orig,
        'dhatu' => $dhatuutf8,
        'in_encoding' => 'Unicode',
        'out_encoding' => 'Unicode',
        'prayoga' => $prayogaHutf8,
        'gana' => $ganautf8,
        'meaning' => $mngutf8,
        'lakara' => \@lakAra_utf8,
        'purusha' => \@person_utf8,
        'result' => [
            $aatmane_vforms,
            $parasmai_vforms,
        ]
    );
    print to_json(\%dict) . "\n";
    exit(0);
}

print "<center>\n";
print "<a href=\"javascript:show('$rtutf8')\">$rtutf8<\/a>\n";
print "<\/center>\n";
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
gen_verbform_html($parasmai_vforms);
print "</td>\n";
print "<td width=50% valign=\"top\">\n"; 
gen_verbform_html($aatmane_vforms);
print "</td></tr>\n";
print "</table>\n";
print "</body></html>\n";

sub gen_verb_forms
{
    my $fh = shift;

    my @verb_forms = ();

    my $line_no = 0;
    while($in = <$fh>){
        chomp($in);
        next unless $in;

        if($in=~/\?/){
            $in =~ s/\?+/-/g;
        }
        $in =~ s/[ \t][ \t]*/ /g;
        if($in eq "") { $in = "-\t-\t-";}
        my @in = split(/ /,$in);
        if($in[0] eq "") { $in[0] = "-";}
        if($in[1] eq "") { $in[1] = "-";}
        if($in[2] eq "") { $in[2] = "-";}
        if ($line_no == 0) {
            my @lakaara_forms = (); 
            push @verb_forms, \@lakaara_forms;
        }
        push @{$verb_forms[-1]}, \@in;

        $line_no++;
        if($line_no == 3) {
            $line_no = 0; 
        }
    }

    return \@verb_forms;
}

sub gen_verbform_html
{
    my $verbforms_ref = shift;
    my $lakAra_no = 0;
    foreach my $lakara (@$verbforms_ref) {
        print "<center>\n";
        print "<table border=0 width=50%>\n";
        print "    <tr><td colspan=4 align=\"center\"><font color=\"brown\" size=\"5\"><b>$lakAra_utf8[$lakAra_no]</b></font></td></tr>\n";
        print "<tr  bgcolor='tan'><td></td><td align=\"center\"><font color=\"white\" size=\"4\">एकवचनम्</font></td><td align=\"center\"><font color=\"white\" size=\"4\">द्विवचनम्</font></td><td align=\"center\"><font color=\"white\" size=\"4\">बहुवचनम्</font></td></tr>\n";
        my $line_no = 0;
        foreach my $purusha (@$lakara) {
            my @in = @$purusha;
            print "    <tr><td width=20% bgcolor='#461B7E'  align='middle'><font color=\"white\" size=\"4\">$person_utf8[$line_no]</font></td><td width=27% align=\"center\" bgcolor='#E6CCFF'><font color=\"black\" size=\"4\"> $in[0]</font> </td><td width=27% align=\"center\" bgcolor='#E6CCFF'><font color=\"black\" size=\"4\">$in[1]</font></td><td width=27% align=\"center\" bgcolor='#E6CCFF'><font color=\"black\" size=\"4\">$in[2]</font></td></tr>\n";
            ++ $line_no;
        }
        print "</table>\n";
        print "</center>\n";
        ++ $lakAra_no;
    }
}
