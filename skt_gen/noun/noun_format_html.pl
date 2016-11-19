#!PERLPATH

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

my $myPATH = "SCLINSTALLDIR";

@vib = ("प्रथमा","द्वितीया","तृतीया","चतुर्थी","पञ्चमी","षष्ठी","सप्तमी","सं.प्र");
@vib_num = ("praWamA","xviwIyA","wqwIyA","cawurWI","paFcamI","RaRTI","sapwamI","samboXana");

$rt_wx = $ARGV[0];
$linga_wx = $ARGV[1];
$format = ($#ARGV >= 2) ? $ARGV[2] : "html";
if($linga_wx eq "napuM") { $linga_wx = "napuMsaka";} #Idiosynchrasy of java simulator programme 

$rt_linga = `echo $rt_wx '(' $linga_wx ')' | $myPATH/converters/wx2utf8.sh`;
chop($rt_linga);
$linga = `echo $linga_wx | $myPATH/converters/wx2utf8.sh`;
chop($linga);

$rt = `echo $rt_wx | $myPATH/converters/wx2utf8.sh`;
chop($rt);

my @noun_forms = ();
my %dict = (
    'root' => $rt,
    'linga' => $linga,
    'encoding' => 'Unicode',
    'result' => \@noun_forms,
);
while($in = <STDIN>){
    chomp($in);
    $in =~ s/\t[\t]*/\t/g;
    $in =~ s/\?\?*/-/g;
    my @in = split(/\t/,$in);
    if($in[0] eq "") { $in[0] = "-";}
    if($in[1] eq "") { $in[1] = "-";}
    if($in[2] eq "") { $in[2] = "-";}
    push @noun_forms, \@in;

    $line_no++;
}

if ($format eq 'json') {
    print to_json(\%dict) . "\n";
    exit(0);
}

print "<script type=\"text/javascript\" src=\"SCLURL/js_files/jquery.min.js\"></script>";
print "<script type=\"text/javascript\" src=\"SCLURL/js_files/callcgiscripts.js\"></script>";
print "<script type=\"text/javascript\" src=\"SCLURL/js_files/transliteration.js\"></script>";

print "<script src=\"SCLURL/js_files/jquery-ui.js\"></script>";

print "<link rel=\"stylesheet\" href=\"SCLURL/css_files/samsaadhanii.css\"/>";
print "<link rel=\"stylesheet\" href=\"SCLURL/css_files/menu.css\"/>";
print "<link rel=\"stylesheet\" href=\"SCLURL/css_files/sktmt.css\"/>";
print "<br><br>";

my $line_no = 0;
foreach my $rowref (@noun_forms) {
    if($line_no == 0) {
        print "<center>\n";
        print "<a href=\"javascript:show('$rt')\">$rt_linga<\/a>\n";
        print "<table bordercolor=\"blue\" border=0 cellpadding=2 cellspacing=2 width='50%'>\n"; 
        print "<tr bgcolor='tan'><td></td><td align=\"center\"><font color=\"white\" size=\"4\">एकवचनम्</font> </td><td align=\"center\"><font color=\"white\" size=\"4\">द्विवचनम्</font></td><td align=\"center\"><font color=\"white\" size=\"4\">बहुवचनम्</font></td></tr>\n";
    }
    my @in = @$rowref;
    print "<tr><td  width='10%' bgcolor='#461B7E'  align='middle'>\n";
    print "<font color=\"white\" size=\"4\">$vib[$line_no]</font></td><td align=\"center\" bgcolor='#E6CCFF'><font color=\"black\" size=\"4\">\n";
    if($line_no != 7) {
        print "<a href=\"javascript:show_prakriyA('WX','$rt_wx','$vib_num[$line_no]','$linga_wx','ekavacana','$$')\">$in[0]</a></font></td>\n";
    } else {
        print "$in[0]</font></td>\n";
    }
    print "<td align=\"center\" bgcolor='#E6CCFF'>\n";
    print "<font color=\"black\" size=\"4\">\n";
    if($line_no != 7) {
        print "<a href=\"javascript:show_prakriyA('WX','$rt_wx','$vib_num[$line_no]','$linga_wx','xvivacana','$$')\">$in[1]</a></font></td>\n";
    } else {
        print "$in[1]\n";
    }
    print "</font></td>\n";
    print "<td align=\"center\"  bgcolor='#E6CCFF'><font color=\"black\" size=\"4\">\n";
    if($line_no != 7) {
        print "<a href=\"javascript:show_prakriyA('WX','$rt_wx','$vib_num[$line_no]','$linga_wx','bahuvacana','$$')\">$in[2]</a></font></td>\n";
    } else {
        print "$in[2]</font></td>\n";
    }
    print "</tr>\n";
    $line_no++;
}
print "</center>\n";
print "</table>\n";
print "</body></html>\n";
