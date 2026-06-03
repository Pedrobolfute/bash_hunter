#!/bin/bash

welcome_room_01(){
  local mensagem="

▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌
                       

🪶 SOBRE O JOGO

Bash Hunter é uma jornada dentro do seu próprio terminal Linux!
Você explorará pastas, decifrará pistas e navegará por mares 
digitais em busca de novos destinos.

Cada *room* representa uma nova etapa da sua aventura.

Você começa o jogo nas proximidades da cidade de Senhor do Bonfim - BA, 
e o seu primeiro objetivo é seguir de cidade em cidade até chegar 
nos portos da Baía de Todos os Santos, em Salvador - BA.


------------------------------------------------------------


🪶 INSTRUÇÕES

💀 O jogo é composto por 'rooms' (salas).
🔑 Cada sala tem uma chave (key) que permite seguir para a próxima.
📜 Anote todas as chaves que encontrar — elas serão essenciais
para abrir baús e avançar na jornada!

Boa sorte, marujo! Que os ventos estejam a seu favor!"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BEM-VINDO AO BASH HUNTER ⚓" --textbox "$mensagem" 25 80
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

VOCÊ ESTÁ NA ÁREA DE INSTRUÇÕES DO JOGO!

PARA LER AS INSTRUÇÕES, DIGITE:

cat instrução.txt

O COMANDO "cat" EXIBE O CONTEÚDO DE UM ARQUIVO
DIRETAMENTE NO TERMINAL.

"instrução.txt" É O ARQUIVO QUE CONTÉM AS
ORIENTAÇÕES PARA CONTINUAR O JOGO.

LEIA O CONTEÚDO DO ARQUIVO E SIGA AS PRÓXIMAS
INSTRUÇÕES PARA CONTINUAR SUA JORNADA.

▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌
                       "