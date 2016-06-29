#!PERLPATH

#This program copies all the uttarapadas in one file and non-samaasa and puurvapadas in another file.
#The words are of 4 types
# abcd, -abcd, -abcd-, abcd-
#Of these only -abcd should go to UPADA and all others to NONUPADA

open(STD,">$ARGV[0]") || die "Can't open $ARGV[0] for writing";
open(NONUPADA,">$ARGV[1]") || die "Can't open $ARGV[1] for writing";
open(UPADA,">$ARGV[2]") || die "Can't open $ARGV[2] for writing";

while($in = <STDIN>){
$tmp = $in;
$tmp =~ s/^\-//;
print STD $tmp;
if ($in !~ /\-/) { print NONUPADA $in; print UPADA "\n";} #abcd
elsif ($in =~ /.*\-$/) { print NONUPADA $in; print UPADA "\n";}	#-abcd- & abcd-
else { $in =~ s/^\-//; print UPADA $in; print NONUPADA "\n";} # -abcd
}

close NONUPADA;
close UPADA;
close STD;
