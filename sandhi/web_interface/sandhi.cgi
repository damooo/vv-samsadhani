#!PERLPATH -I LIB_PERL_PATH/

my $myPATH="SCLINSTALLDIR";

require "$myPATH/converters/convert.pl";
require "$myPATH/sandhi/sandhi.pl";
require "$myPATH/sandhi/apavAxa_any.pl";
require "$myPATH/sandhi/any_sandhi.pl";

package main;

    if (! (-e "TFPATH")){
        mkdir "TFPATH" or die "Error creating directory TFPATH";
    }

open(TMP1,">>TFPATH/sandhi.log") || die "Can't open TFPATH/sandhi.log for writing";

use CGI qw/:standard/;
#use CGI::Carp qw(fatalsToBrowser);

  if (param) {
     $encoding=param("encoding");
     $word1=param("text");
     $word2=param("text1");
     $word1 =~ s/\r//g;
     $word2 =~ s/\r//g;
     chomp($word1);
     chomp($word2);
     $sandhi_type = "any";

      $word1_wx=&convert($encoding,$word1);
      chomp($word1_wx);

      $word2_wx=&convert($encoding,$word2);
      chomp($word2_wx);
      
      $ans = &sandhi($word1_wx,$word2_wx);
      @ans=split(/,/,$ans);

       $string = $word1_wx.",".$word2_wx.",".$ans[0].",".$ans[1].",".$ans[2].",".$ans[3].",".$ans[4].",".$ans[5].",".$ans[6].",".$ans[7].",";

      $cmd = "echo \"$string\" | $myPATH/converters/ri_skt | $myPATH/converters/iscii2utf8.py 1";
      $san = `$cmd`;
      $san=~s/,:/,/g;

      if($san){ 
            print TMP1 $ENV{'REMOTE_ADDR'}."\t".$ENV{'HTTP_USER_AGENT'}."\n\n"."encoding:$encoding\t"."word1:$word1\t"."word2:$word2###############\n\n"; 
      } else { 
            print TMP1 "error:","$san\n###############\n\n";
      }

      @san=split(/,/,$san);
      @san2=split(/:/,$san[2]);
      @san3=split(/:/,$san[3]);
      @san4=split(/:/,$san[4]);

##using table and giving ouput to the html file

      $cgi = new CGI;
      print $cgi->header (-charset => 'UTF-8');
	
      print "<br>\n<center>";
      print "<table border='1' cellpadding='2' style='border-collapse:collapse' bordercolor='brown' width='92%' id='AoutoNumber1'>";
      
	print "<tr bgcolor=#297e96>";

        for (my $k = 5; $k < 10; $k++) {
	  print "<td><center><font size=4 color=white>$san[$k]</font></center></td>";
        }
	
      for($i=0;$i<=$#san2;$i++){ 
	print "<tr bgcolor='white'><td><center><font color='blue'>$san[0]</font></center></td>";
	print "<td><center><font color='blue'>$san[1]</font></center></td>";
        print "<td><center><font color='blue'>$san2[$i]</font></center></td>";
	print "<td><center><font color='blue'>$san3[$i]</font></center></td>"; 
	print"<td><center><font color='blue'>$san4[$i]</font><center></td></tr>";
      }
 print  "</table>\n</center>\n";
 print  "<br><br>";

print "<br></BODY></HTML>";
}
close (TMP1);
