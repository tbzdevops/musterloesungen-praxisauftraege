# Tag 06 - Artifact Management

Dieses Beispielprojekt zeigt zwei Wege für Python-Artefakte:

1. Du baust ein Python-Paket und speicherst es mit `actions/upload-artifact` temporär im GitHub-Actions-Lauf.
2. Du veröffentlichst dasselbe Paket mit `twine` in eine eigene `pypiserver` Registry.

Als zusätzliche Variante beschreibt die Musterlösung, wie dasselbe Prinzip mit Azure DevOps Artifacts als verwaltetem Feed umgesetzt werden kann.

## Projektstruktur

```text
tag06/
├── src/
│   └── flaskapp/
│       ├── __init__.py
│       └── main.py
├── pyproject.toml
├── .gitignore
└── README.md
```

## Lokaler Build

```bash
python -m pip install --upgrade pip build
python -m build
```

Nach dem Build liegen die Paketdateien in `dist/`:

- `.whl`
- `.tar.gz`

## Workflow 1: Temporäres Artefakt

Der Workflow `.github/workflows/build.yml` baut das Paket und speichert `tag06/dist/*` als GitHub-Actions-Artefakt.

## Workflow 2: pypiserver

Der Workflow `.github/workflows/publish_pypiserver.yml` baut das Paket und lädt es mit `twine` in eine eigene `pypiserver` Registry.

Benötigte Secrets:

```text
PYPISERVER_REPOSITORY_URL = http://<ec2-host>:8080/
PYPISERVER_USERNAME = demo
PYPISERVER_PASSWORD = demo
```

Das Paket kann danach über die Simple-Index-URL installiert werden:

```bash
python -m pip install --index-url http://<ec2-host>:8080/simple/ flaskapp
```

## Variante: Azure DevOps Artifacts

Wenn du keinen eigenen Server betreiben willst, kannst du ein Python-Paket auch in einem Azure DevOps Artifacts Feed versioniert ablegen. Die Musterlösung `tag06_Praxisauftrag02.md` enthält dafür ein separates Workflow-Beispiel.
