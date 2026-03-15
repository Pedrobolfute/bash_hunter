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

    Sala (room_04) carregada.

    Você vai precisar procurar os 05 mapas espalhados em toda
    BAÍA DE TODOS OS SANTOS. Dentro desse mapa vai ter uma
    pergunta. A reposta desse pergunta é a chave para o próximo
    room.

    Use o comando "map", para saber aonde estão escondidos os mapas.
"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BASH HUNTER ⚓" --msgbox "$mensagem" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

if [[ -d "$dirfrom" ]]; then
  mv "$dirfrom/map.sh" "/bin" 
  mv "$dirfrom/bin/bau" "/bin" 
  mv "$dirfrom/etc/bau" "/etc" 
  mv "$dirfrom/raiz/bau" "/" 
  mv "$dirfrom/tmp/bau" "/tmp" 2>/dev/null
  mv "$dirfrom/home/bau" "/home" 

  echo "true" > $engine_out/4/loaded.txt
  clear
  pwdd
else
  clear
  echo "Fase já foi iniciada. 
  
  Você vai precisar procurar os 05 mapas espalhados em toda
  BAÍA DE TODOS OS SANTOS. Dentro desse mapa vai ter uma
  pergunta. A reposta desse pergunta é a chave para o próximo
  room.

  Use o comando "map", para saber aonde estão escondidos os mapas."
fi