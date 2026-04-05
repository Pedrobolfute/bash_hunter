#!/bin/bash
secret=""
sss=""

if [[ -s "$my_base_dir/.engine/.out/1/key.txt" ]]; then
  secret=$(head -n -0 "$my_base_dir/.engine/.out/1/key.txt")
  sss="A chave da sala room_01 era: $secret"
else
  secret=""
  sss=""
fi

welcome(){
  local mensagem="

▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌
                       

🪶 BEM-VINDO À FASE 02 (room_02)

Marujo...

Navegar parece fácil,
mas você ainda não chegou ao mar aberto.

Você está na Baía de Todos os Santos.

Aqui é o lugar para treinar.

Aprenda a navegar melhor
e a usar os recursos do seu barco.

"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BEM-VINDO AO BASH HUNTER ⚓" --msgbox "$mensagem$sss" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

clear
welcome



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