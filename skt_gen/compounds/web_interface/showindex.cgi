#!PERLPATH

my $myPATH ="HTDOCSDIR/skt_gen/compounds";

use warnings;
use CGI ':standard';

my $cgi = new CGI;

print $cgi->header(-type    => 'text/html',
                   -charset => 'utf-8');

if (param) {
  my $encoding = param("encoding");
  my $expert = param("expert");

  &display_index($encoding,$expert);

}

sub display_index {
 my ($encoding,$expert) = @_;
    if ($expert eq "No") {
       system ("cat $myPATH/index_dev.html");
    }

    if ($expert eq "Yes") {
       system ("cat $myPATH/expert.html");
    }
}
1;
