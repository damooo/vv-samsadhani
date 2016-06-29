#!PERLPATH

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




sub modify_mo{
 my($in) = @_;
 if($in) {
  $in =~ s/<vargaH:avy>/ avya/g;
  $in =~ s/<kqw_pratipadika:[^>]+>//g;
  $in =~ s/<vargaH:[^>]+>//g;
  $in =~ s/<vacanam:1>/ eka/g;
  $in =~ s/<vacanam:2>/ xvi/g;
  $in =~ s/<vacanam:3>/ bahu/g;
  $in =~ s/<lifgam:a>/ /g;
  $in =~ s/<lifgam:([^>]+)>/ $1/g;
  $in =~ s/<viBakwiH:([^>]+)>/ $1/g;
  $in =~ s/<word:[^>]+>//g;
  $in =~ s/<paxI:([^>]+)>/ $1/g;
  $in =~ s/<prawyayaH:([^>]+)>/ $1/g;
  $in =~ s/<waxXiwa_prawyayaH:([^>]+)>/ $1/g;
  $in =~ s/<kqw_prawyayaH:([^>]+)>/ $1/g;
  $in =~ s/<prayogaH:([^>]+)>/ $1/g;
  $in =~ s/<puruRaH:([^>]+)>/ $1/g;
  $in =~ s/<lakAraH:([^>]+)>/ $1/g;
  $in =~ s/<rel_nm:([^>]+)>//g;
  $in =~ s/<relata_pos:[0-9]*>//g;
  $in =~ s/ [ ]+/ /g;
  $in =~ s/\$//g;
  $in =~ s/{TITLE}/<TITLE>/g;
  $in =~ s/{\/TITLE}/<\/TITLE>/g;
  $in =~ s/\/\t/\t/g;
  $in;
 }
}
1;
