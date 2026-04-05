#!/bin/bash

welcome_room_01(){
  local mensagem="

▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌
                       

🪶 SOBRE O JOGO

Bash Hunter é uma jornada dentro do seu próprio terminal Linux!
Você explorará diretórios, encontrará personagens, decifrará pistas
e navegará por mares digitais em busca de novos destinos.

Cada *room* representa uma nova etapa da sua aventura.

Você começa na Room 01, nos portos da Baía de Todos os Santos,
em Salvador - BA. Mas cuidado, marujo — nem todo barco é capaz
de atravessar o oceano!

------------------------------------------------------------

🪶 INSTRUÇÕES

💀 O jogo é composto por 'rooms' (salas).
🔑 Cada sala tem uma chave (key) que permite seguir para a próxima.
📜 Anote todas as chaves que encontrar — elas serão essenciais
para abrir baús e avançar na jornada!

Boa sorte, marujo! Que os ventos estejam a seu favor!"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BEM-VINDO AO BASH HUNTER ⚓" --msgbox "$mensagem" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

welcome_room_01

clear

echo -e "
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

=== GUIA RÁPIDO ===

Use estes comandos para explorar o sistema:

[1] ENTRAR EM UMA PASTA
cd nome_da_pasta

[2] VOLTAR UMA PASTA
cd ..

[3] VER ONDE VOCÊ ESTÁ
pwd

[4] VER ARQUIVOS E PASTAS
ls

[5] LER UM ARQUIVO
cat arquivo.txt

[6] ATIVAR UM SCRIPT
source arquivo.sh

▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌


                       "