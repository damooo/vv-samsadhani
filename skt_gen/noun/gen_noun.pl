#!PERLPATH -I LIB_PERL_PATH/

#  Copyright (C) 2010-2014 Amba Kulkarni (ambapradeep@gmail.com)
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

my $myPATH = "SCLINSTALLDIR";
require "$myPATH/converters/convert.pl";
require "$myPATH/skt_gen/noun/sarvanAma.pl";
require "$myPATH/skt_gen/noun/saMKyeya.pl";
require "$myPATH/skt_gen/noun/saMKyA.pl";
require "$myPATH/skt_gen/noun/pUraNa.pl";


package main;
use CGI qw/:standard/;
#use CGI::Carp qw(fatalsToBrowser);

 $rt = $ARGV[0];
 $lifga = $ARGV[1];
 $encoding = $ARGV[2];
 $level = $ARGV[3];
 $mode = $ARGV[4];

if($mode eq "MODE") { #Better name Non-Daemon
 $generator = "LTPROCBINDIR/lt-proc -ct $myPATH/morph_bin/skt_gen.bin";
} elsif($mode eq "SERVER") { #Better name Daemon
 $generator = "$myPATH/skt_gen/client_gen.sh";
}


 $rt_wx=&convert($encoding,$rt);
 $lifga_wx=&convert("Unicode",$lifga);
 chomp($rt_wx);
 chomp($lifga_wx);
 $lcat = &get_cat($rt_wx);

 if(($rt_wx eq "asmax") || ($rt_wx eq "yuRmax")) { $lifga_wx = "a"; $lcat = "sarva";}

 $LTPROC_IN = "";
 for($vib=1;$vib<9;$vib++){
    for($num=1;$num<4;$num++){
        $str = "$rt_wx<vargaH:$lcat><lifgam:$lifga_wx><viBakwiH:$vib><vacanam:$num><level:$level>"; 
        $LTPROC_IN .=  $str."\n";
    } # number
 } #vib
 chomp($LTPROC_IN); # To chomp the last \n, else it produces an extra blank line in the o/p of lt-proc

 $str = "echo '".$LTPROC_IN."' | $generator | grep . | pr --columns=3 --across --omit-header | $myPATH/converters/ri_skt | $myPATH/converters/iscii2utf8.py 1 | $myPATH/skt_gen/noun/noun_format_html.pl $rt_wx $lifga_wx";
 system($str);

sub get_cat{
 my($rt) = @_;
 $lcat = "nA";
 if($sarvanAma{$rt}) { $lcat = "sarva";}
 elsif($saMKyeya{$rt}) { $lcat = "saMKyeyam";}
 elsif($saMKyA{$rt}) { $lcat = "saMKyA";}
 elsif($pUraNa{$rt}) { $lcat = "pUraNa";}
 $lcat;
}
1;
