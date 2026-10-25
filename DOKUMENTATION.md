# Container-Pipeline — Tag 14 Praxis

Dokumentation der CI-Pipeline [`.github/workflows/aufgabe1.yml`](.github/workflows/aufgabe1.yml). Die ausführliche Musterlösung steht in [tag14/](tag14/).

## Welche Schritte führt die Pipeline aus, und in welcher Reihenfolge?

Bei jedem Push auf `main` startet ein Linux-Runner den Job `build`:

1. **Checkout:** `actions/checkout` holt den Code auf den Runner.
2. **Buildx einrichten:** `docker/setup-buildx-action` stellt das Werkzeug zum Bauen bereit.
3. **Image bauen:** `docker/build-push-action` baut aus dem [Dockerfile](Dockerfile) das Image `hello-docker-ci:latest`, ohne es hochzuladen (`push: false`).
4. **Container testen:** `docker run` startet den Container auf Port 8080, `curl` ruft die Startseite auf und `grep` prüft, ob `Hello, World!` zurückkommt. Danach wird der Container gestoppt.

Schlägt ein Schritt fehl, wird der Lauf rot. Ein Commit mit geändertem Antworttext hat das bestätigt.

## Warum ist `load: true` nötig?

Buildx baut in einem eigenen Builder-Container. Ohne `load: true` bleibt das Image dort im Build-Cache und landet nicht im lokalen Docker des Runners. `docker run` im nächsten Schritt würde das Image dann nicht finden und versuchen, es aus Docker Hub zu laden.

## Welche zwei Schritte fehlen noch bis zum laufenden Container in der Cloud?

1. **Image Registry:** Das getestete Image muss mit eindeutigem Tag (z. B. Commit-SHA) in eine Registry wie AWS ECR gepusht werden.
2. **Deployment:** Ein Server oder Orchestrator (EC2 mit Docker Compose, AWS ECS) muss genau dieses Image ziehen und starten.

Beide Schritte setzt das Projekt am TechStyle-Shop um.
