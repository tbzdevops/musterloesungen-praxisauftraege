# Musterlösung – Übung 2: Dein erstes eigenes Container-Image

**Ziel:** Eine kleine Python-Webanwendung als eigenes Docker-Image bauen und als Container
starten.

Lauffähiger Code: [uebung02-eigenes-image/](uebung02-eigenes-image/)

---

## 1. Anwendung (`app.py`)

Ein Webserver mit der Python-Standardbibliothek (keine externen Pakete nötig), der auf Port
**8080** `Hello Docker!` zurückgibt:

```python
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(b"Hello Docker!\n")

if __name__ == "__main__":
    httpd = HTTPServer(("", 8080), Handler)
    print("Starte einfachen Webserver auf Port 8080...")
    httpd.serve_forever()
```

## 2. Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY app.py /app/
EXPOSE 8080
CMD ["python", "app.py"]
```

| Anweisung | Bedeutung |
|-----------|-----------|
| `FROM python:3.11-slim` | Schlankes Basis-Image mit Python 3.11. |
| `WORKDIR /app` | Arbeitsverzeichnis im Container. |
| `COPY app.py /app/` | Anwendungscode ins Image kopieren. |
| `EXPOSE 8080` | Dokumentiert den genutzten Port. |
| `CMD [...]` | Startbefehl des Containers. |

## 3. Bauen, starten, testen

```bash
cd uebung02-eigenes-image
docker build -t hello-docker:1.0 .          # Image bauen
docker images                                # hello-docker:1.0 taucht auf
docker run -d -p 8080:8080 --name hello-app hello-docker:1.0
curl http://localhost:8080                    # -> Hello Docker!
docker logs hello-app                         # Start-Log + Zugriffe
docker stop hello-app                         # stoppen
docker rm hello-app                           # entfernen (optional)
```

- `-d` startet im Hintergrund, `-p 8080:8080` mappt den Container-Port auf den Host.

## Ergebnis

- Eigenes Image gebaut und als Container gestartet.
- Die App ist im Browser / per `curl` unter `http://localhost:8080` erreichbar.
- Logs und Lebenszyklus (start/stop/rm) verstanden — Basis für den Compose-Stack in Übung 3.
