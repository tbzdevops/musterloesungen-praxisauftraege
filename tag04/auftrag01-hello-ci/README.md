# Auftrag 1 — Erste Schritte mit GitHub Actions (Hello CI)

**Ziel:** Den ersten CI-Workflow einrichten, der bei jeder Code-Änderung automatisch läuft.

## Ordnerstruktur

```
auftrag01-hello-ci/
└── .github/
    └── workflows/
        └── hello-ci.yml
```

## Bausteine

| Schlüssel | Bedeutung |
|-----------|-----------|
| `name` | Anzeigename des Workflows im Actions-Reiter. |
| `on: [push]` | Trigger. Der Workflow startet bei jedem `git push`. |
| `jobs` | Container für einen oder mehrere Jobs (laufen standardmässig parallel). |
| `hello` | Frei wählbare ID des Jobs. |
| `runs-on: ubuntu-latest` | Der Runner — eine frische Ubuntu-VM von GitHub. |
| `steps` | Geordnete Liste von Schritten im selben Runner. |
| `uses: actions/checkout@v4` | Marketplace-Action, die den Code in den Runner lädt. |
| `run: echo ...` | Führt einen Shell-Befehl im Runner aus. |

**Hierarchie:** Workflow → Jobs → Steps. Ein Step ist entweder eine Action (`uses`)
oder ein Shell-Befehl (`run`).

## Erwartete Ausgabe

```
🎉 Hello Continuous Integration!
```

## Selbst prüfen

```bash
bash tag04/verify.sh 1
```

In deinem eigenen Repo: Reiter **Actions** öffnen → Lauf → Job `hello` →
Step `Print Hello` aufklappen. Grüner Haken = bestanden.
