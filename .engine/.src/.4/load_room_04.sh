#!/bin/bash

if [[ -z "$1" ]]; then
    echo "❌ Nenhuma senha informada. Informe a senha como no Exemplo abaixo:"
    echo "source carregar_cenario_04.sh \"senha_aqui\""
    return 1
fi

dec(){
  local in="jsvqmke"
  echo "$in" | tr 'e-za-de-za-d' 'a-za-z'
}

correct_key=$(dec)

decr(){
  local in="evmwi"
  echo "$in" | tr 'e-za-de-za-d' 'a-za-z'
}

sub=$(decr)

if [[ "$1" != "$correct_key" ]]; then
    echo "❌ Senha errada. Você não pode carregar o cenário."
    return 1
fi

echo "true" > $engine_out/3/finished.txt

dirfrom="$my_base_dir/.engine/.out/4"
dirto="$my_base_dir/play/room_04"

pwdd(){
  local mensagem="
    ▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
    ▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
    ▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

    === SALA CARREGADA ===
    Você entrou na fase 04 (room_04)!

    === O DESAFIO ===
    Procure 5 mapas espalhados
    pela Baía de Todos os Santos.

    Cada mapa contém pistas
    para formar uma pergunta.

    A resposta será a chave
    para o próximo room.

    === COMO ENCONTRAR ===
    Digite:
    map
"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BASH HUNTER ⚓" --msgbox "$mensagem" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

if [[ -d "$dirfrom/raiz/bau" ]]; then
  echo "$sub" | sudo -S mv "$dirfrom/map" "/bin" 2>/dev/null
  echo "$sub" | sudo -S mv "$dirfrom/bin/bau" "/bin" 2>/dev/null
  echo "$sub" | sudo -S mv "$dirfrom/etc/bau" "/etc" 2>/dev/null
  echo "$sub" | sudo -S mv "$dirfrom/raiz/bau" "/" 2>/dev/null
  echo "$sub" | sudo -S mv "$dirfrom/tmp/bau" "/tmp" 2>/dev/null
  echo "$sub" | sudo -S mv "$dirfrom/home/bau" "/home" 2>/dev/null

  echo "true" > $engine_out/4/loaded.txt
  clear
  pwdd
else
  clear
  echo "
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

  === FASE JÁ INICIADA ===

  === SEU DESAFIO ===
  Procure 5 mapas espalhados
  pela Baía de Todos os Santos.

  Cada mapa contém pistas
  para formar uma pergunta.

  A resposta será a chave
  para o próximo room.

  === COMO ENCONTRAR ===
  Digite:
  map

  Veja onde os mapas estão.

  === DICA ===
  Anote tudo que encontrar.

▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

  "
fi