# Musterlösung – Übung 3: Microservices zu Hause (Docker Compose)

**Ziel:** Zwei Container (Web + Redis) mit **Docker Compose** als Einheit definieren und starten.

Lauffähiger Code: [uebung03-compose/](uebung03-compose/)

---

## 1. `docker-compose.yml`

```yaml
services:
  web:
    image: hello-docker:1.0
    build: .
    ports:
      - "8080:8080"
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
```

- **web** nutzt das Image aus Übung 2; `build: .` baut es bei Bedarf aus dem lokalen Dockerfile
  (so ist der Ordner eigenständig lauffähig).
- **redis** verwendet das offizielle, schlanke `redis:7-alpine`-Image.
- (`version:` ist in Compose v2 obsolet und wurde weggelassen.)

## 2. Starten und prüfen

```bash
cd uebung03-compose
docker compose up -d --build          # beide Services starten (web wird gebaut)
docker ps                              # zwei Container: ...-web-1 und ...-redis-1

curl http://localhost:8080             # web -> Hello Docker!
docker compose exec redis redis-cli ping   # redis -> PONG

docker compose logs -f                 # Logs beider Services (Strg+C beendet)
docker compose down                    # alles stoppen und entfernen
```

## 3. Container-Kommunikation

Compose legt ein gemeinsames Netzwerk an, in dem die Services sich über ihren **Namen**
erreichen. Der Web-Container könnte Redis also als `redis://redis:6379` ansprechen — ohne
IP-Adressen, dank DNS im Compose-Netzwerk. (Im Beispiel nutzt die Web-App Redis noch nicht,
das Prinzip ist aber angelegt.)

## Ergebnis

- Ein Mini-Microservice-Stack aus zwei Containern läuft lokal via einem Befehl.
- `docker compose up/down/logs/exec` sitzen.
- Service-Discovery über Namen im Compose-Netzwerk verstanden.
