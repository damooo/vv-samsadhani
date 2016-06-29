#!/bin/sh

#  Copyright (C) 2008-2016 Amba Kulkarni (ambapradeep@gmail.com)
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


myPATH=SCLINSTALLDIR/
export SHMT_PATH=$myPATH/SHMT
ANU_MT_PATH=$SHMT_PATH/prog
export LC_ALL=POSIX

TMP_DIR_PATH=$2
LANG=$3
OUTSCRIPT=$4
SANDHI=$5
MORPH=$6
PARSE=$7
TEXT_TYPE=$8
mode=$9
ECHO=$10

if [ $OUTSCRIPT = "ROMAN" ]; then
 my_converter="$myPATH/converters/wx2utf8roman.out"
 my_converter_wxHindi="$myPATH/converters/wx2utf8roman.out"
fi

if [ $OUTSCRIPT = "DEV" ]; then
  my_converter="$myPATH/converters/wx2utf8.sh"
  my_converter_wxHindi="$myPATH/converters/wxHindi-utf8.sh"
fi

if [ $OUTSCRIPT = "VH" ]; then
  my_converter="$myPATH/converters/wx-velthuis.out"
  my_converter_wxHindi="$myPATH/converters/wx-velthuis.out"
fi

if [ $# -lt 1 ] ; then
  echo "Usage: anu_skt_hnd.sh <file> tmp_dir_path hi [DEV|ROMAN|VH] [NO|YES] [UoHyd|GH|Zen_Amba] [NO|Partial|Full] [ECHO|NOECHO] [D]."
fi

cd $TMP_DIR_PATH
fbn=`basename $1` #fbn = file base name
dnm=`dirname $1` #dnm = directory name

temp_files_path=${dnm}/tmp_$fbn

export TMP_FILES_PATH=$temp_files_path

if [ -f "tmp_$fbn"  ] ; then 
  echo "File tmp_$fbn exists. Remove or rename it, and give the command again."
else
  mkdir -p $temp_files_path

  cmd=s#tmp_dir_scrpt#$temp_files_path\&amp\;outscript=$OUTSCRIPT#g
  cmd1=s#tmp_anu_dir#$temp_files_path#g

###########
   if [ $PARSE != "AVAILABLE" ] ; then
    if [ $MORPH = "UoHyd" ] ; then

      $ANU_MT_PATH/format/format.sh < $1 > $temp_files_path/$fbn.out
###########
      if [ $SANDHI = "YES" ] ; then
        cp $temp_files_path/$fbn.out $temp_files_path/$fbn.out.orig
        $ANU_MT_PATH/sandhi_splitter/split.sh $temp_files_path/$fbn.out $mode
      fi
      if [ $SANDHI = "NO" ] ; then
        cp $temp_files_path/$fbn.out $temp_files_path/$fbn.out.orig
        $ANU_MT_PATH/sandhi_splitter/copy_field.pl < $temp_files_path/$fbn.out.orig > $temp_files_path/$fbn.out
      fi
###########
#      /usr/bin/time FORMAT 
$ANU_MT_PATH/morph/morph.sh $temp_files_path/$fbn.out $temp_files_path/$fbn.mo_all $temp_files_path/$fbn.mo_prune $temp_files_path/$fbn.mo_kqw $temp_files_path/$fbn.unkn $mode

    # $1.unkn contains the unrecognised words
    # $1.mo_all: Monier williams o/p
    # $1.mo_prune: After pruning with Apte's dict
    # $1.mo_kqw: After adding derivational morph analysis
  fi

  GH_Input="NO"
  if [ $MORPH = "GH" ] ; then
     GH_Input="YES"
     /home/ambaji/Heritage/SktEngine.2.92/ML/offline_reader < $TMP_DIR_PATH/$1 > $temp_files_path/$1.gh
     $ANU_MT_PATH/Heritage_morph_interface/Heritage2anusaaraka_morph.sh < $TMP_DIR_PATH/tmp_$fbn/$fbn.gh > $TMP_DIR_PATH/tmp_$fbn/$fbn.out
  else if [ $MORPH = "Zen_Amba" ] ; then
     /home/ambaji/ZEN_AMBA/SktPlatform.2.72/ML/offline_reader < $TMP_DIR_PATH/$1 > $temp_files_path/$1.gh
     $ANU_MT_PATH/Heritage_morph_interface/Heritage2anusaaraka_morph.sh $TMP_DIR_PATH/tmp_$fbn/$fbn.gh > $TMP_DIR_PATH/tmp_$fbn/$fbn.out
  fi
  fi

###########
#     # First argument: Name of the file
#     # Second argument: no of parses
#     # Third argument: Name of the file with kaaraka analysis for annotation
# Fields 9 and 10: morph analysis corresponding to the kaaraka role and kaaraka role in the 10th field
#     /usr/bin/time FORMAT 
$ANU_MT_PATH/kAraka/clips_rules.sh $GH_Input $temp_files_path $fbn.out $fbn.kAraka $OUTSCRIPT $PARSE $TEXT_TYPE $ECHO 
 fi  # PARSE != AVAILABLE ends here
#
###########
# anaphora in the 11th field
        # First argument: Name of the input file
        # Second argument: Name of the output file
     $ANU_MT_PATH/anaphora/anaphora.pl < $temp_files_path/$fbn.out > $temp_files_path/tmp
     mv $temp_files_path/tmp $temp_files_path/$fbn.out


############
# wsd in the 12th field
    $ANU_MT_PATH/wsd/clips_wsd_rules.sh $temp_files_path/$fbn.out $temp_files_path/$fbn.wsd $temp_files_path/$fbn.wsd_upapaxa
###########
### Map to hindi
# Color Code in the 13th field
# Chunk/LWG in the 14th field
# map o/p in the 15th field and lwg o/p in 16th field
# gen o/p in the 17th field
    #cp $temp_files_path/$fbn.out $temp_files_path/jjj
    $ANU_MT_PATH/pos/add_colorcode.pl < $temp_files_path/$fbn.out |\
    $ANU_MT_PATH/chunker/lwg.pl |\
    $ANU_MT_PATH/map/add_dict_mng.pl $SHMT_PATH/data ONE  |\
    $ANU_MT_PATH/map/lwg_avy_avy.pl $SHMT_PATH/data hi  |\
    $ANU_MT_PATH/gen/agreement.pl $SHMT_PATH/data $ANU_MT_PATH/gen |\
    $ANU_MT_PATH/gen/call_gen.pl |\
    $ANU_MT_PATH/interface/modify_mo_for_display.pl > $temp_files_path/ttt
    cp $temp_files_path/ttt $temp_files_path/$fbn.out
#
##########
    $ANU_MT_PATH/translation/translate.sh $my_converter_wxHindi < $temp_files_path/$fbn.out > $1_trnsltn
###########

###########
# 1-2: format
# 3: sandhied_word
# 4: word
# 5: format
# 6-8: morph
# 9: morph in context
# 10: kaaraka role
# 11: Anaphora
# 12: WSD
# ** 13: POS
# 13: Color code
# 14: Chunk/LWG
# 15:  map o/p
# 16: lwg o/p
# 17: gen o/p
  cut -f1-7,9-10,11,13,16,17 $temp_files_path/$fbn.out |\
  perl -p -e 's/<([sa])>/<\@$1>/g' |\
  perl -p -e 's/<\/([sa])>/<\/\@$1>/g' |\
  $my_converter |\
  $ANU_MT_PATH/interface/gen_xml.pl 10 |\
  xsltproc $ANU_MT_PATH/interface/xhtml_unicode_sn-hi.xsl - |\
  $ANU_MT_PATH/interface/add_dict_ref.pl $OUTSCRIPT |\
  perl -p -e $cmd |\
  perl -p -e $cmd1 > $1.html

#rm -rf $temp_files_path/tmp* $temp_files_path/ERR $temp_files_path/in* ERR* $temp_files_path/debug_hindi_gen ${fbn} tmp

$ANU_MT_PATH/reader_generator/extract.pl < $temp_files_path/$fbn.out | $my_converter > $temp_files_path/table.csv
fi
