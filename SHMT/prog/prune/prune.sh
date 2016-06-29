#!/bin/sh
#  Copyright (C) 2002-2016 Amba Kulkarni (ambapradeep@gmail.com)
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



export BIN_PATH=$SHMT_PATH/prog/prune

$BIN_PATH/rm_wasil.pl < $1  |\
$BIN_PATH/handle_special_words_repetitive.pl  |\
$BIN_PATH/rm_duplicate_ans.pl |\
$BIN_PATH/rm_non_apte.pl $BIN_PATH/default_gen.dbm $BIN_PATH/apte_pratipadik.dbm $SHMT_PATH/prog/morph/rUDa_kqw.gdbm  |\
#$BIN_PATH/retain_only_inflectional_if_exists.pl |\
#Above line was commented. Uncommented by Amba on 28 Feb 2012
#test sent: praBAwe ahaM rAjasaBAm gawvA kA vArwA (aswi) iwi paSyAmi
#Without praBAwe it produces fast and correct result.
#With praBAwe it takes infinitely large time.
#19 May 2013: Again retain_only.. is commented. This time the above sent worked well without taking long time.
#When this is uuncommented, sawi sapwami does not work well
#rAme vanam gacCawi sawi sIwA anusarawi
$BIN_PATH/remove_prAtipadik_derivation_info.pl |\
$BIN_PATH/rm_saMKyA.pl |\
$BIN_PATH/handle_samboXana.pl D  2> /dev/null |\
$BIN_PATH/keep_freq_mo.pl $BIN_PATH/default_morph.dbm |\
$BIN_PATH/handle_sawi_sapwami.pl |\
$BIN_PATH/priotarize.pl |\
perl -pe 's/=\//=/; s/^\///; s/\/\//\//g;' > $2 2> /dev/null

#$BIN_PATH/retain_only_pronominal_if_exists.pl |\
#The above program is removed, since now the kaaraka analyser takes care of the multiple analysis
#$BIN_PATH/rm_non_avyaya.pl |\
#The above program is removed, since now the kaaraka analyser takes care of the multiple analysis
