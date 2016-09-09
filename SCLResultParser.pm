package SCLResultParser;

use HTML::TableExtract;

use strict;
use warnings;

BEGIN {
    require Exporter;

    # set the version for version checking
    our $VERSION     = 1.00;

    # Inherit from Exporter to export functions and variables
    our @ISA         = qw(Exporter);

    # Functions and variables which are exported by default
    our @EXPORT      = qw(html_tables to_json 
        table_filter parse_morph_output parse_verb_gen);

    # Functions and variables which can be optionally exported
    #our @EXPORT_OK   = qw($Var1 %Hashit func3);
}

sub html_tables
{
    my $ans = shift;
    my $skiprows = 0;
    my $skipcols = 0;
    $skiprows = shift if @_;
    $skipcols = shift if @_;

    my $te = HTML::TableExtract->new();
    $te->parse($ans);
    my @tables = ();
    foreach my $ts ($te->tables) {
        #print "Table found at ", join(',', $ts->coords), ":\n";
        my @rows = ();
        my $nrows = 0;
        my @hdr = undef;
        my $ncols = 0;
        foreach my $row ($ts->rows) {
            next unless defined $row;
            #print "row# $n\n";
            my @newrow = map { 
                        if ($_) { s/^[\s\n]*//s; s/[\s\n]*$//s; $_ } 
                        else { "" }
                    } @$row;
            #print "   ". join(',', @newrow) . "\n";
            ++ $nrows;
            $ncols = @newrow if $nrows == 1;
            #print join(" ", @newrow) . "\n";
            push @rows, \@newrow;
        }
        push @tables, { "data" => \@rows,
                        "nrows" => $nrows, 
                        "ncols" => $ncols, };
    }

    return \@tables;
}

sub table_filter
{
    my ($tbl, $skiprows, $skipcols) = @_;
    my @newtbl = ();
    for (my $i = $skiprows; $i <= $#$tbl; ++ $i) {
        my @newr = splice @$tbl[$i], $skipcols;
        push @newtbl, \@newr; 
    }
    return \@newtbl;
}

sub to_json
{
    my $ref = shift;
    my $indent = 0;

    $indent = shift if @_;
    my $indentstr = " " x $indent;

    my $type = ref $ref;
    my $str = "";
    if ($type) {
        my $str = "";
        if ($type eq "HASH") {
            my @elems = map { 
                    my $k = $_;
                    my $v = $$ref{$k};
                    "\"$k\" : " . to_json($v, $indent+4);
                } sort(keys %$ref);
            $str .= "\{\n$indentstr    ";
            $str .= join(",\n$indentstr    ", @elems);
            $str .= "\n$indentstr\}";
        }
        elsif ($type eq "ARRAY") {
            my @elems = map { to_json($_, $indent+4) } @$ref;
            $str .= "\[\n$indentstr    ";
            $str .= join(",\n$indentstr    ", @elems);
            $str .= "\n$indentstr\]";
        }
        return $str;
    }
    else {
        return ($ref =~ /^\d+$/) ? $ref : "\"$ref\"";
    }
}

sub parse_verb_gen 
{
    my ($word, $prayoga, $encoding, $res) = @_;

    my $tables = html_tables($res);

    my @out = ();
    for (my $i = 0; $i < 10; ++ $i) {
        my $t = $tables->[$i]->{'data'};
        my $lakaara = @{$t}[0]->[0];
        shift @$t;
        push @out, { 'lakAra' => $lakaara, 'padI' => 'परस्मैपदी', 'data' => $t };
    }
    for (my $i = 10; $i < 20; ++ $i) {
        my $t = $tables->[$i]->{'data'};
        my $lakaara = @{$t}[0]->[0];
        shift @$t;
        push @out, { 'lakAra' => $lakaara, 'padI' => 'आत्मनेपदी', 'data' => $t };
    }

    return { 'padam' => $word, 'prayoga' => $prayoga, 'encoding' => $encoding,
             'data' => \@out };
}

my @word_properties = (
    ['^(एक|द्वि|बहु)$', 'vachanam'],
    ['^([1-8])$', 'vibhakti'],
    ['^(लट्|लिट्|लुट्|लोट्|लृट्|लङ्|लृङ|लुङ्|लिङ्)$', 'lakAra'],
    ['^(कर्तरि|कर्मणि)$',  'prayoga'],
    ['^(पुं|नपुं|स्त्री)$', 'liNGga'],
    ['^(अव्य)$', 'avyaya', 1],
    ['^(प्र|उ|म)$', 'puruSha'],
    ['^(आत्मनेपती|परस्मैपदी|उभयपदी)$', 'padI'],
    ['^(.*)$', 'pratyaya'],
);

sub parse_morph_result
{
    my $ans = shift;

    $ans =~ s/</{/g;
    $ans =~ s/>/}/g;
    $ans =~ s/{वर्गः:ना}//g;
    $ans =~ s/\$//g;

    my %word = ();

    $ans =~ s/:/ /g;
    if($ans =~ s/{धातुः ([^}]+)}//) { 
        $word{'dhAtu'} = $1;
    }
    if($ans =~ s/{गणः ([^}]+)}//) { 
        $word{'gaNa'} = $1;
    }

    my $level = "";
    #print "$ans\n";
    if ($ans =~ /^[^\{]+\{लेवेल् ([0-9])\}/) {
        $level = $1;
        #print "level is $level\n";
        if ($level == 4) {
            $ans =~ s/^[^\{]+\{लेवेल् 4\}//;
        }
        elsif ($level == 2) {
            $word{'type'} = 'krdanta';
        }
        elsif ($level == 3) {
            $word{'type'} = 'taddhita';
        }
        $ans =~ s/\{लेवेल् \d\}//;
    }
    $word{'level'} = $level;
    $ans =~ s/^([^ ]+) //;
    $word{'prAtipadikam'} = $1;

    my @attrs = split(/\s+/, $ans);
    foreach my $a (@attrs) {
        #print "attr = $a\n";
        foreach my $p (@word_properties) {
            my ($pat, $propname, $val) = @$p;
            if ($a =~ /$pat/) {
                my $match = $1;
                $word{$propname} = defined($val) ? $val : $match;
                last;
            }
        }
    }
    return \%word;
}

sub parse_morph_output
{
    my ($word, $encoding, $ans) = @_;

    chomp($ans);

    my $result = { "padam" => "$word", "encoding" => "$encoding", 
                        "_output" => "$ans" };
    my @analysis = ();

    if($ans ne "") {
        my @ans=split(/\//,$ans);
        foreach $ans (@ans) {
            push @analysis, parse_morph_result($ans);
        } # endof foreach
    }
    $result->{'analysis'} = \@analysis;

    return $result;
}
