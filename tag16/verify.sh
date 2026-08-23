#!/usr/bin/env bash
# Lokale Verifikation der Praxis-Übungen von Tag 16 (Container-Automatisierung).
#
#   bash tag16/verify.sh        # alle Übungen
#   bash tag16/verify.sh 1      # nur Übung 1
#
# Die Lösungsdateien liegen im Wurzel-Verzeichnis bzw. in .github/workflows/.
# Prüft dieselben Schritte wie .github/workflows/tag16-praxis.yml. Ohne laufenden
# Docker-Daemon wird der Build/Run von Übung 1 übersprungen (läuft dann in CI).

set -uo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$BASE_DIR/.." && pwd)"
WF_DIR="$REPO_DIR/.github/workflows"
PASS=0
FAIL=0

ok()   { echo "✅ $1"; PASS=$((PASS + 1)); }
nok()  { echo "❌ $1"; FAIL=$((FAIL + 1)); }
head1() { echo ""; echo "━━━ $1 ━━━"; }

docker_up() { command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; }

yaml_valid() {
  local file="$1" desc="$2"
  if [ ! -f "$file" ]; then nok "$desc (Datei fehlt)"; return; fi
  if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" >/dev/null 2>&1; then
    python3 -c "import yaml; yaml.safe_load(open('$file'))" >/dev/null 2>&1 \
      && ok "$desc" || nok "$desc (ungültiges YAML)"
  else
    echo "⏭️  $desc — PyYAML nicht installiert, übersprungen"
  fi
}

verify_uebung1() {
  head1 "Übung 1 — CI-Build (Image + Test)"
  local dir="$REPO_DIR"
  [ -f "$dir/app.py" ]           && ok "app.py (Flask) vorhanden"   || nok "app.py fehlt"
  [ -f "$dir/requirements.txt" ] && ok "requirements.txt vorhanden" || nok "requirements.txt fehlt"
  [ -f "$dir/Dockerfile" ]       && ok "Dockerfile vorhanden"       || nok "Dockerfile fehlt"
  yaml_valid "$WF_DIR/aufgabe1.yml" "aufgabe1.yml ist gültiges YAML"
  if docker_up; then
    if (cd "$dir" && docker build -q -t hello-docker-ci:latest . >/dev/null 2>&1); then
      ok "docker build erfolgreich"
      docker rm -f test-container >/dev/null 2>&1
      docker run -d --name test-container -p 8080:8080 hello-docker-ci:latest >/dev/null 2>&1
      sleep 5
      curl -sf http://localhost:8080/ | grep -q "Hello, World!" \
        && ok "Container antwortet mit 'Hello, World!'" || nok "Container antwortet nicht"
      docker stop test-container >/dev/null 2>&1; docker rm test-container >/dev/null 2>&1
    else
      nok "docker build fehlgeschlagen"
    fi
  else
    echo "⏭️  Docker nicht verfügbar — Build/Run übersprungen (läuft in GitHub Actions)"
  fi
}

verify_uebung2() {
  head1 "Übung 2 — Push zu AWS ECR"
  yaml_valid "$WF_DIR/aufgabe2.yml" "aufgabe2.yml ist gültiges YAML"
  grep -q 'amazon-ecr-login' "$WF_DIR/aufgabe2.yml" 2>/dev/null \
    && ok "Workflow nutzt amazon-ecr-login" || nok "ECR-Login fehlt"
  grep -q 'push: true' "$WF_DIR/aufgabe2.yml" 2>/dev/null \
    && ok "Workflow pusht das Image (push: true)" || nok "push: true fehlt"
}

verify_uebung3() {
  head1 "Übung 3 — Deployment auf AWS ECS"
  yaml_valid "$WF_DIR/aufgabe3.yml" "aufgabe3.yml ist gültiges YAML"
  grep -q 'amazon-ecs-deploy-task-definition' "$WF_DIR/aufgabe3.yml" 2>/dev/null \
    && ok "Workflow deployt auf ECS" || nok "ECS-Deploy-Schritt fehlt"
}

main() {
  local target="${1:-all}"
  case "$target" in
    1) verify_uebung1 ;;
    2) verify_uebung2 ;;
    3) verify_uebung3 ;;
    all) verify_uebung1; verify_uebung2; verify_uebung3 ;;
    *) echo "Verwendung: bash tag16/verify.sh [1|2|3]"; exit 2 ;;
  esac
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📊 Tag 16 Praxis — Zusammenfassung"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ Erfüllt:    $PASS"
  echo "❌ Fehlen:     $FAIL"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  [ "$FAIL" -eq 0 ] || exit 1
}
main "$@"
