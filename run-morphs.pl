#!/usr/bin/perl -w

my $url = "http://localhost/cgi-bin/scl/morph/morph_json.cgi";
my $parms = "?encoding=Itrans&morfword=";


my @words = (
    "rAmAya",
    "gatvA",
    "ramAbhyAm",
    "gachChantI",
    "shrotum",
    "kR^iShNatvam",
    "chorayati",
    "jagAma",
    "pravishya",
    "ArAdhayAmAsa",
    "dadAti",
);
foreach my $w (@words) {
    my $fullurl = "$url$parms$w";

    system("curl \"$fullurl\"")
}
