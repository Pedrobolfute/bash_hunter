from flask import Flask, redirect
from werkzeug.middleware.proxy_fix import ProxyFix
import subprocess
import random
import threading
import time

app = Flask(__name__)

app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1)

PORT_RANGE = list(range(10000, 10101))
used_ports = set()


def get_free_port():
    for port in PORT_RANGE:
        if port not in used_ports:
            used_ports.add(port)
            return port
    return None
  
import socket
import time

def wait_for_port(port, timeout=10):
    start = time.time()
    
    while time.time() - start < timeout:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            result = sock.connect_ex(("127.0.0.1", port))
            if result == 0:
                return True
        time.sleep(0.2)
    
    return False

def monitor_container(container_name, port):
    time.sleep(2)
  
    while True:
        result = subprocess.run(
            ["docker", "ps", "-q", "-f", f"name={container_name}"],
            capture_output=True,
            text=True
        )

        if not result.stdout.strip():
            # container morreu
            used_ports.discard(port)
            print(f"[FREE] Porta {port} liberada", flush=True)
            break

        time.sleep(2)

@app.route("/")
def index():
    port = get_free_port()

    if not port:
        return "Servidor cheio (100 players ativos)", 503

    container_name = f"player_{port}"

    subprocess.Popen([
        "docker", "run", "-d",
        "-p", f"{port}:7681",
        "--name", container_name,
        "--rm",
        "--memory=48m",
        "--memory-swap=64m",
        "--cpus=0.5",
        "bash_hunter_image",
        "timeout", "120m",
        "ttyd", "-o", "-p", "7681", "-W", 
        "-b", f"/play/{port}",
        "/home/jogador/bash_hunter/.engine/init_game.sh"
    ])
    
    threading.Thread(
      target=monitor_container,
      args=(container_name, port),
      daemon=True
    ).start()

    if not wait_for_port(port):
        return "Erro ao iniciar sessão", 500

    return redirect(f"http://bashhunter.com.br/play/{port}/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)