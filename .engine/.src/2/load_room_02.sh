#!/bin/bash

finished=$( (tr -d '\r\n ' < "$engine_out/1/finished.txt") 2>/dev/null )

if [[ "$finished" != "true" ]]; then
  echo "
    ⚠️ O room_01 precisa ser finalizado antes de prosseguir!
  "
  return 1
fi

if [[ -z "$1" ]]; then
    echo "
      ❌ Nenhuma senha informada. Informe a senha como no Exemplo abaixo:
      "
    echo "
      source carregar_cenario_02.sh \"senha_aqui\"
      "
    return 1
fi

correct_key=$(tr -d '\r\n ' < "$my_base_dir/.engine/.out/1/key.txt" 2>/dev/null)
if [[ "$1" != "$correct_key" ]]; then
    echo "
      ❌ Senha errada. Você não pode carregar o cenário.
      "
    return 1
fi

dirfrom="$my_base_dir/.engine/.out/2/event/baia_de_todos_os_santos"
dirto="$my_base_dir/play/room_02"

pwdd(){
  local mensagem="
    ▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
    ▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
    ▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

    === SALA CARREGADA ===
    Você entrou na fase 02 (room_02)!
    Um novo caminho foi aberto...

    === PRÓXIMO PASSO ===
    Digite:
    ls

    Veja o que apareceu
    e escolha para onde ir.

    === MISSÃO ===
    Explore o novo caminho!
"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BASH HUNTER ⚓" --msgbox "$mensagem" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

if [[ -d "$dirfrom" ]]; then
  mv "$dirfrom/instrução.txt" "$dirto" 2>/dev/null
  mv "$dirfrom/mapa.txt" "$dirto" 2>/dev/null
  mv "$dirfrom" "$dirto" 2>/dev/null
  echo "true" > $engine_out/2/loaded.txt
  clear
  pwdd
else
  clear
  echo "
    === FASE JÁ INICIADA ===
    Você já está na fase 02 (room_02).


    === PRÓXIMO PASSO ===
    Digite:
    ls

    Veja os novos arquivos
    e escolha o que fazer.


    === DICA ===
    Sempre use "ls"
    para descobrir caminhos novos.
    "
fi