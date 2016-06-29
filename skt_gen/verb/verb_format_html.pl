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


@lakAra = ("लट्","लिट्","लुट्","लृट्","लोट्","लङ्","विधिलिङ्","आशीर्लिङ्","लुङ्","लृङ्");
@person = ("प्रथमपुरुषः","मध्यमपुरुषः","उत्तमपुरुषः");
$line_no = 0;
$lakAra_no = 0;
while($in = <STDIN>){
  chomp($in);
 #if($in && ($in !~ /\?/))
if($in){
  if($in=~/\?/){
         $in =~ s/\?+/-/g;
  }
  if($line_no == 0) {
	print "<center>\n";
     print "<table border=0 width=50%>\n";
     print "<tr><td colspan=4 align=\"center\"><font color=\"brown\" size=\"5\"><b>$lakAra[$lakAra_no]</b></font></td></tr>\n";
     print "<tr  bgcolor='tan'><td></td><td align=\"center\"><font color=\"white\" size=\"4\">एकवचनम्</font></td><td align=\"center\"><font color=\"white\" size=\"4\">द्विवचनम्</font></td><td align=\"center\"><font color=\"white\" size=\"4\">बहुवचनम्</font></td></tr>\n";
  }
  $in =~ s/[ \t][ \t]*/ /g;
  if($in eq "") { $in = "-\t-\t-";}
  @in = split(/ /,$in);
  if($in[0] eq "") { $in[0] = "-";}
  if($in[1] eq "") { $in[1] = "-";}
  if($in[2] eq "") { $in[2] = "-";}
  print "<tr><td width=20% bgcolor='#461B7E'  align='middle'><font color=\"white\" size=\"4\">$person[$line_no]</font></td><td width=27% align=\"center\" bgcolor='#E6CCFF'><font color=\"black\" size=\"4\"> $in[0]</font> </td><td width=27% align=\"center\" bgcolor='#E6CCFF'><font color=\"black\" size=\"4\">$in[1]</font></td><td width=27% align=\"center\" bgcolor='#E6CCFF'><font color=\"black\" size=\"4\">$in[2]</font></td></tr>\n";
	if($line_no == 2) {
           print "</table>\n";
	   print "</center>\n";
        }
  $line_no++;
  if($line_no == 3) {$line_no = 0; $lakAra_no++;}
 }
}
