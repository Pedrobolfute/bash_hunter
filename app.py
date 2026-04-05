from flask import Flask, redirect, request, make_response
from werkzeug.middleware.proxy_fix import ProxyFix
import subprocess
import threading
import time
import uuid
import logging

app = Flask(__name__)

# Configura o Flask para confiar nos cabeçalhos do Nginx (Essencial para o IP Real)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1)

# Desativa o log padrão para criarmos um que mostre o IP real do aluno
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

PORT_RANGE = list(range(10000, 10101))
used_ports = set()
sessions = {}

def sync_used_ports():
    """Verifica quais portas o Docker já está usando antes de começar"""
    global used_ports
    print("[SYNC] Verificando containers ativos...")
    result = subprocess.run(["docker", "ps", "--format", "{{.Ports}}"], capture_output=True, text=True)
    for line in result.stdout.split('\n'):
        if "0.0.0.0:" in line:
            try:
                # Extrai a porta (ex: 0.0.0.0:10000->7681/tcp)
                port = int(line.split(':')[1].split('->')[0])
                used_ports.add(port)
                print(f"[SYNC] Porta {port} já está ocupada pelo Docker.")
            except:
                pass

def get_free_port():
    for port in PORT_RANGE:
        if port not in used_ports:
            used_ports.add(port)
            return port
    return None

def monitor_container(container_id, port, session_id):
    time.sleep(5)
    while True:
        result = subprocess.run(
            ["docker", "inspect", "-f", "{{.State.Running}}", container_id],
            capture_output=True, text=True
        )
        if "true" not in result.stdout.lower():
            used_ports.discard(port)
            sessions.pop(session_id, None)
            print(f"[FREE] Porta {port} liberada (Sessão: {session_id})")
            break
        time.sleep(5)

@app.before_request
def log_request_info():
    # Isso fará o terminal mostrar o IP REAL do cliente em cada acesso
    print(f"[LOG] Cliente {request.remote_addr} acessou {request.path}")

@app.route("/")
def index():
    port = get_free_port()
    if not port:
        return "Servidor cheio", 503
    
    session_id = uuid.uuid4().hex[:8]
    container_name = f"player_{session_id}"

    # Garante que não existe container zumbi com esse nome
    subprocess.run(["docker", "rm", "-f", container_name], stderr=subprocess.DEVNULL)
    
    process = subprocess.run([
        "docker", "run", "-d",
        "-p", f"{port}:7681",
        "--name", container_name,
        "--rm",
        "--memory=48m",
        "bash_hunter_image",
        "ttyd", "-o", "-p", "7681", "-W", 
        "-b", f"/play/{session_id}",
        "bash", "/home/jogador/bash_hunter/.engine/init_game.sh"
    ], capture_output=True, text=True)
    
    container_id = process.stdout.strip()
    
    if process.returncode != 0:
        used_ports.discard(port)
        print(f"[ERRO DOCKER] {process.stderr}")
        return f"Erro ao criar ambiente: {process.stderr}", 500

    sessions[session_id] = port
    threading.Thread(target=monitor_container, args=(container_id, port, session_id), daemon=True).start()

    return redirect(f"/play/{session_id}/")

@app.route("/play/<session_id>/")
def play(session_id):
    port = sessions.get(session_id)
    if not port:
        return "Sessão inválida", 404

    # Gatilho para o Nginx interceptar
    response = make_response("OK", 418)
    response.headers["X-Container-Port"] = str(port)
    return response

if __name__ == "__main__":
    sync_used_ports() # Sincroniza antes de rodar o servidor
    app.run(host="0.0.0.0", port=8080)