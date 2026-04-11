#!/bin/bash

finished=$( (tr -d '\r\n ' < "$engine_out/2/finished.txt") 2>/dev/null )

if [[ "$finished" != "true" ]]; then
  echo "
    ⚠️ O room_02 precisa ser finalizado antes de prosseguir!
  "
  return 1
fi

if [[ -z "$1" ]]; then
    echo "
      ❌ Nenhuma senha informada. Informe a senha como no Exemplo abaixo:"
    echo "
      source carregar_cenario_02.sh \"senha_aqui\"
    "
    return 1
fi

correct_key=$(tr -d '\r\n ' < "$my_base_dir/.engine/.out/2/key.txt" 2>/dev/null)
if [[ "$1" != "$correct_key" ]]; then
    echo "
      ❌ Senha errada. Você não pode carregar o cenário.
      "
    return 1
fi

dirfrom="$my_base_dir/.engine/.out/3"
dirto="$my_base_dir/play/room_03"

pwdd(){
  local mensagem="
    ▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
    ▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
    ▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

    === SALA CARREGADA ===
    Você entrou na fase 03 (room_03)!

    Um novo arquivo apareceu...

    === PRÓXIMO PASSO ===
    Digite:
    ls

    Veja o novo arquivo
    e descubra o que fazer.

    === MISSÃO ===
    Explore o arquivo que foi criado!
"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BASH HUNTER ⚓" --msgbox "$mensagem" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

if [[ ! -e "$engine_out/3/loaded.txt" ]]; then
  mv "$dirfrom/instrução.txt" "$dirto" 2>/dev/null
  echo "true" > $engine_out/3/loaded.txt
  clear
  pwdd
else
  clear
  echo "
    === FASE JÁ INICIADA ===
    Você já está na fase 03 (room_03).

    === PRÓXIMO PASSO ===
    Digite:
    ls

    Veja o novo arquivo
    e descubra o que fazer.

    === DICA ===
    Use "ls" para encontrar novidades.
    "
fi