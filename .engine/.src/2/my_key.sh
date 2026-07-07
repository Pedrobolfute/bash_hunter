#!/bin/bash

secret=""
sss=""
msg1="
Acesso liberado para o room_03, volte umas
pastas e vá para o próximo nível (room_03).
Use a senha desse room_02 para abrir room_03.

"
msg2="
Acesso negado para o room_03, Algo deu errado
entre room_02 e room_03. Tente novamente ou
reinicie o jogo.

"

if [[ -z "$my_base_dir" ]]; then
    echo "
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

❌ Diretório bash_hunter não encontrado em $HOME.

▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

"
    return 1
fi

terminal_me_deus="$play_dir/room_02/baia_de_todos_os_santos/oeste/noroeste/noroeste/norte/norte/oeste/noroeste/norte/leste"

if [[ "$PWD" != "$terminal_me_deus" ]]; then
    echo "
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

⚠️ Você só pode pegar a senha dentro do Terminal Marítimo Madre de Deus.

▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

"
    return 1
fi

touch "$my_base_dir/.engine/.out/2/key.txt"

if [[ -f "$my_base_dir/.engine/.out/2/key.txt" ]]; then
  dec(){
    local in="rezikev"
    echo "$in" | tr 'e-za-de-za-d' 'a-za-z'
  }

  echo $(dec) > "$my_base_dir/.engine/.out/2/key.txt"
  secret=$(head -n -0 "$my_base_dir/.engine/.out/2/key.txt")
  sss="
⚠️ A chave da sala room_02 é: $secret
  "
else
  secret=""
  sss="
⚠️ Algo deu errado ao tentar completar a sala room_02!.
"
msg1=$msg2
fi

decr(){
  local in="evmwi"
  echo "$in" | tr 'e-za-de-za-d' 'a-za-z'
}
sub=$(decr)
echo "$sub" | sudo -S mv "/usr/bin/sos" "/usr/bin/bkp_sos" > /dev/null 2>&1
echo "$sub" | sudo -S mv "/usr/bin/limbo_sos" "/usr/bin/sos" > /dev/null 2>&1
echo "$sub" | sudo -S mv "$my_base_dir/.engine/.out/3/wlcr3" "/usr/bin" >/dev/null 2>&1
sleep 0.5

pwdd_02(){
  local mensagem="
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

$msg1

$sss
▄ ▄▖▄▖▖▖  ▖▖▖▖▖ ▖▄▖▄▖▄▖
▙▘▌▌▚ ▙▌  ▙▌▌▌▛▖▌▐ ▙▖▙▘
▙▘▛▌▄▌▌▌  ▌▌▙▌▌▝▌▐ ▙▖▌▌

"

  if command -v whiptail >/dev/null 2>&1; then
    whiptail --title "🏴‍☠️ BASH HUNTER ⚓" --msgbox "$mensagem." 25 80
  else
    echo -e "$mensagem."
  fi
}

clear
pwdd_02
wlcr3 "go_to_room_03"