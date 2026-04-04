from flask import Flask, redirect
import subprocess
import random

app = Flask(__name__)

PORT_RANGE = list(range(10000, 10101))
used_ports = set()


def get_free_port():
    for port in PORT_RANGE:
        if port not in used_ports:
            used_ports.add(port)
            return port
    return None


@app.route("/")
def index():
    port = get_free_port()

    if not port:
        return "Servidor cheio (100 players ativos)", 503

    container_name = f"player_{port}"

    # roda container
    subprocess.Popen([
        "docker", "run", "-d",
        "-p", f"{port}:7681",
        "--name", container_name,
        "--rm",
        "bash_hunter_image"
    ])

    # redireciona jogador
    return redirect(f"http://SEU_IP:{port}")
    

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)