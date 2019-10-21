#!/usr/bin/env perl

my $cmdname = $0;
$cmdname =~ s/^.*\///;
$installdir = "scl";
        #docmd("sudo apt-get update");
docmd("sudo apt-get install -y make g++ openjdk-8-jdk apache2 graphviz flex bison git")
    || die "Error installing prerequisite packages.\n";
docmd("sudo apt-get install -y flex ocaml camlp4-extra lttoolbox")
    || die "Error installing prerequisite packages.\n";
docmd("sudo a2enmod cgi && sudo service apache2 restart")
    || die "Error installing Apache2 CGI support.\n";
#docmd("sudo cpan HTML::TableExtract")
    #|| die "Error installing Perl HTML::TableExtract module.\n";
if (-d "Zen") {
    docmd("(cd Zen && git pull && cd ML && make)");
}
else {
    docmd("git clone https://gitlab.inria.fr/huet/Zen.git");
    docmd("(cd Zen/ML && make)");
}

$mydir = $ENV{'PWD'};
$installdir = "$mydir";
$zendir = "$mydir/Zen";
docmd("mkdir -p $installdir");

unless (-f "spec.txt") {
    docmd("cp -a SPEC/spec_users.txt spec.txt");
    docmd("perl -i -p -e \"s#SCLINSTALLDIR=.*#SCLINSTALLDIR=$installdir#; s#ZENDIR=.*#ZENDIR=$zendir/ML#\" spec.txt")
}

docmd("(./configure && make && sudo make install)");
exit 0;

sub docmd
{
    my $cmd = shift;
    print STDERR $cmd . "\n";
    my $err = 1;
    $err = (system($cmd) == 0);
    if (! $err) {
        print STDERR "failed\n";
    }
    return $err;
}
