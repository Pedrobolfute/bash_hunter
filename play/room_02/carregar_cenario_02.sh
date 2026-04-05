echo "Iniciando..."

if ! source "$engine_src/2/load_room_02.sh" 2>/dev/null; then
    echo "Erro ao carregar room_02."
    echo "Por hora, recarregue o jogo apertando ctrl + f5"
fi