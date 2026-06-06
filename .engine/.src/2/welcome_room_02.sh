#!/bin/bash
secret=""
sss=""

if [[ -s "$my_base_dir/.engine/.out/1/key.txt" ]]; then
  secret=$(head -n -0 "$my_base_dir/.engine/.out/1/key.txt")
  sss="A chave da sala room_01 era: $secret"
else
  secret=""
  sss=""
fi

wlcr2 wlc_room_02
echo $sss
wlcr2 wlc_room_02_fast_guide
