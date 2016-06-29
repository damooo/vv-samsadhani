 my $mycPATH = "SCLINSTALLDIR/converters";

 sub cnvrt2utfr {
  my($in) = @_;

  $pid = $$;
  open(TMP,">TFPATH/tmpin$pid");
  print TMP $in," "; #Idiosynchrosy of ir_skt; does not work well if con is at the end. Hence added an extra space
  close(TMP);

  system("$mycPATH/utfd2r.sh < TFPATH/tmpin$pid > TFPATH/tmpout$pid");

  open(TMP,"<TFPATH/tmpout$pid");
  $out = <TMP>;
  chomp($out);
  close(TMP);
$out;
}
1; 
