#!/bin/bash

if [[ -z "$1" ]]; then
    echo "❌ Nenhuma senha informada. Informe a senha como no Exemplo abaixo:"
    echo "source carregar_cenario_04.sh \"senha_aqui\""
    return 1
fi

dec(){
  local in="pmfivhehi"
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

echo "true" > $engine_out/5/finished.txt

dirfrom="$my_base_dir/.engine/.out/6"
dirto="$my_base_dir/play/room_06"

pwdd(){
  local mensagem="
    ▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
    ▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
    ▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

Sala (room_06) carregada.

Bem vindo, Jogador Marujo!

Aqui você vai precisar usar bem o comando /"find/".
Você pode ate combinar os comandos (cat, |, grep)
junto com o /"find/" para sair dessa siatuação...

Para conseguir sair dessa situação desesperadora,
procure sair da Baia de Todos os Santos. Vá de
encontro ao oceano atlantico, Marujo!

Boa viagem,

"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BASH HUNTER ⚓" --msgbox "$mensagem" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

if [ -e "$engine_out/6/loaded.txt" ]; then
  clear
  echo "
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

Fase já foi iniciada. 
  
Siga o arquivo de instruções.
    
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

    "
else
  if [[ -d "$dirfrom" ]]; then
    echo "$sub" | sudo -S source "$dirfrom/atravessar"
    echo "cabei execultar source"
    echo "$sub" | sudo -S mv "$dirfrom/find.txt" $dirto 2>/dev/null
    echo "$sub" | sudo -S mv "$dirfrom/instrução" $dirto 2>/dev/null
    echo "$sub" | sudo -S mv "$dirfrom/tempestade/" 

    echo "$sub" | sudo -S echo "true" > $engine_out/6/loaded.txt
    # clear 
    pwdd
  else
    clear
  fi
fi