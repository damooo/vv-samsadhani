#!/usr/bin/perl -w

my $cmdname = $0;
$cmdname =~ s/^.*\///;
my $builddir = "build";
my $installdir = $builddir;
if ($#ARGV >= 0) {
    if ($ARGV[0] eq "-f") {
        docmd("rm -rf $builddir");
    }
    elsif ($ARGV[0] eq "-deps") {
        #docmd("sudo apt-get update");
        docmd("sudo apt-get install make g++ apache2 graphviz flex bison")
            || die "Error installing prerequisite packages.\n";
        docmd("sudo apt-get install ocaml camlp4-extra lttoolbox")
            || die "Error installing prerequisite packages.\n";
        docmd("sudo a2enmod cgi && sudo service apache2 restart")
            || die "Error installing Apache2 CGI support.\n";
        docmd("sudo cpan HTML::TableExtract")
            || die "Error installing Perl HTML::TableExtract module.\n";
        exit(0);
    }
}

# Copy all directory contents other than "omits" into builddir
my @omits = ($builddir, $installdir, "SPEC", $cmdname);
foreach $f (@omits) {
    $omits{$f} = 1;
}
my @contents = map { $omits{$_} ? () : ($_) } glob "*";

# Convert builddir and installdir into absolute paths
$builddir = $ENV{'PWD'} . "/$builddir" unless $builddir =~ /^\//;
$installdir = $ENV{'PWD'} . "/$installdir" unless $installdir =~ /^\//;

docmd("mkdir -p $builddir $installdir");

docmd("rsync -a " . join(' ', @contents) . " $builddir/");
unless (-f "$builddir/spec.txt") {
    docmd("cp -a SPEC/spec_users.txt $builddir/spec.txt");
    docmd("perl -i -p -e \"s#SCLINSTALLDIR=.*#SCLINSTALLDIR=$installdir#; s#SCLURL=.*#SCLURL=/scl#; s#CGIURL=.*#CGIURL=/cgi-bin/scl#;\" $builddir/spec.txt")
}

docmd("(cd $builddir && ./configure && make && sudo make install)");
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
