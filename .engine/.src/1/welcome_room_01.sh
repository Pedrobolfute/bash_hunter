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
                       "

echo "Use o comando \"cd NOME_DA_PASTA\" para entrar em pastas"
echo "Use o comando \"cd ..\" para voltar uma pasta atrás"
echo "Use o comando \"pwd\" para ver a pasta que você está"
echo "Use o comando \"ls\" para ver as pastas e arquivos "
echo "Use o comando \"cat NOME_DO_ARQUIVO_DE_TEXTO\" para ver conteúdo de um arquivo."
echo "Use o comando \"source ARQUIVO.sh\" para carregar funcionalidades em arquivos \".sh\". Mas use-o com cuidado!"

echo -e "
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌
                       "