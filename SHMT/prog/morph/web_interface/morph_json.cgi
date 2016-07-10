#!/usr/bin/perl -I /usr/lib/perl/5.18.2/

#  Copyright (C) 2010-2016 Amba Kulkarni (ambapradeep@gmail.com)
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later
#  version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

use strict;
use warnings;
#use Shell;
use CGI qw( :standard );
#use LWP::Simple qw/!head/;
#$VERSION = "2.0";
use Date::Format;
#use Log::Log4perl qw(:easy);
my $tmppath = "TFPATH";
my $sclpath = "SCLINSTALLDIR";
my $mode = "MODE";
#my $tmppath = "/tmp/SKT_TEMP";
#my $sclpath = "/home/samskritam/scl/build";
#my $mode = "LOCAL";

if (! (-e "$tmppath")){
    mkdir "$tmppath" or die "Error creating directory $tmppath";
}

open(TMP1,">>$tmppath/morph.log") || die "Can't open $tmppath/morph.log for writing";

print header(-type=>"text/json" , -charset=>"utf-8");

#Declaration of all the variables
my $word1;
my $wordutf="";
my $ans="";
my $encoding="";
my $rt;
my $rt_XAwu_gaNa;
my $XAwu;
my $gaNa;
my $lifga;
my $ref;

if (param()){ 
    $word1 = param('morfword');
    $encoding=param("encoding");
}

$ans = `$sclpath/SHMT/prog/morph/callmorph.pl $word1 $encoding $mode`;
#$ans = `SCLINSTALLDIR/SHMT/prog/morph/callmorph.pl $word1 $encoding MODE`;

print TMP1 $ENV{'REMOTE_ADDR'}."\t".$ENV{'HTTP_USER_AGENT'}."\n"."encoding:$encoding\t"."morfword:$word1\n"."output::wordutf:$wordutf\t"."tempnew_data:$ans\n############################\n\n";

chomp($ans);
my @word_properties = (
    ['^(एक|द्वि|बहु)$', 'vachanam'],
    ['^([1-8])$', 'vibhakti'],
    ['^(लट्|लिट्|लुट्|लोट्|लृट्|लङ्|लृङ|लुङ्|लिङ्)$', 'lakAra'],
    ['^(कर्तरि|कर्मणि)$',  'prayoga'],
    ['^(पुं|नपुं|स्त्री)$', 'liNGga'],
    ['^(अव्य)$', 'avayaya', 1],
    ['^(प्र|उ|म)$', 'puruSha'],
    ['^(आत्मनेपती|परस्मैपदी|उभयपदी)$', 'padI'],
    ['^(.*)$', 'pratyaya'],
);

$ans =~ s/</{/g;
$ans =~ s/>/}/g;
$ans =~ s/{वर्गः:ना}//g;
$ans =~ s/\$//g;
my @ans=split(/\//,$ans);
print "{ \"$word1\" : {
      \"output\" : \"$ans\",\n";
my @results = ();
if($ans ne "") {
    foreach $ans (@ans) {
        my %word = ();

        $ans =~ s/[:_]/ /g;
        if($ans =~ s/{धातुः ([^}]+)}//) { 
            $word{'dhAtu'} = $1;
        }
        if($ans =~ s/{गणः ([^}]+)}//) { 
            $word{'gaNa'} = $1;
        }

        my $level = "";
        #print "$ans\n";
        if ($ans =~ /^[^{]+?{लेवेल् ([0-9])}/) {
            $level = $1;
            #print "level is $level\n";
            if ($level == 4) {
                $ans =~ s/^[^{]+{लेवेल् 4}//;
            }
            elsif ($level == 2) {
                $word{'type'} = 'krdanta';
            }
            elsif ($level == 3) {
                $word{'type'} = 'taddhita';
            }
            $ans =~ s/{लेवेल् \d}//;
        }
        $word{'level'} = $level;
        $ans =~ s/^([^ ]+) //;
        $word{'praatipadikam'} = $1;

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
#            if ($a =~ /(पुं|नपुं|स्त्री)/) {
#                $word{'linga'} = $1;
#            }
#            if ($a =~ /(लट्|लिट्|लुट्|लोट्|लृट्|लङ्|लृङ|लुङ्|लिङ्)/) {
#                $word{'lakAra'} = $1;
#            }
#            if ($a =~ /^([1-8])$/) {
#                $word{'vibhakti'} = $1;
#            }
#            if ($a =~ /^(एक|द्वि|बहु)/) {
#            }
        push @results, "{" . join(', ', 
            map { "\"$_\" : \"" . $word{$_} . "\"" } sort(keys(%word))) .  "}";
    } # endof foreach
}
    print "      \"analysis\" : [";
    print "\n        " if $ans ne "";
    print join(",\n        ", @results) . "
      ]
  }
}\n";

close(TMP1);
