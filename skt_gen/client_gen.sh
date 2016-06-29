#!/bin/bash

exec 3>TFPATH/skt_gen_to
exec 4<TFPATH/skt_gen_from
cat >&3
echo -e '\0' >&3
while read -r -d '' <&4; do echo -n "$REPLY"; break; done
