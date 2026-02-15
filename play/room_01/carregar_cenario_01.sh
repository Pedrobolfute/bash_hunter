#!/bin/bash
echo -n "Carregando "
find "$HOME" -type d -name "bash_hunter" -print -quit > result.txt 2>/dev/null & 
PID=$!
while kill -0 $PID 2>/dev/null; do
    echo -n "."
    sleep 0.5
done
echo " Bem-vindo!"
my_base_dir=$(cat resultado.txt)


source $my_base_dir/.engine/.src/1/load_room_01.sh
source $my_base_dir/.engine/.src/1/welcome_room_01.sh