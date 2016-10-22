#!/usr/bin/perl

my %dhaatu_table = ();
unless ($#ARGV >= 0) {
    die "Usage: $0 (-csv|-html|-json)";
}
my $format = shift @ARGV;
$format =~ s/^-//;
if ($format =~ m/html/i) {
    exit(0);
}
elsif ($format =~ m/csv/i) {
    print "#root,dhatu,gana,meanings\n";
}
elsif ($format =~ m/json/i) {
}
while(<STDIN>) {
    chop;
    #next if /^#/;
    my @comps = split /_/;
    my $rt = shift @comps;
    my $dhaatu = shift @comps;
    my $gana = shift @comps;
    my $meanings = join(' ', @comps);

    if (defined $dhaatu_table{$rt}) {
        print STDERR "duplicate $rt; skipping.\n";
    }
    else {
        $dhaatu_table[$rt] = [$rt, $dhaatu, $gana, $meanings];
    }
    my $e = $dhaatu_table[$rt];
    if ($format eq 'csv') {
        print join(',', @$e) . "\n";
    }
}
