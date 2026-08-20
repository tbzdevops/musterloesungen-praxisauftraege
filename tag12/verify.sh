#!/usr/bin/env bash
# Lokale Verifikation der Praxis-Aufträge von Tag 12 (DevSecOps).
#
#   bash tag12/verify.sh        # alle Aufträge
#   bash tag12/verify.sh 3      # nur Auftrag 3
#
# Prüft, was ohne externe Accounts prüfbar ist: dass die Musterlösungs-Dokumente und die
# Workflow-Vorlagen vorhanden, gültig und inhaltlich vollständig sind. Snyk (Account/Token)
# und ein echter ZAP-Scan (Docker) laufen in GitHub Actions — siehe
# .github/workflows/tag12-praxis.yml.

set -uo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WF_DIR="$BASE_DIR/auftrag03-ci-security/.github/workflows"
PASS=0
FAIL=0

ok()   { echo "✅ $1"; PASS=$((PASS + 1)); }
nok()  { echo "❌ $1"; FAIL=$((FAIL + 1)); }
head1() { echo ""; echo "━━━ $1 ━━━"; }

# Prüft, ob eine Datei existiert und ein Muster enthält.
grep_in() {
  local file="$1" pattern="$2" desc="$3"
  if [ ! -f "$file" ]; then nok "$desc (Datei fehlt: ${file##*/})"; return; fi
  if grep -qE "$pattern" "$file"; then ok "$desc"; else nok "$desc"; fi
}

# Validiert YAML mit Python, falls verfügbar; sonst wird der Check übersprungen.
yaml_valid() {
  local file="$1" desc="$2"
  if [ ! -f "$file" ]; then nok "$desc (Datei fehlt)"; return; fi
  if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" >/dev/null 2>&1; then
    if python3 -c "import yaml,sys; yaml.safe_load(open('$file'))" >/dev/null 2>&1; then
      ok "$desc"
    else
      nok "$desc (ungültiges YAML)"
    fi
  else
    echo "⏭️  $desc — PyYAML nicht installiert, YAML-Prüfung übersprungen"
  fi
}

verify_auftrag1() {
  head1 "Auftrag 1 — SAST + SCA mit Snyk"
  local doc="$BASE_DIR/tag12_Praxisauftrag01.md"
  grep_in "$doc" 'snyk test'      "Doku beschreibt SCA-Scan (snyk test)"
  grep_in "$doc" 'snyk code test' "Doku beschreibt SAST-Scan (snyk code test)"
  grep_in "$doc" 'execute\("SELECT .*\?' "Doku zeigt sichere, parametrisierte Query"
}

verify_auftrag2() {
  head1 "Auftrag 2 — DAST mit OWASP ZAP"
  local doc="$BASE_DIR/tag12_Praxisauftrag02.md"
  grep_in "$doc" 'zap-baseline.py'  "Doku beschreibt ZAP Baseline Scan"
  grep_in "$doc" 'host.docker.internal' "Doku erklärt Docker-Host-Zugriff"
  grep_in "$doc" 'X-Frame-Options' "Doku nennt nur dynamisch sichtbare Header-Lücke"
}

verify_auftrag3() {
  head1 "Auftrag 3 — Security-Scans in CI/CD"
  local sast="$WF_DIR/aufgabe1-sast-sca.yml"
  local dast="$WF_DIR/aufgabe2-dast.yml"
  yaml_valid "$sast" "SAST/SCA-Workflow ist gültiges YAML"
  yaml_valid "$dast" "DAST-Workflow ist gültiges YAML"
  grep_in "$sast" 'snyk/actions/python@master' "SAST/SCA nutzt die Snyk-Action"
  grep_in "$sast" 'SNYK_TOKEN'                  "SAST/SCA liest das SNYK_TOKEN-Secret"
  grep_in "$dast" 'zaproxy/action-baseline'     "DAST nutzt die ZAP-Baseline-Action"
}

main() {
  local target="${1:-all}"

  case "$target" in
    1) verify_auftrag1 ;;
    2) verify_auftrag2 ;;
    3) verify_auftrag3 ;;
    all) verify_auftrag1; verify_auftrag2; verify_auftrag3 ;;
    *) echo "Verwendung: bash tag12/verify.sh [1|2|3]"; exit 2 ;;
  esac

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📊 Tag 12 Praxis — Zusammenfassung"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ Erfüllt:    $PASS"
  echo "❌ Fehlen:     $FAIL"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  [ "$FAIL" -eq 0 ] || exit 1
}

main "$@"
