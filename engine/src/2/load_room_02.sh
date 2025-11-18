#!/bin/bash

finished=$( (tr -d '\r\n ' < "$engine_out/1/finished.txt") 2>/dev/null )

if [[ "$finished" != "true" ]]; then
  echo "⚠️ O room_01 precisa ser finalizado antes de prosseguir!"
  return 1
fi

if [[ -z "$1" ]]; then
    echo "❌ Nenhuma senha informada. Informe a senha como no Exemplo abaixo:"
    echo "source carregar_cenario_02.sh \"senha_aqui\""
    return 1
fi

correct_key=$( (tr -d '\r\n ' < "$engine_out/1/key.txt") 2>/dev/null )
if [[ "$1" != "$correct_key" ]]; then
    echo "❌ Senha errada. Você não pode carregar o cenário."
    return 1
fi

dirfrom="$engine_out/2/event/baia_de_todos_os_santos"
dirto="$play_dir/room_02"

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
  mv "$dirfrom/mini_mapa.txt" "$dirto" 2>/dev/null
  mv "$dirfrom" "$dirto" 2>/dev/null
  echo "true" > $engine_out/2/loaded.txt
  pwdd
else
  echo "Fase já foi iniciada. Use ls para ver novos arquivos em room_02"
fi