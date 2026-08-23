# Musterlösung – Übung 1: Automatisierter Build mit GitHub Actions (CI)

**Ziel:** Eine CI-Pipeline, die bei jedem Push das Docker-Image der App baut und mit einem
Container-Test prüft.

Lauffähiger Code: [app.py](../app.py), [Dockerfile](../Dockerfile), [.github/workflows/aufgabe1.yml](../.github/workflows/aufgabe1.yml)

---

## 1. Anwendung (Flask)

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    """Simple hello world endpoint."""
    return 'Hello, World!', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
```

`requirements.txt`: `flask`

## 2. Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 8080
CMD ["python", "app.py"]
```

Erst `requirements.txt` kopieren und installieren, dann den Code — so nutzt Docker den
Layer-Cache und `pip install` läuft nur bei geänderten Abhängigkeiten neu.

## 3. Workflow `.github/workflows/aufgabe1.yml`

```yaml
name: CI Build
on:
  push:
    branches: [ "main" ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      - name: Build Docker Image
        uses: docker/build-push-action@v6
        with:
          context: .
          file: ./Dockerfile
          push: false
          load: true              # Image in den lokalen Docker laden ...
          tags: hello-docker-ci:latest
      - name: Run Container for Test
        run: |
          docker run -d --name test-container -p 8080:8080 hello-docker-ci:latest
          sleep 5
          curl -sf http://localhost:8080 | grep -q "Hello, World!"
          docker stop test-container
```

> **Wichtige Korrektur gegenüber der naiven Variante:** `build-push-action` mit `push: false`
> legt das Image standardmässig **nicht** in den lokalen Docker ab — `docker run` würde es dann
> nicht finden. Deshalb `load: true` setzen. Ausserdem prüft der Test die Antwort inhaltlich
> (`grep "Hello, World!"`) statt nur den HTTP-Aufruf.

## 4. Ablauf

`Checkout → Buildx → Build Image → Container starten → curl-Test → Container stoppen`.
Bei Erfolg ist die Pipeline grün: Das Image ist buildbar und die App antwortet im Container.

## Ergebnis

- Vollständige CI-Pipeline für ein Container-Image.
- Bei jedem Push wird automatisch gebaut und getestet — Grundlage für Registry-Push (Übung 2)
  und Deployment (Übung 3).
