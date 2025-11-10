#!/bin/bash
my_base_dir=$(find "$HOME" -type d -name "bash_hunter" -print -quit 2>/dev/null)
secret=""
sss=""

if [[ -s "$my_base_dir/engine/out/1/key.txt" ]]; then
  secret=$(cat "$my_base_dir/engine/out/1/key.txt")
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
                       

🪶 Bem vindo a fase 02 (room_02)!

Marujo, parece fácil navegar, mas você ainda nem
chegou ao mar aberto. Dentro da BAIA DE TODOS OS
SANTOS você tem que aprender a navegar direito e 
usar alguns recursos do barco.

"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BEM-VINDO AO BASH HUNTER ⚓" --msgbox "$mensagem $sss" 25 80
  else
    echo -e "\n$mensagem\n"
  fi
}

welcome

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