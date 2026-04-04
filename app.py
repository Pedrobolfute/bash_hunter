from flask import Flask, redirect, request, abort, make_response
from werkzeug.middleware.proxy_fix import ProxyFix
import subprocess
import threading
import time
import uuid

app = Flask(__name__)

app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1)

PORT_RANGE = list(range(10000, 10101))
used_ports = set()
sessions = {}


def get_free_port():
    for port in PORT_RANGE:
        if port not in used_ports:
            used_ports.add(port)
            return port
    return None

def monitor_container(container_id, port, session_id):
    time.sleep(5)
    while True:
        # Verifica se o ID específico ainda está rodando
        result = subprocess.run(
          ["docker", "inspect", "-f", "{{.State.Running}}", container_id],
          capture_output=True,
          text=True
          )
        
        if "true" not in result.stdout.lower():
            used_ports.discard(port)
            sessions.pop(session_id, None)
            print(f"[FREE] Porta {port} liberada (Sessão: {session_id})")
            break
        time.sleep(5)

@app.route("/")
def index():
    port = get_free_port()

    if not port:
        return "Servidor cheio (100 players ativos)", 503
    
    session_id = uuid.uuid4().hex[:8]

    container_name = f"player_{session_id}"

    subprocess.run(
        ["docker", "rm", "-f", container_name],
        stderr=subprocess.DEVNULL
    )
    
    process = subprocess.run([
        "docker", "run", "-d",
        "-p", f"{port}:7681",
        "--name", container_name,
        "--rm",
        "--memory=48m",
        "--memory-swap=64m",
        "--cpus=0.5",
        "bash_hunter_image",
        "ttyd", "-o", "-p", "7681", "-W", 
        "-b", f"/play/{session_id}", "bash",
        "/home/jogador/bash_hunter/.engine/init_game.sh"
    ], capture_output=True, text=True)
    
    container_id = process.stdout.strip()
    
    if process.returncode != 0 or not container_id:
        used_ports.discard(port)
        print(f"ERRO DOCKER: {process.stderr}")
        return "Erro ao criar ambiente", 500
    
    sessions[session_id] = port
    
    threading.Thread(
      target=monitor_container,
      args=(container_id, port, session_id),
      daemon=True
    ).start()

    # return redirect(f"http://18.216.2.131/play/{session_id}/")
    return redirect(f"/play/{session_id}/")

  
@app.route("/play/<session_id>/")
def play(session_id):
    port = sessions.get(session_id)

    if not port:
        return "Sessão inválida ou expirada", 404

    # NÃO redireciona — deixa o NGINX decidir
    response = make_response("Redirecting to container", 418)

    # envia a porta como header interno
    response.headers["X-Container-Port"] = str(port)

    return response
    

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)