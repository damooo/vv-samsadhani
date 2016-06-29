#!PERLPATH

while($in = <STDIN>){
chomp($in);
if($in =~ /./) {
   @f = split(/\t/,$in);

   $colorcode = "-";
   if($f[11] =~ /<viBakwiH:([1-8])/) { $colorcode = "@"."N$1";}
   elsif($f[11] =~ /<prayogaH:/) { $colorcode = "@"."KP";}
   elsif($f[11] =~ /<vargaH:avy/) { $colorcode = "@"."NA";}

   print $in,"\t",$colorcode,"\n";
} else { print "\n";}
}
