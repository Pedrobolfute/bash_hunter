import subprocess
import time
import socket
import secrets
import threading
from flask import Flask, render_template_string

app = Flask(__name__)

# --- CONFIGURAÇÕES DO AMBIENTE ---
# IP Público da sua instância AWS no Debian
PUBLIC_IP = "3.145.193.137" 
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
    """Limpa containers que possam ter ficado travados por erro de rede."""
    while True:
        # Remove containers com o prefixo do jogo criados há algum tempo
        subprocess.run("sudo docker ps -q --filter 'name=bh_' | xargs -r sudo docker stop", shell=True)
        time.sleep(3600) # Executa a limpeza a cada 1 hora

@app.route('/')
def index():
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
        "ttyd", "-o", "-c", f"jogador:{token}", "-p", "7681", "-W", "/home/jogador/bash_hunter/init_game.sh"
    ]
    
    try:
        subprocess.run(docker_cmd, check=True)
        time.sleep(1.5) # Tempo para o ttyd iniciar na AWS
        
        # Página de boas-vindas com as credenciais da sala
        return render_template_string("""
            <div style="font-family: sans-serif; text-align: center; margin-top: 50px;">
                <h1>⚓ Bem-vindo ao Bash Hunter! ⚓</h1>
                <p>Sua sala de treinamento foi preparada, Pedro.</p>
                <div style="background: #f4f4f4; border: 1px solid #ccc; display: inline-block; padding: 20px; border-radius: 10px;">
                    <p><strong>URL de Acesso:</strong> <a href="http://{{ ip }}:{{ port }}" target="_blank">http://{{ ip }}:{{ port }}</a></p>
                    <p><strong>Usuário:</strong> <code style="font-size: 1.2em;">jogador</code></p>
                    <p><strong>Token (Senha):</strong> <code style="font-size: 1.5em; color: #d9534f;">{{ token }}</code></p>
                </div>
                <p style="color: #666; margin-top: 20px;">
                    <i>Atenção: Se você fechar a aba ou atualizar a página, seu progresso será perdido e o container destruído.</i>
                </p>
            </div>
        """, ip=PUBLIC_IP, port=port, token=token)
        
    except subprocess.CalledProcessError:
        return "<h1>Erro ao iniciar o container.</h1><p>Verifique os logs do sistema.</p>", 500

if __name__ == '__main__':
    # Inicia a thread de limpeza em segundo plano
    threading.Thread(target=cleanup_zombies, daemon=True).start()
    
    # Roda na porta 80 para facilitar o acesso dos alunos sem precisar digitar porta na URL
    app.run(host='0.0.0.0', port=80)
