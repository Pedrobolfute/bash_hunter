#!/bin/bash

secret=""
sss=""
finished=$( (tr -d '\r\n ' < "$engine_out/1/finished.txt") 2>/dev/null )

if [[ "$finished" != "true" ]]; then
  echo "
    ⚠️ O room_01 precisa ser finalizado antes de prosseguir!
  "
  return 1
fi

if [[ -s "$my_base_dir/.engine/.out/1/key.txt" ]]; then
  secret=$(head -n -0 "$my_base_dir/.engine/.out/1/key.txt")
  sss="
    A chave da sala room_01 é: $secret
  "
else
  secret=""
  sss="
    Você não completou a primeira fase (room_01).
  "
fi

pwdd(){
  local mensagem="
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌
                       
$sss
"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BASH HUNTER ⚓" --msgbox "$mensagem" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

clear

pwdd
echo $sss
