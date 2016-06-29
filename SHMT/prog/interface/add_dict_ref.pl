#!PERLPATH

$outscript = $ARGV[0];
$add_ref = 0;
while($in = <STDIN>){
if($in =~ /tr class="row[35]"/) { $add_ref=1;}
if(($in =~ /(.*<td class=[^>]+>[ ]*)(.*)(<\/td>.*)/) && ($add_ref)) {
 $left = $1;
 $middle = $2;
 $right = $3;

 $middle =~ s/^([^\- ]+)/<a href="javascript:show('$1','$outscript')">$1<AAA>/;
 $middle =~ s/\/([^\- ]+)/\/<a href="javascript:show('$1','$outscript')">$1<AAA>/g;
 $middle =~ s/\-([^\- ]+)/-<a href="javascript:show('$1','$outscript')">$1<AAA>/g;
 $middle =~ s/<AAA>/<\/a>/g;
 print $left,$middle,$right,"\n";
 $add_ref = 0;
 } else {
 print $in;
 }
}
