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

SHMT_PATH=SCLINSTALLDIR/SHMT/
ANU_MT_PATH=$SHMT_PATH/prog
tmp_files_path=TFPATH
GH_INPUT=YES #This is misleading; needs to be fixed properly. Here the input need not be from GH's morph, but the constraint interface somewhere needs it.

dirname=$1
pid=$2
inpid="in".$pid

$ANU_MT_PATH/kAraka/cnvrtclips2morph.pl $ANU_MT_PATH/kAraka/gdbm_n $tmp_files_path/$dirname/clips_files/parseop_new.txt 1 $GH_INPUT < $tmp_files_path/$dirname/$inpid.out |\
$ANU_MT_PATH/kAraka/add_abhihita_info.pl |\

$ANU_MT_PATH/kAraka/disambiguate_hewu_karaNa.pl $SHMT_PATH/data/hi > $tmp_files_path/$dirname/$inpid.out.1

$ANU_MT_PATH/kAraka/prepare_dot_files.sh DEV mk_kAraka_help.pl $tmp_files_path/$dirname/$inpid.out $tmp_files_path/$dirname/parseop_new.txt $tmp_files_path/$dirname

$ANU_MT_PATH/kAraka/prepare_kAraka_tagged_file.pl 2 9 < $tmp_files_path/$dirname/$inpid.out.1 > $tmp_files_path/$dirname/$inpid.kAraka
cp $tmp_files_path/$dirname/$inpid.out.1 $tmp_files_path/$dirname/$inpid.out

$ANU_MT_PATH/shell/anu_skt_hnd.sh $inpid $temp_files_path hi DEV NO UoHyd AVAILABLE PROSE NOECHO 2>> $temp_files_path/$dirname/err$pid

$ANU_MT_PATH/interface/display_output.pl $pid
