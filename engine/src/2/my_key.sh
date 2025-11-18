#!/bin/bash

secret=""
sss=""

if [[ -z "$my_base_dir" ]]; then
    echo "❌ Diretório bash_hunter não encontrado em $HOME."
    return 1
fi

out_dir="$engine_out/2"
room2_dir="$play_dir/room_02"

terminal_me_deus="$play_dir/room_02/baia_de_todos_os_santos/oeste/noroeste/noroeste/norte/norte/oeste/noroeste/norte/leste"

if [[ "$PWD" != "$terminal_me_deus" ]]; then
    echo "⚠️ Você só pode pegar a senha no terminal marítimo Madre de Deus."
    return 1
fi
touch "$engine_out/key.txt"


if [[ -f "$engine_out/2/key.txt" ]]; then
  echo "navegar" > "$engine_out/2/key.txt"
  secret=$(head -n -0 "$engine_out/2/key.txt")
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
