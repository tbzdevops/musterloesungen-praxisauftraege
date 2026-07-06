# Tag 06 - Artifact Management: Python-Paket & eigener PyPI-Index

Musterlösung für die Praxisaufträge: Ein Python-(Flask-)Paket mit GitHub Actions
bauen, zuerst als temporäres Artefakt speichern (Auftrag 1) und anschliessend in
einen eigenen PyPI-Index auf GitHub Pages publizieren (Auftrag 2).

## Projektstruktur

```
tag06/
├── src/
│   └── flaskapp/
│       ├── __init__.py
│       └── main.py
├── .github/
│   └── workflows/
│       ├── build.yml            # Auftrag 1: Build + upload-artifact
│       └── publish-pages.yml    # Auftrag 2: Publish in PyPI-Index auf GitHub Pages
├── pyproject.toml
├── .gitignore
└── README.md
```

## Dateien

- **pyproject.toml** – Moderne Build-Konfiguration (PEP 517/518), src-Layout,
  Paketname `flaskapp`, Version `0.1.0`.
- **src/flaskapp/** – Minimale Flask-Anwendung mit `hello()` und einem
  `run-flask` Console-Script als Entry Point.
- **.github/workflows/build.yml** – *Auftrag 1*: Baut sdist + wheel und legt sie
  mit `actions/upload-artifact` als temporäres Workflow-Artefakt ab
  (nur in der Actions-UI sichtbar, Standard-Aufbewahrung 90 Tage).
- **.github/workflows/publish-pages.yml** – *Auftrag 2*: Baut das Paket, kopiert
  es in den `gh-pages` Branch und generiert mit
  [`dumb-pypi`](https://github.com/chriskuehl/dumb-pypi) einen statischen
  PEP-503-Index. Wird durch einen Git-Tag (`v*`) ausgelöst.

## Auftrag 1: Temporäres Artefakt

1. Repository mit diesen Dateien anlegen.
2. Auf `main` pushen → Workflow `Build & Upload Artifact` startet.
3. Unter **Actions → Run → Artifacts** das Paket `python-dist` herunterladen.

```bash
# Lokal testen
python -m pip install --upgrade pip build
python -m build
```

## Auftrag 2: Eigener PyPI-Index auf GitHub Pages

### Einmalige Einrichtung

```bash
# Leeren gh-pages Branch erstellen
git switch --orphan gh-pages
git commit --allow-empty -m "Initialize PyPI index"
git push origin gh-pages
git switch main
```

Dann in GitHub: **Settings → Pages → Source: "Deploy from a branch" →
Branch: `gh-pages` / `/ (root)`** wählen.

Index-URL danach: `https://<OWNER>.github.io/<REPO>/`

> ⚠️ **Hinweis:** GitHub Pages Sites sind (ausser bei GitHub Enterprise) immer
> **öffentlich** – auch bei privatem Repository. Keine Secrets oder internen
> Code in die Pakete legen!

### Veröffentlichung auslösen

```bash
# Version in pyproject.toml sicherstellen (0.1.0), dann taggen und pushen
git tag v0.1.0
git push origin v0.1.0
```

Der Workflow `Publish to PyPI Index on GitHub Pages` baut das Paket, aktualisiert
den Index auf `gh-pages` und verifiziert die Installation.

### Paket konsumieren

```bash
pip install \
  --index-url https://<OWNER>.github.io/<REPO>/simple/ \
  --extra-index-url https://pypi.org/simple \
  flaskapp==0.1.0
```

- `--index-url` zeigt auf den eigenen Index auf GitHub Pages.
- `--extra-index-url https://pypi.org/simple` lädt Abhängigkeiten (z. B. Flask)
  weiterhin von PyPI.

## Kein PAT / keine Secrets nötig

Beide Workflows nutzen ausschliesslich den automatisch bereitgestellten
`GITHUB_TOKEN`. Für Auftrag 2 genügt `permissions: contents: write`, um auf den
`gh-pages` Branch zu pushen.

## Troubleshooting

| Problem | Ursache | Lösung |
|---------|---------|--------|
| 404 auf der Index-URL | Pages nicht aktiviert / Deployment läuft noch | Settings → Pages prüfen; ~1 Min. warten |
| 403 beim Push auf gh-pages | `permissions: contents: write` fehlt | Permissions im Workflow-Job ergänzen |
| Workflow startet nicht | Tag entspricht nicht dem Pattern `v*` | Tag-Namen prüfen (z. B. `v0.1.0`) |
| Paket nicht gefunden beim Install | Falsche `--packages-url` oder Tippfehler | URL im Workflow und Paketname prüfen |
| Abhängigkeiten nicht installierbar | Nur eigener Index konfiguriert | `--extra-index-url https://pypi.org/simple` ergänzen |
| Version wird nicht aktualisiert | Gleiche Version erneut gebaut | Version in `pyproject.toml` erhöhen, neuen Tag pushen |
