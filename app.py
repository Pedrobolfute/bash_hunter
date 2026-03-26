import subprocess
import time
import socket
import secrets
import threading
from flask import Flask, render_template_string, request

app = Flask(__name__)

# --- CONFIGURAÇÕES ---
PORT_RANGE = range(10000, 10100)
DOCKER_IMAGE = "bash_hunter_image"

def is_port_in_use(port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        return s.connect_ex(('localhost', port)) == 0

def find_free_port():
    for port in PORT_RANGE:
        if not is_port_in_use(port):
            return port
    return None

def cleanup_zombies():
    while True:
        # Mata containers antigos que podem estar travando as portas
        subprocess.run("sudo docker ps -q --filter 'name=bh_' | xargs -r sudo docker stop", shell=True)
        time.sleep(3600)

@app.route('/')
def index():
    # Detecta o IP que o aluno usou para acessar o site automaticamente
    current_ip = request.host.split(':')[0]
    
    port = find_free_port()
    if not port:
        return "<h1>Servidor Lotado!</h1>", 503

    token = secrets.token_hex(3) 
    container_name = f"bh_{port}_{token}"
    
    docker_cmd = [
        "sudo", "docker", "run", "-d",
        "--name", container_name,
        "-p", f"{port}:7681",
        "--memory", "128m",
        "--cpus", "0.2",
        "--rm",
        DOCKER_IMAGE,
        "ttyd", "-o", "-t", "1", "-c", f"jogador:{token}", "-p", "7681", "-W", "/home/jogador/bash_hunter/.engine/init_game.sh"
    ]
    
    try:
        subprocess.run(docker_cmd, check=True)
        time.sleep(5) # Aumentado para 2s para dar tempo na AWS
        
        # Link com formato http://user:pass@ip:port para evitar o erro 401
        terminal_url = f"http://jogador:{token}@{current_ip}:{port}"
        
        return render_template_string("""
            <div style="font-family: sans-serif; text-align: center; margin-top: 50px;">
                <h1>⚓ Bem-vindo ao Bash Hunter! ⚓</h1>
                <div style="background: #f4f4f4; border: 1px solid #ccc; display: inline-block; padding: 20px; border-radius: 10px;">
                    <p>Sua sala privada está pronta na porta <b>{{ port }}</b>.</p>
                    <p><strong>Usuário:</strong> <code>jogador</code></p>
                    <p><strong>Token:</strong> <code style="color: #d9534f;">{{ token }}</code></p>
                    <br>
                    <a href="{{ url }}" target="_blank">
                        <button style="padding: 15px 30px; font-size: 1.2em; cursor: pointer; background: #007bff; color: white; border: none; border-radius: 5px;">
                            ENTRAR NO NAVIO
                        </button>
                    </a>
                </div>
                <p style="color: #666; margin-top: 20px;"><i>Se o terminal pedir login, use as credenciais acima.</i></p>
            </div>
        """, port=port, token=token, url=terminal_url)
        
    except Exception as e:
        return f"<h1>Erro: {e}</h1>", 500

if __name__ == '__main__':
    threading.Thread(target=cleanup_zombies, daemon=True).start()
    app.run(host='0.0.0.0', port=80)