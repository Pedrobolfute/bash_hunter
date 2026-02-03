#!/bin/bash

my_base_dir=$(find "$HOME" -type d -name "bash_hunter" -print -quit 2>/dev/null)
secret=""
sss=""

if [[ -z "$my_base_dir" ]]; then
    echo "❌ Diretório bash_hunter não encontrado em $HOME."
    return 1
fi

out_dir="$my_base_dir/.engine/.out/2"
room2_dir="$my_base_dir/play/room_02"

terminal_me_deus="$my_base_dir/play/room_02/baia_de_todos_os_santos/oeste/noroeste/noroeste/norte/norte/oeste/noroeste/norte/leste"

if [[ "$PWD" != "$terminal_me_deus" ]]; then
    echo "⚠️ Você só pode pegar a senha no terminal marítimo Madre de Deus."
    return 1
fi
touch "$my_base_dir/.engine/.out/2/key.txt"


if [[ -f "$my_base_dir/.engine/.out/2/key.txt" ]]; then
  echo "navegar" > "$my_base_dir/.engine/.out/2/key.txt"
  secret=$(head -n -0 "$my_base_dir/.engine/.out/2/key.txt")
  sss="A chave da sala room_02 é: $secret"
else
  secret=""
  sss="Você não completou a fase 02 (room_02)!."
fi

pwdd_02(){
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

pwdd_02
echo $sss
