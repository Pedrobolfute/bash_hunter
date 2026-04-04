from flask import Flask, jsonify
import docker
import uuid
import time
import threading

app = Flask(__name__)
client = docker.from_env()

sessions = {}  # session_id -> {container_id, port, last_seen}

PORT_RANGE = list(range(10000, 10100))


def get_free_port():
    used = {s["port"] for s in sessions.values()}
    for p in PORT_RANGE:
        if p not in used:
            return p
    return None


@app.route("/play")
def play():
    port = get_free_port()

    if not port:
        return jsonify({"error": "Servidor cheio"}), 503

    session_id = str(uuid.uuid4())[:8]

    container = client.containers.run(
        "bash_hunter_image",
        detach=True,
        ports={"7681/tcp": port},
        name=f"player_{session_id}",
        remove=True
    )

    sessions[session_id] = {
        "container_id": container.id,
        "port": port,
        "last_seen": time.time()
    }

    return jsonify({
        "session": session_id,
        "url": f"http://SEU_IP:{port}"
    })


@app.route("/ping/<session_id>")
def ping(session_id):
    if session_id in sessions:
        sessions[session_id]["last_seen"] = time.time()
        return "ok"
    return "not found", 404


def cleaner():
    while True:
        time.sleep(30)

        now = time.time()

        for session_id in list(sessions.keys()):
            session = sessions[session_id]

            # timeout de 2 minutos sem ping
            if now - session["last_seen"] > 120:
                try:
                    container = client.containers.get(session["container_id"])
                    container.stop()
                except:
                    pass

                del sessions[session_id]
                print(f"[CLEAN] sessão {session_id} removida")


threading.Thread(target=cleaner, daemon=True).start()


app.run(host="0.0.0.0", port=8080)