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
export BIN_PATH=$myPATH/morph_bin

INFILE=$1
OUTFILE=$2
OutKqwFile=$3
mode=$4

cp $INFILE $INFILE.orig
$myPATH/SHMT/prog/morph/bin/get_std_spelling.out < $1 |\
$myPATH/SHMT/prog/morph/bin/split-samAsa-wrds.pl $TMP_FILES_PATH/tmp_std $TMP_FILES_PATH/tmp_non-samAsa-ppada-wrds $TMP_FILES_PATH/tmp_samAsa-upada-wrds 
# non-samAsa-ppada => non-samAsa & samAsa-ppada

if [ $mode = "MODE" ]; then
#/usr/bin/time FORMAT 
LTPROCBINDIR/lt-proc -c $BIN_PATH/skt_morf.bin < $TMP_FILES_PATH/tmp_non-samAsa-ppada-wrds > $TMP_FILES_PATH/tmp_mo
else
$myPATH/SHMT/prog/morph/client_mo_file.sh $TMP_FILES_PATH/tmp_non-samAsa-ppada-wrds | grep . > $TMP_FILES_PATH/tmp_mo
fi

cat $TMP_FILES_PATH/tmp_mo | perl -pe 's/\//=/;s/^.*=\*.*//;s/.*=//;s/^^//;' > $TMP_FILES_PATH/tmp_n

w1=`grep . $TMP_FILES_PATH/tmp_samAsa-upada-wrds | wc -w`
if [ $w1 -gt 0 ]; then
#/usr/bin/time -f "\t%Uuser %Ssystem %Eelapsed %PCPU (%Xtext+%Ddata %Mmax)k\n%Iinputs+%Ooutputs (%Fmajor+%Rminor)pagefaults %Wswaps %C\n" 
LTPROCBINDIR/lt-proc -c $BIN_PATH/skt_samAsanoun_morf.bin < $TMP_FILES_PATH/tmp_samAsa-upada-wrds | perl -pe 's/\//=/;s/^.*=\*.*//;s/.*=//;s/^^//;s/^-$//;' > $TMP_FILES_PATH/tmp_samAsa1
LTPROCBINDIR/lt-proc -c $BIN_PATH/skt_morf.bin < $TMP_FILES_PATH/tmp_samAsa-upada-wrds | perl -pe 's/\//=/;s/^.*=\*.*//;s/.*=//;s/^^//;s/^-$//;' > $TMP_FILES_PATH/tmp_samAsa2
paste -d'/' $TMP_FILES_PATH/tmp_samAsa1 $TMP_FILES_PATH/tmp_samAsa2 > $TMP_FILES_PATH/tmp_samAsa3
perl -pe 's/^\///' < $TMP_FILES_PATH/tmp_samAsa3 > $TMP_FILES_PATH/tmp_samAsa
else
touch $TMP_FILES_PATH/tmp_samAsa
fi

#cat $TMP_FILES_PATH/tmp_non-samAsa-ppada-wrds | sed '1,$s/^\-//' | /usr/bin/time -f "\t%Uuser %Ssystem %Eelapsed %PCPU (%Xtext+%Ddata %Mmax)k\n%Iinputs+%Ooutputs (%Fmajor+%Rminor)pagefaults %Wswaps %C\n" LTPROCBINDIR/lt-proc -c $BIN_PATH/kqw_lyap_morf.bin | perl -pe 's/\//=/;s/^.*=\*.*//;s/.*=//;s/^^//;' > $TMP_FILES_PATH/tmp_k
#/usr/bin/time -f "\t%Uuser %Ssystem %Eelapsed %PCPU (%Xtext+%Ddata %Mmax)k\n%Iinputs+%Ooutputs (%Fmajor+%Rminor)pagefaults %Wswaps %C\n" 
cat $TMP_FILES_PATH/tmp_std | perl -pe 's/^\-//' | 
LTPROCBINDIR/lt-proc -c $BIN_PATH/kqw_lyap_morf.bin | perl -pe 's/\//=/;s/^.*=\*.*//;s/.*=//;s/^^//;' > $TMP_FILES_PATH/tmp_k

paste -d= $TMP_FILES_PATH/tmp_std $TMP_FILES_PATH/tmp_n | paste -d'/' - $TMP_FILES_PATH/tmp_samAsa | perl -pe 's/\/$//;s/^=//;s/=\//=/' > $TMP_FILES_PATH/tmp_all

$myPATH/SHMT/prog/morph/bin/handle_Namul_next.pl < $TMP_FILES_PATH/tmp_all | $myPATH/SHMT/prog/morph/bin/handle_Namul_prev.pl  | perl -pe 's/=\//=/;s/\$$//g' > $OUTFILE

#get derivational info for kqw analysis 
cat $TMP_FILES_PATH/tmp_k | perl -pe 's/\//\n/g;s/<.*>//g;s/\$$//g' | grep -v '^=/$' | sort -u | grep . > $TMP_FILES_PATH/tmp_k_words

w1=`grep . $TMP_FILES_PATH/tmp_k_words | wc -w`
if [ $w1 -gt 0 ]; then
#/usr/bin/time -f "\t%Uuser %Ssystem %Eelapsed %PCPU (%Xtext+%Ddata %Mmax)k\n%Iinputs+%Ooutputs (%Fmajor+%Rminor)pagefaults %Wswaps %C\n" 
LTPROCBINDIR/lt-proc -c $BIN_PATH/kqw_lyap_morf.bin < $TMP_FILES_PATH/tmp_k_words | perl -pe 's/\//=/;s/^.*=\*.*//;s/.*=//;s/^^//;' > $TMP_FILES_PATH/tmp_k1
paste -d'/' $TMP_FILES_PATH/tmp_k_words $TMP_FILES_PATH/tmp_k1 | perl -pe 's/^\//=/;s/\/$//;s/^=$//' | sort -u > $OutKqwFile
else
touch $OutKqwFile
fi

#rm $TMP_FILES_PATH/tmp_std $TMP_FILES_PATH/tmp_non-samAsa-pada-wrds $TMP_FILES_PATH/tmp_samAsa-pada-wrds $TMP_FILES_PATH/tmp_n $TMP_FILES_PATH/tmp_samAsa $TMP_FILES_PATH/tmp_k $TMP_FILES_PATH/tmp_all $TMP_FILES_PATH/tmp_k1 $TMP_FILES_PATH/tmp_k_words $INFILE.orig
