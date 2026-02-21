from flask import Flask, redirect
import subprocess
import time
import socket

app = Flask(__name__)

# Configurações
PUBLIC_IP = "3.145.193.137"
PORT_RANGE = range(10000, 10100)

def find_free_port():
    for port in PORT_RANGE:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            if s.connect_ex(('localhost', port)) != 0:
                return port
    return None

@app.route('/')
def start_session():
    port = find_free_port()
    if not port:
        return "Servidor lotado! Tente novamente em breve.", 503

    container_name = f"session_{port}"
    
    # Inicia o container efêmero
    # --rm apaga o container assim que o ttyd para
    subprocess.run([
        "sudo", "docker", "run", "-d",
        "--name", container_name,
        "-p", f"{port}:7681",
        "--rm",
        "bash_hunter_image"
    ])
    
    time.sleep(1.5) # Tempo para o ttyd subir
    return redirect(f"http://{PUBLIC_IP}:{port}")

if __name__ == '__main__':
    # Rodando na porta 80 para ser acessível por todos
    app.run(host='0.0.0.0', port=80)
