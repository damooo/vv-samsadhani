#!/bin/sh

#  Copyright (C) 2009-2016 Amba Kulkarni (ambapradeep@gmail.com)
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


myPATH=SCLINSTALLDIR
#export BIN_PATH=/home/amba/my_packages/LT_TOOLS/SKT_DATA/JULY2008/DIX/dix_and_bin
#rm TMPPATHn TMPPATHstd TMPPATHu TMPPATHw TMPPATHukm TMPPATHl TMPPATHnon-samAsa-pada-wrds TMPPATHsamAsa-pada-wrds

word=$1
mode=$2

if [ $mode = "MODE" ]; then
echo $word | $myPATH/SHMT/prog/morph/bin/get_std_spelling.out |\
LTPROCBINDIR/lt-proc -c $myPATH/morph_bin/skt_morf.bin | grep . | perl -p -e 's/\//=/' | perl -p -e 's/^.*=\*.*//' | perl -p -e 's/.*=//' | perl -p -e 's/^^//' |\
$myPATH/SHMT/prog/interface/modify_mo_for_mo_display.pl |\
perl -p -e 's/\/\/\+/\//g' | perl -p -e 's/\/$//' | perl -p -e  's/^\///' | $myPATH/converters/ri_skt | $myPATH/converters/iscii2utf8.py 1 
else
echo $word | $myPATH/SHMT/prog/morph/bin/get_std_spelling.out |\
$myPATH/SHMT/prog/morph/client_mo.sh | grep . | perl -p -e 's/\//=/' | perl -p -e 's/^.*=\*.*//' | perl -p -e 's/.*=//' | perl -p -e 's/^^//' |\
$myPATH/SHMT/prog/interface/modify_mo_for_mo_display.pl  |\
perl -p -e 's/\/\/\+/\//g' | perl -p -e 's/\/$//' | perl -p -e  's/^\///' | $myPATH/converters/ri_skt | $myPATH/converters/iscii2utf8.py 1
fi
