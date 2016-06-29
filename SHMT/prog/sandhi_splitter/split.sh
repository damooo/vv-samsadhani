#!/bin/sh

#  Copyright (C) 2006-2016 Amba Kulkarni (ambapradeep@gmail.com)
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

export BIN_PATH=$SHMT_PATH/prog/morph/dix_and_bin

INFILE=$1
mode=$2

cut -f3 $INFILE | sort -u | grep -v '-' |\
$BIN_PATH/../bin/get_std_spelling.out > $TMP_FILES_PATH/tmp_before_split

if [ $mode = "MODE" ]; then
LTPROCBINDIR/lt-proc -c $myPATH/morph_bin/skt_morf.bin < $TMP_FILES_PATH/tmp_before_split > $TMP_FILES_PATH/tmp_mo_before_split
else
$myPATH/SHMT/prog/morph/client_mo_file.sh $TMP_FILES_PATH/tmp_before_split > $TMP_FILES_PATH/tmp_mo_before_split
fi
grep '*' $TMP_FILES_PATH/tmp_mo_before_split | perl -pe 's/\/.*//' | perl -pe 's/^.//' > $TMP_FILES_PATH/tmp_unkn
cd $TMP_FILES_PATH
$SHMT_PATH/prog/sandhi_splitter/run.sh tmp_unkn > tmp_split
cd ..
$SHMT_PATH/prog/sandhi_splitter/replace_sandhi.pl $TMP_FILES_PATH/tmp_split < $INFILE.orig | perl -pe 's/\+/\n/g' > $INFILE

rm $TMP_FILES_PATH/tmp_before_split $TMP_FILES_PATH/tmp_mo_before_split $TMP_FILES_PATH/tmp_unkn $TMP_FILES_PATH/tmp_split $INFILE.orig
