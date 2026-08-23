#!/usr/bin/env bash
# Lokale Verifikation der Praxis-Aufträge von Tag 04.
#
#   bash tag04/verify.sh        # alle Aufträge
#   bash tag04/verify.sh 2      # nur Auftrag 2
#
# Die Lösungsdateien liegen dort, wo sie im eigenen Repo auch liegen müssen:
# im Wurzel-Verzeichnis bzw. in .github/workflows/. Auftrag 3 erweitert die
# Pipeline aus Auftrag 2 in derselben Datei ci-build-test.yml.

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WF_DIR="$REPO_DIR/.github/workflows"
PASS=0
FAIL=0

ok()   { echo "✅ $1"; PASS=$((PASS + 1)); }
nok()  { echo "❌ $1"; FAIL=$((FAIL + 1)); }
head1() { echo ""; echo "━━━ $1 ━━━"; }

# Führt einen Befehl in einem Verzeichnis aus und meldet Erfolg/Misserfolg.
# Läuft bewusst ohne Subshell, damit die Zähler PASS/FAIL erhalten bleiben.
run_step() {
  local work_dir="$1"
  local description="$2"
  shift 2
  local output previous_dir
  previous_dir="$PWD"
  cd "$work_dir" || { nok "$description"; return; }
  if output="$("$@" 2>&1)"; then
    ok "$description"
  else
    nok "$description"
    echo "$output" | sed 's/^/     /'
  fi
  cd "$previous_dir" || return
}

# Legt ein Wegwerf-Venv an, installiert requirements.txt und gibt den Pfad zum Venv aus.
setup_venv() {
  local project_dir="$1"
  local venv_dir
  venv_dir="$(mktemp -d)/venv"
  python3 -m venv "$venv_dir" >/dev/null 2>&1 || return 1
  "$venv_dir/bin/pip" install --quiet --disable-pip-version-check \
    -r "$project_dir/requirements.txt" >/dev/null 2>&1 || return 1
  echo "$venv_dir"
}

verify_auftrag1() {
  head1 "Auftrag 1 — Hello CI"
  local workflow="$WF_DIR/hello-ci.yml"

  if [ -f "$workflow" ]; then
    ok "Workflow-Datei .github/workflows/hello-ci.yml existiert"
  else
    nok "Workflow-Datei .github/workflows/hello-ci.yml fehlt"
    return
  fi

  grep -qE '^on:\s*\[?\s*push' "$workflow" \
    && ok "Trigger on: [push] konfiguriert" \
    || nok "Trigger on: [push] fehlt"

  grep -q 'actions/checkout' "$workflow" \
    && ok "Checkout-Action vorhanden" \
    || nok "Checkout-Action (actions/checkout) fehlt"

  grep -q 'runs-on: ubuntu-latest' "$workflow" \
    && ok "Runner ubuntu-latest gesetzt" \
    || nok "runs-on: ubuntu-latest fehlt"

  echo "     Erwartete Log-Ausgabe: 🎉 Hello Continuous Integration!"
}

verify_auftrag2() {
  head1 "Auftrag 2 — Build und Test"
  local workflow="$WF_DIR/ci-build-test.yml"
  local venv

  if [ -f "$workflow" ]; then
    ok "Workflow-Datei .github/workflows/ci-build-test.yml existiert"
  else
    nok "Workflow-Datei .github/workflows/ci-build-test.yml fehlt"
  fi

  grep -q 'actions/setup-python' "$workflow" 2>/dev/null \
    && ok "Python-Setup im Workflow (actions/setup-python)" \
    || nok "actions/setup-python fehlt"

  grep -qiE 'pip install.*requirements\.txt' "$workflow" 2>/dev/null \
    && ok "Abhängigkeiten werden installiert (pip install -r requirements.txt)" \
    || nok "pip install -r requirements.txt fehlt"

  grep -qi 'pytest' "$workflow" 2>/dev/null \
    && ok "Tests werden im Workflow ausgeführt (pytest)" \
    || nok "pytest-Schritt fehlt"

  if ! venv="$(setup_venv "$REPO_DIR")"; then
    nok "Dependencies aus requirements.txt installieren"
    return
  fi
  ok "Dependencies aus requirements.txt installiert"

  run_step "$REPO_DIR" "pytest -q läuft grün" "$venv/bin/pytest" -q
}

verify_auftrag3() {
  head1 "Auftrag 3 — Linter und Docker-Build"
  local workflow="$WF_DIR/ci-build-test.yml"
  local venv

  [ -f "$REPO_DIR/Dockerfile" ] \
    && ok "Dockerfile im Wurzel-Verzeichnis vorhanden" \
    || nok "Dockerfile fehlt"

  grep -qi 'flake8' "$workflow" 2>/dev/null \
    && ok "Linter-Schritt im Workflow (flake8)" \
    || nok "flake8-Schritt fehlt"

  grep -qi 'docker build' "$workflow" 2>/dev/null \
    && ok "Docker-Build-Schritt im Workflow" \
    || nok "docker build fehlt"

  if ! venv="$(setup_venv "$REPO_DIR")"; then
    nok "Dependencies aus requirements.txt installieren"
    return
  fi

  run_step "$REPO_DIR" "flake8 . meldet keine Verstösse" "$venv/bin/flake8" .

  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    run_step "$REPO_DIR" "docker build -t myapp:latest ." docker build -t myapp:latest .
  else
    echo "⏭️  Docker nicht verfügbar — Image-Build übersprungen (läuft in GitHub Actions)"
  fi
}

main() {
  local target="${1:-all}"

  case "$target" in
    1) verify_auftrag1 ;;
    2) verify_auftrag2 ;;
    3) verify_auftrag3 ;;
    all) verify_auftrag1; verify_auftrag2; verify_auftrag3 ;;
    *) echo "Verwendung: bash tag04/verify.sh [1|2|3]"; exit 2 ;;
  esac

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📊 Tag 04 Praxis — Zusammenfassung"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ Erfüllt:    $PASS"
  echo "❌ Fehlen:     $FAIL"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  [ "$FAIL" -eq 0 ] || exit 1
}

main "$@"
