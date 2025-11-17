#!/bin/bash

my_base_dir=$(find "$HOME" -type d -name "bash_hunter" -print -quit 2>/dev/null)
secret=""
sss=""

if [[ -s "$my_base_dir/engine/out/1/key.txt" ]]; then
  secret=$(head -n -0 "$my_base_dir/engine/out/1/key.txt")
  sss="A chave da sala room_01 é: $secret"
else
  secret=""
  sss="Você não completou a primeira fase (room_01)."
fi

pwdd(){
  local mensagem="

▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌
                       
"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BASH HUNTER ⚓" --msgbox "$mensagem $sss" 25 80
  else
    echo -e "\n$mensagem $sss\n"
  fi
}

pwdd
echo $sss