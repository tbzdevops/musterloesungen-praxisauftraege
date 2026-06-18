# Musterlösung: Erste Schritte mit GitHub Actions (Hello CI)

**Ziel:** Den ersten Continuous-Integration-Workflow mit GitHub Actions einrichten, der bei jeder
Code-Änderung automatisch ausgeführt wird.

---

## 1. Repository und Workflow-Datei

Auf GitHub wird ein neues Repository angelegt (z. B. `ci-hello-world`). GitHub Actions sucht
automatisch nach Workflow-Definitionen im Ordner `.github/workflows/`. Dort wird die Datei
`hello-ci.yml` erstellt.

```
ci-hello-world/
└── .github/
    └── workflows/
        └── hello-ci.yml
```

---

## 2. Die Workflow-Datei

**`.github/workflows/hello-ci.yml`**
```yaml
name: Hello CI Workflow

on: [push]

jobs:
  hello:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Print Hello
        run: echo "Hello Continuous Integration!"
```

---

## 3. Erklärung der Bausteine

| Schlüssel | Bedeutung |
|-----------|-----------|
| `name` | Anzeigename des Workflows im Actions-Reiter von GitHub. |
| `on: [push]` | Trigger (Auslöser). Der Workflow startet bei jedem `git push` ins Repository. |
| `jobs` | Container für einen oder mehrere Jobs. Jobs laufen standardmässig parallel. |
| `hello` | Frei wählbare ID des Jobs. |
| `runs-on: ubuntu-latest` | Der Runner – eine frische virtuelle Maschine mit Ubuntu, die GitHub bereitstellt. |
| `steps` | Geordnete Liste von Schritten, die nacheinander im selben Runner ausgeführt werden. |
| `uses: actions/checkout@v4` | Vordefinierte Action aus dem Marketplace, die den Repository-Code in den Runner lädt. |
| `run: echo ...` | Führt einen Shell-Befehl direkt im Runner aus. |

**Hierarchie merken:** Ein **Workflow** enthält **Jobs**, ein Job enthält **Steps**, ein Step ist
entweder eine wiederverwendbare Action (`uses`) oder ein Shell-Befehl (`run`).

---

## 4. Ausführen und beobachten

```bash
git add .github/workflows/hello-ci.yml
git commit -m "Add Hello CI workflow"
git push
```

Nach dem Push:

1. Auf GitHub den Reiter **Actions** öffnen.
2. Der Workflow-Lauf erscheint mit gelbem Punkt (läuft) und wechselt bei Erfolg auf einen grünen
   Haken.
3. Lauf öffnen → Job `hello` → Step `Print Hello` aufklappen.

**Erwartete Ausgabe im Log:**
```
Hello Continuous Integration!
```

---

## 5. Ergebnis und Erkenntnis

- Ein grüner Workflow-Lauf zeigt, dass GitHub Actions korrekt konfiguriert ist.
- Der Workflow läuft **vollautomatisch** bei jedem Push – niemand muss ihn manuell starten.
- Dies ist das Grundgerüst jeder CI-Pipeline: ein **Trigger** (`on`), ein **Runner** (`runs-on`)
  und eine Folge von **Steps**. In den nächsten Aufträgen werden die Steps mit echten Build- und
  Test-Aufgaben gefüllt.
