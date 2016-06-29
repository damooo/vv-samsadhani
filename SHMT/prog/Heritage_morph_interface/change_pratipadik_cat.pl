#!PERLPATH -I LIB_PERL_PATH/

#  Copyright (C) 2010-2016 Amba Kulkarni (ambapradeep@gmail.com)
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


use GDBM_File;
tie(%LEX,GDBM_File,$ARGV[0],GDBM_READ,0644) || die "Can't open $ARGV[0] for reading";

%sarva = ('yaw',1,'wax',1,'kim',1,'ixam',1,'yax',1,'asmax',1,'yuRmax',1,'Bavaw',1,'sarva',1,'Awman',1,'anya',1,'uwwara',1,'uBa',1,'ewAvaw',1,'apara',1,'ewax',1,'axas',1);

%saMKyeyam = ('cawur',1,'wri',1,'xvi',1,'eka',1,'paFcan',1,'koti',1,'wriMSaw',1,'aRtan',1,'sahasra',1);

open(TMP,"<$ARGV[1]");
while($in = <TMP>){
   chomp($in);
   ($rt, $fem) = split(/\t/,$in); 
   $fem{$rt} = $fem;
}
close(TMP);

open(TMP,"<$ARGV[2]");
while($in = <TMP>){
   chomp($in);
   ($G_rt, $A_rt) = split(/\t/,$in); 
   $A_rt{$G_rt} = $A_rt;
}
close(TMP);

while($in = <STDIN>){
  chomp($in);
  if($in) {
   ($no,$pretag,$sword,$word,$posttag,$ana) = split(/\t/,$in);
   print $no,"\t",$pretag,"\t",$sword,"\t",$word,"\t",$posttag,"\t";
   @ana = split(/\//,$ana);
   $ans = "";
   foreach $ana (@ana) {
    if($ana =~ /^([^<]+)</) {
       $rt = $1;
       if(($rt =~ /\-/) && ($ana !~ /kqw/)) { $ana =~ s/#[0-9]+//;}
       $ana =~ s/#([0-9]+)/$1/;
    }
    if($ana =~ /^([^<]+).*<lifgam:swrI>/){
       $rt = $1;
       if($fem{$rt}) { $ana =~ s/$rt</$fem{$rt}</;}
    }
    elsif($ana =~ /^([^<]+).*/){
       $rt = $1;
       if($A_rt{$rt}) { $ana =~ s/$rt</$A_rt{$rt}</;}
    }
    if($ana =~ /^([^<]+).*/){
       $rt = $1;
       if($sarva{$rt}){
          $ana =~ s/^$rt<vargaH:nA>/$rt<vargaH:sarva>/;
       }
    }
    if($ana =~ /^([^<]+).*/){
       $rt = $1;
       if($saMKyeyam{$rt}){
          $ana =~ s/^$rt<vargaH:nA>/$rt<vargaH:saMKyeyam>/;
       }
    }
    if($ana =~ /^([^<]+).*/){
       $rt = $1;
       if(($rt eq "xviwIya") || ($rt eq "wqwIya")) {
          $ana =~ s/^$rt<vargaH:nA>/$rt<vargaH:pUraNam>/;
       }
    }
    if($ana =~ /^([^<]+)<prayogaH:[^>]+><lakAraH:[^>]+><puruRaH:[^>]+><vacanam:[^>]+>/){
	   $rt = $1;
           if($rt =~ /_/) { $rt =~ /^(.*)_([^_]+)/; $pref = $1; $key = $2;}
           else { $pref = "";$key = $rt;}
           if ($pref eq "A") { $pref = "Af";}
           $val = $LEX{$key};
           if($val) {
              $val =~ /(.*)_(.*)_(.*)/;
              if($pref ne "") {$AK_rt = $pref."_".$1;} else { $AK_rt = $1;}
              $XAwuH = $2;
              $gaNaH = $3;
           } else { $AK_rt = $rt; $AK_rt =~ s/#.*/1/;}
           $ana =~ s/^[^<]+(<prayogaH:[^>]+><lakAraH:[^>]+><puruRaH:[^>]+><vacanam:[^>]+>(<paxI:[^>]+>)?)/${AK_rt}$1<XAwuH:$XAwuH><gaNaH:$gaNaH>/;
    } elsif($ana =~ /^([^<]+)(.*)<kqw_prawyayaH:[^>]+>/){
	   $rt = $1;
           if($rt =~ /\-/) { $rt =~ /^(.*)\-([^\-]+)/; $pUrva = $1; $key = $2;}
           else { $pUrva = "";$key = $rt;}
           if($key =~ /_/) { $key =~ /^(.*)_([^_]+)/; $pref = $1; $key = $2;}
           else { $pref = "";}
           if ($pref eq "A") { $pref = "Af";}
           $val = $LEX{$key};
           if($val) {
             $val =~ /(.*)_(.*)_(.*)/;
             if($pref ne "") {$AK_rt = $pref."_".$1;} else { $AK_rt = $1;}
             $XAwuH = $2;
             $gaNaH = $3;
           } else { $AK_rt = $key; $AK_rt =~ s/#.*/1/;}
           $ans =~ s/(<kqw_pratipadika:[^>]+)#[1-9]/$1/g;
           if($pUrva ne "") { $AK_rt = $pUrva."-".$AK_rt;}
           $ana =~ s/^[^<]+(.*)(<kqw_prawyayaH:[^>]+>)/${AK_rt}$1$2<XAwuH:$XAwuH><gaNaH:$gaNaH>/;
   }
   $ana =~ s/#[1-9]</</;
   $ans .= $ana."/";
  }
  $ans =~ s/\/$//;
  print $ans,"\t",$ans,"\t",$ans,"\n";
 } else { printf "\n";}
}
