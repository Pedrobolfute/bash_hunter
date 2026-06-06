#!/bin/bash
finished=$( (tr -d '\r\n ' < "$engine_out/1/finished.txt") 2>/dev/null )

if [[ "$finished" != "true" ]]; then
  wlcr2 room_01_not_finished
  return 1
fi

if [[ -z "$1" ]]; then
    wlcr2 pass_not_informed
    return 1
fi

correct_key=$(tr -d '\r\n ' < "$my_base_dir/.engine/.out/1/key.txt" 2>/dev/null)
if [[ "$1" != "$correct_key" ]]; then

    wlcr2 wrong_pass_informed
    return 1
fi

decr(){
  local in="evmwi"
  echo "$in" | tr 'e-za-de-za-d' 'a-za-z'
}
sub=$(decr)

dirfrom="$my_base_dir/.engine/.out/2/event/baia_de_todos_os_santos"
dirto="$my_base_dir/play/room_02"
echo "entres de entrar no main dir"
if [[ -d "$dirfrom" ]]; then
  echo "dentro main dir"
  echo $(sub)
  echo "antes mv bin"
  echo "$sub" | sudo -S mv -f "$dirfrom/mapa" "/bin" # 2>&1/dev/null
  echo "$sub" | sudo -S mv -f "$dirfrom/sos" "/bin" #2>&1/dev/null
  echo "depois mv bin"
  mv "$dirfrom/instrução.txt" "$dirto" 2>&1/dev/null
  mv "$dirfrom/mapa.txt" "$dirto" 2>&1/dev/null
  mv "$dirfrom" "$dirto" 2>&1/dev/null
  echo "true" > $engine_out/2/loaded.txt
  # clear
  wlcr2 default
else
  # clear
  wlcr2 alread_started
fi