#!PERLPATH -I LIB_PERL_PATH/

package main;
use CGI qw/:standard/;

my $cgi = new CGI;
print $cgi->header(-charset => 'UTF-8');

$word = param('word');

print "<html><head>
<script type=\"text/javascript\" src=\"SCLURL/js_files/jquery.tools.min.js\"></script>
<script type=\"text/javascript\" src =\"SCLURL/SHMT/option.js\"></script>
<style type=\"text/css\"> #apte{font:22px bold sans-serif;width:100%;background:#333;color:#fff;}</style>
<style type=\"text/css\"> #mw{font:22px bold sans-serif;width:100%;background:#333;color:#fff;}</style>
<style type=\"text/css\"> #amara{font:22px bold sans-serif;width:100%;background:#333;color:#fff;}</style>
</head><body><div id=\"check\">";
        print "<form name=\"dicthelp\" method=\"post\">\n";
	print "<input type=\"hidden\" name=\"word\" value=\"$word\" id=\"word\"/>\n";
        print "<table cellpadding=\"4\"><tr>\n";
        print "<td>Amarakosha<input type=\"checkbox\" name=\"Amara\" id=\"amara\" value=\"amara\" onclick=\"showcontent(this.value)\"/></td>\n";
        print "<td>Apte-dic<input type=\"checkbox\" onclick=\"showcontent(this.value)\"  name=\"apte\" value=\"apte\" id=\"apte\"/></td>\n";
        print "<td>MW-dic<input type=\"checkbox\" name=\"mw\" id=\"mw\" value=\"mw\" onclick=\"showcontent(this.value)\"/></td>\n";
        print "</tr></table></form>";

	print "<div id=\"result\"></div>";

print "</div></body></html>";
