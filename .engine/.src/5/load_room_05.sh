#!/bin/bash

if [[ -z "$1" ]]; then
    echo "❌ Nenhuma senha informada. Informe a senha como no Exemplo abaixo:"
    echo "source carregar_cenario_04.sh \"senha_aqui\""
    return 1
fi

dec(){
  local in="nskehsv"
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

echo "true" > $engine_out/4/finished.txt

dirfrom="$my_base_dir/.engine/.out/5"
dirto="$my_base_dir/play/room_05"

pwdd(){
  local mensagem="
    ▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
    ▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
    ▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

    Sala (room_05) carregada.

    Bem vindo, Jogador Marujo!
    Aqui você vai precisar usar bem os comandos grep, | e wc.

    Para conseguir avançar, decifre o código dos marinheiros
    e vá ao encontro da chave do próximo room.

    Boa sorte,

"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BASH HUNTER ⚓" --msgbox "$mensagem" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

if [ -e "$engine_out/5/loaded.txt" ]; then
  clear
  echo "
  
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

  Fase já foi iniciada. 
  
    O código é a soma do resultado dessas questões:
    1° Quantas vezes a palavra "brasil" aparece
    no arquivo HISTÓRIA.txt?

    2° Quantas vezes a palavra "portugal" aparece
    no arquivo HISTORIA.txt?

    3° Quantas vezes a palavra "franceses" aparece
    no arquivo HISTORIA.txt

    4° Se você usar opção de contar somente as 
    linhas que tenham a palavra "litoral", quantas 
    vezes ela aparece?

    5° No arquivo HISTORIA.txt quantas virgulas tem 
    no total?

    A soma de todos os 05 resultados é o código para o arquivo
    "chave.txt". E ai, qual é o código?
    
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

    "
else
  if [[ -d "$dirfrom" ]]; then
    mv "$dirfrom/chave.txt" $dirto 2>/dev/null
    mv "$dirfrom/HISTORIA.txt" $dirto 2>/dev/null
    mv "$dirfrom/instrução.txt" $dirto 2>/dev/null
    echo "$sub" | sudo -S chown root:root $dirto/HISTORIA.txt

    echo "true" > $engine_out/5/loaded.txt
    clear 
    pwdd
  else
    clear
  fi
fi