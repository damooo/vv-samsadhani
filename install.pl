#!/usr/bin/perl -w

my $cmdname = $0;
$cmdname =~ s/^.*\///;
if ($#ARGV >= 0 && $ARGV[0] eq "-f") {
    docmd("rm -rf build");
}
my $builddir = "build";
my $installdir = $builddir;
$installdir =~ s/build/install/;

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
    docmd("perl -i -p -e \"s#SCLINSTALLDIR=.*#SCLINSTALLDIR=$installdir#;\" $builddir/spec.txt")
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
