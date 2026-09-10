# Tag06 Praxisauftrag 02 - Musterlösung

## Ziel
Du veröffentlichst das mit `python -m build` erzeugte Python-Paket in deiner eigenen `pypiserver` Registry.

Die Datei `.github/workflows/publish_pypiserver.yml` ist im Classroom-Repository bereits vorbereitet. In der Musterlösung ergänzt du den fehlenden Publish-Schritt mit `twine`.

## Benötigte GitHub Secrets

Lege in deinem persönlichen Classroom-Repository folgende Secrets an:

```text
PYPISERVER_REPOSITORY_URL = http://<ec2-host>:8080/
PYPISERVER_USERNAME = demo
PYPISERVER_PASSWORD = demo
```

In dieser Übung prüft `pypiserver` keine echte Authentifizierung. `twine` erwartet trotzdem Benutzername und Passwort, deshalb werden Dummy-Werte verwendet.

## Workflow

```yaml
name: Publish Package to pypiserver

on:
  workflow_dispatch: {}

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v7

      - name: Set up Python
        uses: actions/setup-python@v7
        with:
          python-version: '3.10'

      - name: Install build tooling
        run: |
          python -m pip install --upgrade pip
          python -m pip install build twine

      - name: Build package
        run: python -m build

      - name: Publish package to pypiserver
        env:
          PYPISERVER_REPOSITORY_URL: ${{ secrets.PYPISERVER_REPOSITORY_URL }}
          PYPISERVER_USERNAME: ${{ secrets.PYPISERVER_USERNAME }}
          PYPISERVER_PASSWORD: ${{ secrets.PYPISERVER_PASSWORD }}
        run: |
          python -m twine upload \
            --repository-url "$PYPISERVER_REPOSITORY_URL" \
            --username "$PYPISERVER_USERNAME" \
            --password "$PYPISERVER_PASSWORD" \
            dist/*
```

## Erwartetes Ergebnis

- Dein Workflow ist manuell über `workflow_dispatch` startbar.
- GitHub Actions baut dein Paket als `.whl` und `.tar.gz`.
- `twine` lädt die Dateien aus `dist/` in deinen `pypiserver`.
- Das Paket ist danach über die Simple-Index-URL installierbar:

```bash
python -m pip install --index-url http://<ec2-host>:8080/simple/ <paketname>
```

## Typische Fehler

| Problem | Ursache | Lösung |
|---------|---------|--------|
| `Connection refused` | EC2-Instanz oder Container läuft nicht | Prüfe AWS, Security Group und Docker-Container |
| `Invalid URI` | Secret `PYPISERVER_REPOSITORY_URL` ist falsch | Verwende `http://<ec2-host>:8080/` mit Slash am Ende |
| Paket wird nicht gefunden | Falsche Install-URL | Verwende beim Installieren die `/simple/` URL |
| Upload schlägt wegen Version fehl | Dieselbe Paketversion existiert bereits | Erhöhe die Version in `pyproject.toml` |

---

# Variante: Azure DevOps Artifacts Feed

## Ziel
Du veröffentlichst dasselbe Python-Paket nicht in deinem eigenen `pypiserver`, sondern in einem verwalteten Azure DevOps Artifacts Feed. Diese Variante zeigt, wie ein Paket versioniert in einem zentralen Feed abgelegt und später wieder mit `pip` installiert werden kann.

## Einordnung

Azure DevOps Artifacts ist eine verwaltete Paket-Registry. Im Unterschied zu `pypiserver` betreibst du keinen eigenen Server. Azure DevOps stellt den Feed, die Zugriffskontrolle und die Paketverwaltung bereit.

Der Ablauf bleibt fachlich gleich:

1. Du baust das Paket mit `python -m build`.
2. `twine` lädt `.whl` und `.tar.gz` in den Azure Artifacts Feed.
3. Azure DevOps speichert das Paket mit Name und Version.
4. Andere Projekte installieren die Version über die Feed-URL mit `pip`.

## Benötigte GitHub Secrets

Lege in GitHub folgende Secrets an:

```text
AZDO_ORG = <azure-devops-organisation>
AZDO_PROJECT = <azure-devops-projekt>
AZDO_FEED = <feed-name>
AZDO_PAT = <personal-access-token>
```

Der PAT braucht Rechte, um Pakete in den Feed zu schreiben und Pakete aus dem Feed zu lesen.

## Workflow

```yaml
name: Publish to Azure DevOps Artifacts

on:
  workflow_dispatch: {}

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v7

      - name: Set up Python
        uses: actions/setup-python@v7
        with:
          python-version: '3.10'

      - name: Install build tooling
        run: |
          python -m pip install --upgrade pip
          python -m pip install build twine

      - name: Build package
        run: python -m build

      - name: Configure .pypirc
        run: |
          cat > ~/.pypirc <<EOF
          [distutils]
          index-servers =
              azure

          [azure]
          repository = https://pkgs.dev.azure.com/${{ secrets.AZDO_ORG }}/${{ secrets.AZDO_PROJECT }}/_packaging/${{ secrets.AZDO_FEED }}/pypi/upload/
          username = azdo
          password = ${{ secrets.AZDO_PAT }}
          EOF
          chmod 600 ~/.pypirc

      - name: Publish package to Azure DevOps Artifacts
        run: python -m twine upload --repository azure dist/*

      - name: Verify install
        run: |
          python -m venv venv
          source venv/bin/activate
          python -m pip install --upgrade pip
          python -m pip install \
            --index-url https://azdo:${{ secrets.AZDO_PAT }}@pkgs.dev.azure.com/${{ secrets.AZDO_ORG }}/${{ secrets.AZDO_PROJECT }}/_packaging/${{ secrets.AZDO_FEED }}/pypi/simple/ \
            --extra-index-url https://pypi.org/simple \
            <paketname>==<version>
```

## Variante mit automatischer Versionsnummer

Wenn du nicht jede Veröffentlichung manuell in `pyproject.toml` versionieren willst, kannst du die Patch-Version aus der GitHub-Run-Nummer ableiten. Das Beispiel nimmt Major und Minor aus `pyproject.toml` und ersetzt die Patch-Version durch `GITHUB_RUN_NUMBER`.

```yaml
name: Publish to Azure DevOps Artifacts with Auto Version

on:
  workflow_dispatch: {}

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v7

      - name: Set up Python
        uses: actions/setup-python@v7
        with:
          python-version: '3.10'

      - name: Install build tooling
        run: |
          python -m pip install --upgrade pip
          python -m pip install build twine

      - name: Set version from run number
        id: bump
        run: |
          python - <<'PY'
          import os
          import pathlib
          import re
          import tomllib

          path = pathlib.Path("pyproject.toml")
          content = path.read_text(encoding="utf-8")
          data = tomllib.loads(content)
          name = data["project"]["name"]
          current = data["project"]["version"]
          parts = (current.split(".") + ["0", "0", "0"])[:3]
          new_version = f"{parts[0]}.{parts[1]}.{os.environ['GITHUB_RUN_NUMBER']}"
          content = re.sub(r'^version\s*=\s*".*"', f'version = "{new_version}"', content, flags=re.M)
          path.write_text(content, encoding="utf-8")
          with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as output:
              output.write(f"name={name}\n")
              output.write(f"version={new_version}\n")
          print(f"{name} -> {new_version}")
          PY

      - name: Build package
        run: python -m build

      - name: Configure .pypirc
        run: |
          cat > ~/.pypirc <<EOF
          [distutils]
          index-servers =
              azure

          [azure]
          repository = https://pkgs.dev.azure.com/${{ secrets.AZDO_ORG }}/${{ secrets.AZDO_PROJECT }}/_packaging/${{ secrets.AZDO_FEED }}/pypi/upload/
          username = azdo
          password = ${{ secrets.AZDO_PAT }}
          EOF
          chmod 600 ~/.pypirc

      - name: Publish package to Azure DevOps Artifacts
        run: python -m twine upload --repository azure dist/*

      - name: Verify install
        env:
          FEED_URL: https://azdo:${{ secrets.AZDO_PAT }}@pkgs.dev.azure.com/${{ secrets.AZDO_ORG }}/${{ secrets.AZDO_PROJECT }}/_packaging/${{ secrets.AZDO_FEED }}/pypi/simple/
        run: |
          python -m venv venv
          source venv/bin/activate
          python -m pip install --upgrade pip
          python -m pip install \
            --index-url https://pypi.org/simple \
            --extra-index-url "$FEED_URL" \
            "${{ steps.bump.outputs.name }}==${{ steps.bump.outputs.version }}"
```

## Wann passt diese Variante?

| Variante | Passt, wenn ... |
|----------|-----------------|
| `upload-artifact` | du ein Build-Ergebnis nur kurz im Workflow brauchst |
| `pypiserver` | du eine eigene einfache Registry betreiben und verstehen willst |
| Azure DevOps Artifacts | du eine verwaltete, zentrale Registry mit Zugriffskontrolle und Feeds willst |
