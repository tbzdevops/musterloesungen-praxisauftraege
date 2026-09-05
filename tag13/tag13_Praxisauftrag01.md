# Musterlösung – Übung 1: Hallo Docker! (Dein erster Container)

**Ziel:** Den ersten Container ausführen und die Docker-Basisbefehle kennenlernen.
Diese Übung ist reine **CLI-Praxis** — kein eigener Code.

---

## Schritte

```bash
# 1. Docker Desktop läuft? (Symbol in der Taskleiste / Menüleiste)

# 2. Ersten Container ausführen
docker run hello-world
# -> Docker lädt das Image von Docker Hub und startet einen Container,
#    der eine Begrüssungsnachricht ausgibt.

# 3. Weitere Basisbefehle
docker images                      # heruntergeladene Images auflisten (hello-world taucht auf)
docker pull alpine                 # kleines Linux-Image holen
docker run alpine echo "Grüezi aus dem Alpine-Container!"
docker ps                          # laufende Container (Alpine ist bereits beendet)
docker ps -a                       # auch beendete Container

# 4. Aufräumen
docker rm <name|id>                # beendeten Container entfernen (ggf. vorher docker stop)
```

## Was dabei passiert

| Befehl | Bedeutung |
|--------|-----------|
| `docker run hello-world` | Image ziehen (falls nötig) + Container starten. |
| `docker images` | Lokal vorhandene Images anzeigen. |
| `docker ps` / `docker ps -a` | Laufende / alle Container anzeigen. |
| `docker rm` / `docker stop` | Container entfernen / stoppen. |

## Ergebnis

- Der erste Container läuft; der Unterschied zwischen **Image** (Vorlage) und **Container**
  (laufende Instanz) ist greifbar.
- Basisbefehle zum Verwalten von Images und Containern sitzen — Grundlage für Übung 2.
