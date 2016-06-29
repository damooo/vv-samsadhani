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


ANU_MT_PATH=$SHMT_PATH/prog/parser_fail_prune
cut -f1-8 $1 > f1to8
cut -f9 $1 > jnk
cut -f10 $1 > f10
$ANU_MT_PATH/remove_derivational.pl < jnk > jnk1
paste f1to8 jnk1 f10 | perl -pe 's/^\t\t//' > $1
rm f1to8 f10 jnk jnk1
