#!/bin/bash
echo "Carregando room_01..."

if [[ -z "$my_base_dir" ]]; then
  echo "❌ Erro: diretório 'bash_hunter' não encontrado."
  return 1
fi

if [[ -f "$engine_out/1/loaded.txt" ]]; then
  echo "⚠️ O jogo já foi carregado anteriormente!"
  return 1
fi

engine_out="$engine_out" 
engine_src="$engine_src/"
play_dir="$my_base_dir/play"

echo $(wc -l < "$HOME/.bashrc") >> "$engine_out/1/.bashrc_line"
original_bash_line=$(head -n 1 "$engine_out/1/.bashrc_line")
original_bash=$(head -n "$original_bash_line" "$HOME/.bashrc")

echo -e "\n###BASH_HUNTER AREA###" >> $HOME/.bashrc
echo -e "my_base_dir=\"$my_base_dir\"" >> $HOME/.bashrc
echo -e "engine_out=\"$engine_out\"" >> $HOME/.bashrc
echo -e "engine_src=\"$engine_src\"" >> $HOME/.bashrc
echo -e "play_dir=\"$my_base_dir/play\"" >> $HOME/.bashrc

cat <<'EOF' >> $HOME/.bashrc
# escolher_start
escolher() {
    if [[ -z "$my_base_dir" ]]; then
        echo "❌ Diretório bash_hunter não encontrado em $HOME."
        return 1
    fi

    local allowed_base="$my_base_dir/play/room_01/para_o_mar/senhor_do_bonfim/feira_de_santana/salvador/terminal_nautico_de_salvador/Barcos"
    local output_file="$engine_out/1/choosed_boat.txt"
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

    local output_file="$engine_out/1/choosed_boat.txt"
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

    local out_dir="$engine_out/1"
    local choosed_boat_file="$out_dir/choosed_boat.txt"
    local room2_dir="$my_base_dir/play/room_02"
    local current_dir_name
    current_dir_name=$(basename "$PWD")

    local ald=("veleiro" "caravela" "goleta")

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
        echo "içar_âncora" > "$engine_out/1/key.txt"
        echo "true" > "$engine_out/1/finished.txt"

        echo "🌊 Você agora está Iniciando sua jornada, marujo! 🌊"
        echo "🌊 Essa é a BAIA DE TODOS OS SANTOS! Vá ao mar.   🌊"
        sleep 2s
        source "$engine_src/2/welcome_room_02.sh"
    else
        echo "❌ A sala ROOM_2 não foi encontrada em: $room2_dir"
        return 1
    fi
}
#zarpar_end

# delete_game_start
delete_game() {
  echo "⚠️ Deseja realmente deletar o jogo? (s/n)"
  read -r confirm

  if [[ "$confirm" != "s" && "$confirm" != "S" ]]; then
      echo "❎ Operação cancelada."
      return 0
  fi

  echo "🧰 Restaurando .bashrc original..."

  if [[ -n "$original_bash" && -n "$original_bash_line" ]]; then
      echo "$original_bash" > "$HOME/.bashrc"
      echo "✅ .bashrc restaurado com sucesso!"
  elif [[ -f "$engine_out/1/.bashrc_line" ]]; then
      original_bash_line=$(head -n 1 "$engine_out/1/.bashrc_line")
      head -n "$original_bash_line" "$HOME/.bashrc" > "$HOME/.bashrc"
      echo "✅ .bashrc restaurado parcialmente."
  else
      echo "⚠️ Backup de .bashrc não encontrado. O arquivo não foi restaurado."
  fi

  echo "🗑️ Removendo diretório do jogo..."
  if [[ -d "$my_base_dir" ]]; then
      rm -rf "$my_base_dir"
  fi

  # Recarrega o bash original
  source "$HOME/.bashrc"

  # Remove funções do ambiente atual
  unset -f delete_game 2>/dev/null
  unset -f zarpar 2>/dev/null
  unset -f escolher 2>/dev/null
  unset -f meu_barco 2>/dev/null

  echo "✅ Jogo removido com sucesso!"
}
# delete_game_end

# bash_hunter_protection_start
unalias cd ls cat 2>/dev/null 

engine_protected="$my_base_dir/engine"
play_dir="$my_base_dir/play"

is_engine_path() {
    local target_path="$1"
    local resolved_path=""
    
    resolved_path=$(readlink -f "$target_path" 2>/dev/null)
    
    if [[ -z "$resolved_path" ]]; then
        return 1
    fi

    [[ "$resolved_path" == "$engine_protected"* ]]
}

ls() {
    if [[ $# -eq 0 ]]; then
        if is_engine_path "."; then
            echo "🚫 Você não pode listar dentro da área de engenharia."
            return 1
        fi
        
        command ls --color=auto
        return
    fi

    for arg in "$@"; do
        if is_engine_path "$arg"; then
            echo "🚫 Você não tem permissão para listar a área de engenharia através do argumento: $arg"
            return 1
        fi
    done

    command ls --color=auto "$@"
}

cat() {
    for arg in "$@"; do
        if is_engine_path "$arg"; then
            echo "🚫 Você não pode ler arquivos da área de engenharia."
            return 1
        fi
    done

    command cat "$@"
}
# bash_hunter_protection_end

EOF

source $HOME/.bashrc
cd $play_dir/room_01/para_o_mar

echo "true" > $engine_out/1/loaded.txt