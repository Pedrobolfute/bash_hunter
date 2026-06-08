#!/bin/bash
secret=""
sss=""

decr(){
  local in="evmwi"
  echo "$in" | tr 'e-za-de-za-d' 'a-za-z'
}
sub=$(decr)
echo "$sub" | sudo -S mv "$my_base_dir/.engine/.out/2/event/baia_de_todos_os_santos/wlcr2" "/bin" #>/dev/null 2>&1
sleep 1

if [[ -s "$my_base_dir/.engine/.out/1/key.txt" ]]; then
  secret=$(head -n -0 "$my_base_dir/.engine/.out/1/key.txt")
  sleep 0.5
  sss="A chave da sala room_01 era: $secret"
else
  secret=""
  sss=""
fi

wlcr2 wlc_room_02
echo $sss
wlcr2 wlc_room_02_fast_guide
