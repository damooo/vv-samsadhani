#!PERLPATH

my $myPATH = "SCLINSTALLDIR/skt_gen/compounds";
require "$myPATH/cnvrt2utf.pl";
require "$myPATH/cnvrt2utfr.pl";

use warnings;
use CGI ':standard';

my $cgi = new CGI;

print $cgi->header(-type    => 'text/html',
                   -charset => 'utf-8');

if (param) {
  my $encodingpUrva = param("encodingpUrva");
  my $p1pUrva = param("p1pUrva");
  my $p2pUrva = param("p2pUrva");
  my $samAsaprakArapUrva = param("samAsaprakArapUrva");
  my $samAsAnwapUrva = param("samAsAnwapUrva");
  my $strmodpUrva = param("strmodpUrva");
  my $strunmodpUrva = param("strunmodpUrva");
  my $sUwrastrpUrva = param("sUwrastrpUrva");
  my $dividpUrva = param("dividpUrva");
  my $anspUrva = param("anspUrva");
  
 #print "Within pUrvapaxa.cgi\n";
 #print "samAsAnwa = $samAsAnwapUrva <br />";
  $dividpUrva =~ s/#output//;
  $dividpUrva++;

  if($anspUrva eq "No") { 
     $pUrvapaxastr = $strunmodpUrva;
  } else { 
     $pUrvapaxastr = $strmodpUrva;
  }

  #print "pUrvapaxa str = $pUrvapaxastr";

  my $p1utf = &cnvrt2utf($p1pUrva);
  my $pUrvapaxautf = &cnvrt2utf($pUrvapaxastr);

  if ($encodingpUrva eq "RMN") {
     $p1utfr = &cnvrt2utfr($p1utf);
     $pUrvapaxautfr = &cnvrt2utfr($pUrvapaxastrutf);
     $sUwrastrutf = &cnvrt2utfr($sUwrastrpUrva);
  }

  if ($pUrvapaxastr ne "") {
      if ($encodingpUrva eq "RMN") {
        print "<font color=\"blue\">$p1utfr -&gt; $pUrvapaxautfr</font> <font color=\"red\">$sUwrastrutf</font>";
      } else {
        print "<font color=\"blue\">$p1utf -&gt; $pUrvapaxautf</font> <font color=\"red\">$sUwrastrpUrva</font>";
      }
      $p1pUrva = $pUrvapaxastr;
  }
      $cmd = "$myPATH/uwwarapaxa.out \"$encodingpUrva\" \"$p1pUrva\" \"$p2pUrva\" \"$samAsAnwapUrva\" \"$samAsaprakArapUrva\" $dividpUrva";
      system($cmd);
}
