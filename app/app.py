import os
import socket

import redis
from flask import Flask

app = Flask(__name__)

# Configuirações do Redis
REDIS_HOST = os.environ.get('REDIS_HOST', "redis")
REDIS_PASSWORD = os.environ.get("REDIS_PASSWORD")
AMBIENTE = os.environ.get("AMBIENTE", "dev")
NOME_REPLICA = os.environ.get("NOME_REPLICA", socket.gethostname())

cache = redis.Redis(host=REDIS_HOST, port=6379, password=REDIS_PASSWORD)

@app.route("/")
def index():
    visitas = cache.incr("visitas")
    return f"""
    <html>
        <body style="font-family: sans-serif; text-align: center; margin-top: 15%;">
            <h1>Contador de Visitas</h1>
            <p style="font-size: 3em;">{visitas}</p>
            <p>Atendido por: <strong>{NOME_REPLICA}</strong></p>
            <p>Ambiente: <strong>{AMBIENTE}</strong></p>
        </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)