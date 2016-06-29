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

INFILE=$1
OUTFILE=$2
PRUNEOUT=$3
KQWOUT=$4
UNKN=$5
mode=$6

export MY_PATH=$SHMT_PATH/prog/

cut -f4 $INFILE | perl -pe 's/\-/\-\n-/g' > $TMP_FILES_PATH/tmp_words
$MY_PATH/morph/word_morph.sh $TMP_FILES_PATH/tmp_words $TMP_FILES_PATH/tmp_mo_all $TMP_FILES_PATH/tmp_kqw_analy_mo $mode
$MY_PATH/prune/prune.sh $TMP_FILES_PATH/tmp_mo_all $TMP_FILES_PATH/tmp_mo
$MY_PATH/morph/add_local_mo.sh $TMP_FILES_PATH/tmp_mo $UNKN

$MY_PATH/morph/bin/join_split_wrds.pl < $TMP_FILES_PATH/tmp_mo_all | cut -f2 > $OUTFILE

$MY_PATH/morph/bin/join_split_wrds.pl < $TMP_FILES_PATH/tmp_mo | cut -f2 > $PRUNEOUT
$MY_PATH/morph/bin/add_kqw_analy.pl $MY_PATH/morph/rUDa_kqw.gdbm $MY_PATH/morph/local_analysis/kqw_mo_ana.dbm $TMP_FILES_PATH/tmp_kqw_analy_mo < $PRUNEOUT > $KQWOUT

paste $INFILE $OUTFILE $PRUNEOUT $KQWOUT| perl -pe 's/^\t//;s/^\t//;s/^\t//' > $TMP_FILES_PATH/tmp_111
cp $TMP_FILES_PATH/tmp_111 $INFILE

#rm $TMP_FILES_PATH/tmp_words $TMP_FILES_PATH/tmp_mo_all $TMP_FILES_PATH/tmp_mo $TMP_FILES_PATH/tmp_kqw_analy_mo 
