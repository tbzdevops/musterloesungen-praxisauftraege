# Docker Basics — Übung 1 (Tag 15 Praxis)

Dokumentation der reinen CLI-Übung „Hallo Docker!". Die ausführliche Musterlösung steht in
[tag15/tag15_Praxisauftrag01.md](tag15/tag15_Praxisauftrag01.md); Übung 2 und 3 liegen als
Code im Wurzel-Verzeichnis ([Dockerfile](Dockerfile), [app.py](app.py),
[docker-compose.yml](docker-compose.yml)).

## Durchgeführte Befehle

```bash
docker run hello-world             # erster Container: Image ziehen und starten
docker images                      # heruntergeladene Images — hello-world taucht auf
docker pull alpine                 # kleines Linux-Image holen
docker run alpine echo "Grüezi aus dem Alpine-Container!"
docker ps                          # laufende Container (Alpine ist bereits beendet)
docker ps -a                       # auch beendete Container
docker rm <name|id>                # beendeten Container entfernen
```

## Beobachtungen

| Befehl | Bedeutung |
|--------|-----------|
| `docker run hello-world` | Zieht das Image von Docker Hub (falls nicht lokal) und startet daraus einen Container. |
| `docker images` | Zeigt die lokal vorhandenen **Images** — die unveränderlichen Vorlagen. |
| `docker ps` / `docker ps -a` | Zeigt laufende bzw. alle **Container** — die Instanzen eines Images. |
| `docker rm` / `docker stop` | Entfernt bzw. stoppt einen Container; das Image bleibt erhalten. |

## Ergebnis

Der Unterschied zwischen **Image** (Vorlage, unveränderlich) und **Container** (laufende
Instanz, hat einen Zustand) ist damit greifbar: `docker images` und `docker ps -a` listen zwei
verschiedene Dinge. Ein beendeter Container verschwindet nicht von selbst — er bleibt bis zum
`docker rm` in der Liste. Diese Basisbefehle sind die Grundlage für Übung 2, in der ein eigenes
Image aus einem Dockerfile gebaut wird.
