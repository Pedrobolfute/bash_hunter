import subprocess
import time
import socket
import secrets
import threading
from flask import Flask, render_template_string, request

app = Flask(__name__)

# --- CONFIGURAÇÕES DO AMBIENTE ---
# IP Público da sua instância AWS no Debian
# PUBLIC_IP = "3.14.27.130"
# Intervalo de portas liberado no Security Group da AWS
PORT_RANGE = range(10000, 10100)
# Nome da imagem Docker que você buildou na branch stage
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
        # Remove containers com o prefixo do jogo criados há algum tempo
        subprocess.run("sudo docker ps -q --filter 'name=bh_' | xargs -r sudo docker stop", shell=True)
        time.sleep(10800) # Executa a limpeza a cada 3 hora

@app.route('/')
def index():
    current_ip = request.host.split(':')[0]
    
    port = find_free_port()
    if not port:
        return "<h1>Servidor Lotado!</h1><p>Não há portas disponíveis no momento.</p>", 503

    # Gera um token de acesso único para garantir a privacidade do aluno
    token = secrets.token_hex(3) 
    container_name = f"bh_{port}_{token}"
    
    # COMANDO DOCKER ATUALIZADO:
    # -o: ttyd encerra após uma conexão (reset automático ao fechar aba)
    # -c: exige usuário:senha para evitar 'port jumping' entre alunos
    docker_cmd = [
        "sudo", "docker", "run", "-d",
        "--name", container_name,
        "-p", f"{port}:7681",
        "--memory", "128m",  # Proteção de recursos da AWS
        "--cpus", "0.2",     # Proteção de processamento
        "--rm",              # Remove o container automaticamente ao parar
        DOCKER_IMAGE,
        "ttyd", "-o", "-t", "1", "-c", f"jogador:{token}", "-p", "7681", "-W", "/home/jogador/bash_hunter/.engine/init_game.sh"
    ]
    
    try:
        subprocess.run(docker_cmd, check=True)
        time.sleep(3) # Tempo para o ttyd iniciar na AWS
        
        terminal_url = f"http://jogador:{token}@{current_ip}:{port}"
        
        # Página de boas-vindas com as credenciais da sala
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