#!/bin/bash

secret=""
sss=""
finished=$( (tr -d '\r\n ' < "$engine_out/1/finished.txt") 2>/dev/null )

if [[ "$finished" != "true" ]]; then
  wlcr2 room_01_not_finished
  return 1
fi

if [[ -s "$my_base_dir/.engine/.out/1/key.txt" ]]; then
  secret=$(head -n -0 "$my_base_dir/.engine/.out/1/key.txt")
  sss="
    A chave da sala room_01 é: $(wlcr2 passwd)
  "
else
  secret=""
  sss="
    $(wlcr2 room_01_not_finished)
  "
fi

clear
echo $sss
