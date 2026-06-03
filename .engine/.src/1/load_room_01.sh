#!/bin/bash
echo "Carregando room_01..."

if [[ -z "$my_base_dir" ]]; then
  echo "❌ Erro: diretório 'bash_hunter' não encontrado."
  return 1
fi

if [[ -f "$my_base_dir/.engine/.out/1/loaded.txt" ]]; then
  echo "⚠️ O jogo já foi carregado anteriormente!"
  return 1
fi

echo $(wc -l < "$HOME/.bashrc") >> "$my_base_dir/.engine/.out/1/.bashrc_line"
original_bash_line=$(head -n 1 "$my_base_dir/.engine/.out/1/.bashrc_line")
original_bash=$(head -n "$original_bash_line" "$HOME/.bashrc")

echo -e "\n###BASH_HUNTER AREA###" >> $HOME/.bashrc
echo -e "my_base_dir=\"$my_base_dir\"" >> $HOME/.bashrc
echo -e "engine_out=\"$my_base_dir/.engine/.out\"" >> $HOME/.bashrc
echo -e "engine_src=\"$my_base_dir/.engine/.src\"" >> $HOME/.bashrc
echo -e "play_dir=\"$my_base_dir/play\"" >> $HOME/.bashrc

cat <<'EOF' >> $HOME/.bashrc
# escolher_start
escolher() {
    if [[ -z "$my_base_dir" ]]; then
        echo "❌ Diretório bash_hunter não encontrado em $HOME."
        return 1
    fi

    local allowed_base="$my_base_dir/play/room_01/para_o_mar/senhor_do_bonfim/feira_de_santana/salvador/terminal_nautico_de_salvador/Barcos"
    local output_file="$my_base_dir/.engine/.out/1/choosed_boat.txt"
    local current_dir
    current_dir=$(pwd)

    if [[ $current_dir == $allowed_base/* ]]; then
        local boat_name
        boat_name=$(basename "$current_dir")

        echo "$boat_name" > "$output_file"
        echo "⛵ Barco escolhido: $boat_name"
    else
        echo "❌ O comando 'escolher' só pode ser usado dentro de um barco."
        echo "   Entre dentro de um barco."
    fi
}
# escolher_end

# meu_barco_start
meu_barco() { 
    if [[ -z "$my_base_dir" ]]; then
        echo "❌ Diretório bash_hunter não encontrado em $HOME"
        return 1
    fi

    local output_file="$my_base_dir/.engine/.out/1/choosed_boat.txt"
    if [[ -f "$output_file" ]]; then
      if [[ $(wc -c < "$output_file") -le 1 ]]; then
          echo "você ainda não escolheu um barco." 
          echo "Entre dentro do barco e use o comando \"escolher\"."
      else
        head -n -0 $output_file
      fi
    else
          echo "você ainda não escolheu um barco." 
          echo "Entre dentro do barco e use o comando \"escolher\"."
    fi
}
# meu_barco_end

#zarpar_start
zarpar() {

    if [[ -z "$my_base_dir" ]]; then
        echo "❌ Diretório bash_hunter não encontrado em $HOME."
        return 1
    fi

    local out_dir="$my_base_dir/.engine/.out/1"
    local choosed_boat_file="$out_dir/choosed_boat.txt"
    local room2_dir="$my_base_dir/play/room_02"
    local current_dir_name
    current_dir_name=$(basename "$PWD")

    local ald=( "caravela" )

    if [[ ! -f "$choosed_boat_file" ]]; then
        echo "⚠️ Você ainda não escolheu um barco. Use o comando 'escolher' primeiro."
        return 1
    else
      if [[ $(wc -c < "$choosed_boat_file") -le 1 ]]; then
              echo "você ainda não escolheu um barco." 
              echo "Entre dentro do barco e use o comando \"escolher\"."
              return 1
      fi
    fi

    local current_boat
    current_boat=$(head -n -0 "$choosed_boat_file")

    if [[ "$current_dir_name" != "$current_boat" ]]; then
        echo "⚠️ Você só pode zarpar de dentro do barco '$current_boat'."
        return 1
    fi

    local alld=false
    for boat in "${ald[@]}"; do
        if [[ "$current_boat" == "$boat" ]]; then
            alld=true
            break
        else
          alld=false
        fi
    done

    if [[ $alld == false ]]; then
        echo "🚫 O barco '$current_boat' não é adequado ou não está disponível para atravesar o oceano."
        echo "Escolha outro, marujo!"
        return 1
    fi

    if [[ -d "$room2_dir" ]]; then
        echo "🧭 Navegando para ROOM_2..."
        sleep 1s
        cd "$room2_dir" || { echo "❌ Erro ao navegar!"; return 1; }
        echo "içar_âncora" > "$my_base_dir/.engine/.out/1/key.txt"
        echo "true" > "$engine_out/1/finished.txt"

        echo "🌊 Você agora está Iniciando sua jornada, marujo! 🌊"
        echo "🌊 Essa é a BAIA DE TODOS OS SANTOS! Vá ao mar.   🌊"
        sleep 3s
        source "$my_base_dir/.engine/.src/2/welcome_room_02.sh"
    else
        echo "❌ A sala ROOM_2 não foi encontrada em: $room2_dir"
        return 1
    fi
}
#zarpar_end

EOF

source $HOME/.bashrc

decr(){
  local in="evmwi"
  echo "$in" | tr 'e-za-de-za-d' 'a-za-z'
}
sub=$(decr)
echo "$sub" | sudo -S mv "$my_base_dir/.engine/.out/1/mapa" "/bin" 
echo "$sub" | sudo -S mv "$my_base_dir/.engine/.out/1/sos" "/bin"
echo "$sub" | find . -type f -name "$my_base_dir/play/*.txt" -exec sudo -S chown root:jogador {} + 


echo "true" > $my_base_dir/.engine/.out/1/loaded.txt

## obs: tentar optar sempre por usar a variavel my_base_dir. Porque mesmo carregada o engine_out bo bashrc, ela não carrega.