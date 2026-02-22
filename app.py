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
    if not port:
        return "Servidor lotado! Tente novamente em breve.", 503

    # Nome único para evitar conflitos de nomes no Docker
    container_name = f"bh_session_{port}_{int(time.time())}"
    
    # O comando Docker permanece o mesmo, mas o 'ttyd' lá dentro cuidará do fim
    docker_cmd = [
        "sudo", "docker", "run", "-d",
        "--name", container_name,
        "-p", f"{port}:7681",
        "--memory", "128m",
        "--cpus", "0.2",
        "--rm", # Chave para o reset: apaga tudo ao encerrar
        "bash_hunter_image"
    ]
    
    subprocess.run(docker_cmd)
    
    # Tempo para o terminal subir na AWS
    time.sleep(1.2)
    
    # Redireciona para o terminal efêmero
    return redirect(f"http://{PUBLIC_IP}:{port}")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
