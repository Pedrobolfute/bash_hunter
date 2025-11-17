#!/bin/bash

my_base_dir=$(find "$HOME" -type d -name "bash_hunter" -print -quit 2>/dev/null)
correct_key=$(tr -d '\r\n ' < "$my_base_dir/engine/out/1/key.txt")

if [[ -z "$1" ]]; then
    echo "❌ Nenhuma senha informada. Exemplo:"
    echo "source carregar_cenario_02.sh \"senha_aqui\""
    return 1
fi

if [[ "$1" != "$correct_key" ]]; then
    echo "❌ Senha errada. Você não pode carregar o cenário."
    return 1
fi

dirfrom="$my_base_dir/engine/out/2/event/baia_de_todos_os_santos"
dirto="$my_base_dir/play/room_02"

pwdd(){
  local mensagem="

    ▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
    ▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
    ▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

    Sala (room_02) carregada.
"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BASH HUNTER ⚓" --msgbox "$mensagem" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

if [[ -d "$dirfrom" ]]; then
  mv "$dirfrom/mini_mapa.txt" "$dirto"
  mv "$dirfrom" "$dirto"
  pwdd
else
  echo "Fase já foi iniciada. Use ls para ver novos arquivos em room_02"
fi