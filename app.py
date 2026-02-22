import secrets
import threading
import subprocess
import time
import socket
from flask import Flask, redirect

app = Flask(__name__)

# Configurações do seu ambiente AWS
PUBLIC_IP = "3.145.193.137"
PORT_RANGE = range(10000, 10100)

def find_free_port():
    for port in PORT_RANGE:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            if s.connect_ex(('localhost', port)) != 0:
                return port
    return None

@app.route('/')
def start_game():
    port = find_free_port()
    # Gera um token aleatório de 6 caracteres
    token = secrets.token_hex(3) 
    
    container_name = f"bh_{port}_{token}"
    
    # Adicionamos a flag -c (credential) com usuário 'jogador' e a senha 'token'
    docker_cmd = [
        "sudo", "docker", "run", "-d",
        "--name", container_name,
        "-p", f"{port}:7681",
        "--rm",
        "bash_hunter_image",
        "ttyd", "-once", "-c", f"jogador:{token}", "-p", "7681", "-W", "/home/jogador/bash_hunter/init_game.sh"
    ]
    
    subprocess.run(docker_cmd)
    
    # Em vez de redirecionar direto, mostramos o Token para o aluno
    return f"""
    <h1>Bem-vindo ao Bash Hunter!</h1>
    <p>Sua sala privada foi criada na porta <b>{port}</b>.</p>
    <p>Seu Token de Acesso é: <b style='color:red; font-size:20px;'>{token}</b></p>
    <p>Usuário: <b>jogador</b></p>
    <br>
    <a href='http://3.145.193.137:{port}' target='_blank'>
        <button style='padding:10px 20px; cursor:pointer;'>CLIQUE AQUI PARA ENTRAR NO NAVIO</button>
    </a>
    <p><i>Atenção: Se fechar a aba ou der F5, o container será destruído e o progresso perdido!</i></p>
    """

def cleanup_zombies():
    while True:
        # Comando para listar containers criados há mais de 60 minutos e removê-los
        # Isso evita que sua AWS fique cheia de salas 'abandonadas'
        subprocess.run("sudo docker ps -q --filter 'name=bh_' | xargs -r docker stop", shell=True)
        time.sleep(3600) # Roda a cada 1 hora

# Inicia a limpeza em uma thread separada para não travar o site
threading.Thread(target=cleanup_zombies, daemon=True).start()
