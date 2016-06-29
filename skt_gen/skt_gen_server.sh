#!/bin/bash
 
  mkfifo TFPATH/skt_gen_to TFPATH/skt_gen_from
  chmod 777 TFPATH/skt_gen_to TFPATH/skt_gen_from
  echo $$ > TFPATH/skt_gen_daemonid
  LTPROCBINDIR/lt-proc -cz SCLINSTALLDIR/morph_bin/skt_gen.bin  <TFPATH/skt_gen_to  >TFPATH/skt_gen_from  &  pid=$!
  # Open some file descriptors so the fifo's are open for the duration of the lt-proc process:
  exec 3>TFPATH/skt_gen_to
  exec 4<TFPATH/skt_gen_from
  echo $pid >> TFPATH/skt_gen_daemonid
  wait $pid
