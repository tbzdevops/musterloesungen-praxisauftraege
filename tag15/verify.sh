#!/usr/bin/env bash
# Lokale Verifikation der Praxis-Übungen von Tag 15 (Docker Basics).
#
#   bash tag15/verify.sh        # alle Übungen
#   bash tag15/verify.sh 2      # nur Übung 2
#
# Prüft dieselben Schritte wie .github/workflows/tag15-praxis.yml. Ohne laufenden
# Docker-Daemon werden die Build-/Run-Schritte übersprungen (laufen dann in CI).

set -uo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PASS=0
FAIL=0

ok()   { echo "✅ $1"; PASS=$((PASS + 1)); }
nok()  { echo "❌ $1"; FAIL=$((FAIL + 1)); }
head1() { echo ""; echo "━━━ $1 ━━━"; }

docker_up() { command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; }

verify_uebung1() {
  head1 "Übung 1 — Hallo Docker! (CLI)"
  local doc="$BASE_DIR/tag15_Praxisauftrag01.md"
  [ -f "$doc" ] && ok "Musterlösung Übung 1 vorhanden" || nok "Doku Übung 1 fehlt"
  grep -q 'docker run hello-world' "$doc" 2>/dev/null \
    && ok "Doku zeigt docker run hello-world" || nok "Doku unvollständig"
}

verify_uebung2() {
  head1 "Übung 2 — Eigenes Container-Image"
  local dir="$BASE_DIR/uebung02-eigenes-image"
  [ -f "$dir/app.py" ]     && ok "app.py vorhanden"     || nok "app.py fehlt"
  [ -f "$dir/Dockerfile" ] && ok "Dockerfile vorhanden" || nok "Dockerfile fehlt"
  if docker_up; then
    if (cd "$dir" && docker build -q -t hello-docker:1.0 . >/dev/null 2>&1); then
      ok "docker build erfolgreich"
      docker rm -f hello-app >/dev/null 2>&1
      if docker run -d -p 8080:8080 --name hello-app hello-docker:1.0 >/dev/null 2>&1; then
        sleep 3
        if curl -sf http://localhost:8080/ | grep -q "Hello Docker!"; then
          ok "Container antwortet mit 'Hello Docker!'"
        else
          nok "Container antwortet nicht wie erwartet"
        fi
        docker stop hello-app >/dev/null 2>&1; docker rm hello-app >/dev/null 2>&1
      else
        nok "docker run fehlgeschlagen"
      fi
    else
      nok "docker build fehlgeschlagen"
    fi
  else
    echo "⏭️  Docker nicht verfügbar — Build/Run übersprungen (läuft in GitHub Actions)"
  fi
}

verify_uebung3() {
  head1 "Übung 3 — Docker Compose (web + redis)"
  local dir="$BASE_DIR/uebung03-compose"
  local compose="$dir/docker-compose.yml"
  [ -f "$compose" ] && ok "docker-compose.yml vorhanden" || { nok "Compose-Datei fehlt"; return; }
  if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" >/dev/null 2>&1; then
    python3 -c "import yaml; d=yaml.safe_load(open('$compose')); assert 'web' in d['services'] and 'redis' in d['services']" >/dev/null 2>&1 \
      && ok "Compose definiert Services web + redis" || nok "Compose-Struktur unvollständig"
  else
    echo "⏭️  YAML-Prüfung übersprungen (PyYAML nicht installiert)"
  fi
  if docker_up; then
    if (cd "$dir" && docker compose up -d --build >/dev/null 2>&1); then
      sleep 3
      curl -sf http://localhost:8080/ | grep -q "Hello Docker!" \
        && ok "web-Service antwortet" || nok "web-Service antwortet nicht"
      (cd "$dir" && docker compose exec -T redis redis-cli ping 2>/dev/null | grep -q "PONG") \
        && ok "redis-Service antwortet mit PONG" || nok "redis-Service antwortet nicht"
      (cd "$dir" && docker compose down >/dev/null 2>&1)
    else
      nok "docker compose up fehlgeschlagen"
    fi
  else
    echo "⏭️  Docker nicht verfügbar — Compose-Lauf übersprungen (läuft in GitHub Actions)"
  fi
}

main() {
  local target="${1:-all}"
  case "$target" in
    1) verify_uebung1 ;;
    2) verify_uebung2 ;;
    3) verify_uebung3 ;;
    all) verify_uebung1; verify_uebung2; verify_uebung3 ;;
    *) echo "Verwendung: bash tag15/verify.sh [1|2|3]"; exit 2 ;;
  esac
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📊 Tag 15 Praxis — Zusammenfassung"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ Erfüllt:    $PASS"
  echo "❌ Fehlen:     $FAIL"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  [ "$FAIL" -eq 0 ] || exit 1
}
main "$@"
