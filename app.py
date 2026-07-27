from flask import Flask, jsonify, render_template
from werkzeug.middleware.proxy_fix import ProxyFix
import subprocess
import threading
import time
import socket

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1)

PORT_RANGE = list(range(10000, 10101))
used_ports = set()
ports_lock = threading.Lock()

def sync_ports_with_docker():
    global used_ports
    result = subprocess.run(
      ["docker", "ps", "--format", "{{.Names}}"],
      capture_output=True, text=True
    )
    names = result.stdout.splitlines()
    for name in names:
      if name.startswith("player_"):
        try:
          port = int(name.split("_")[1])
          used_ports.add(port)
          threading.Thread(target=monitor_container, args=(name, port), daemon=True).start()
        except ValueError:
          continue
    

def get_free_port():
  with ports_lock:
    for port in PORT_RANGE:
        if port not in used_ports:
            used_ports.add(port)
            return port
  return None
  

def wait_for_port(port, timeout=10):
    start = time.time()
    
    while time.time() - start < timeout:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
          sock.settimeout(1)
          
          if sock.connect_ex(("127.0.0.1", port)) == 0:
              return True
        time.sleep(0.5)
    return False

def monitor_container(container_name, port):
  subprocess.run(["docker", "wait", container_name], capture_output=True)
  
  with ports_lock:
    used_ports.discard(port)
  print(f"[FREE] Porta {port} liberada", flush=True)


@app.route("/")
def index():
    return render_template("index.html")

@app.route("/spawn", methods=["POST"])
def spawn_container():
    port = get_free_port()

    if not port:
        return jsonify({"success": False, "error":"Servidor cheio (100 players ativos)"}), 503

    container_name = f"player_{port}"

    cmd = [
      "docker", "run", "-d",
        "-p", f"{port}:7681",
        "--name", container_name,
        "--rm",
        "--memory=48m",
        "--memory-swap=64m",
        "--cpus=0.5",
        "bash_hunter_image",
        "timeout", "120m",
        "ttyd", "-p", "7681", "-o", "-W",
        "-t", "fontSize=14",
        "-b", f"/play/{port}",
        "/home/jogador/bash_hunter/.engine/init_game.sh"
    ]
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            raise Exception(f"Docker run falhou: {result.stderr.strip()}")

        print(f"[OCUPADA] Porta {port} alocada para o container {container_name}", flush=True)

        threading.Thread(
            target=monitor_container,
            args=(container_name, port),
            daemon=True
        ).start()

        if wait_for_port(port):
            return jsonify({
                "success": True,
                "url": f"https://bashhunter.com.br/play/{port}/"
            })
        else:
            subprocess.run(["docker", "stop", container_name], capture_output=True)
            return jsonify({"success": False, "error": "Erro ao criar container (Porta possivelmente presa no Docker)"}), 500

    except Exception as e:
        print(f"[ERRO] {e}", flush=True)
        with ports_lock:
            used_ports.discard(port)
        return jsonify({"success": False, "error": "Erro interno ao iniciar container"}), 500

if __name__ == "__main__":
    sync_ports_with_docker()
    app.run(host="0.0.0.0", port=8080)