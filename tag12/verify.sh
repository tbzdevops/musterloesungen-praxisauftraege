#!/usr/bin/env bash
# Lokale Verifikation der Praxis-Aufträge von Tag 12 (AI in DevOps).
#
#   bash tag12/verify.sh        # alle Aufträge
#   bash tag12/verify.sh 2      # nur Auftrag 2
#
# Prüft dieselben Schritte wie .github/workflows/tag12-praxis.yml.

set -uo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$BASE_DIR/.." && pwd)"
PASS=0
FAIL=0

ok()   { echo "✅ $1"; PASS=$((PASS + 1)); }
nok()  { echo "❌ $1"; FAIL=$((FAIL + 1)); }
head1() { echo ""; echo "━━━ $1 ━━━"; }

# Legt ein Wegwerf-Venv an, installiert requirements.txt, gibt den venv-Pfad aus.
setup_venv() {
  local project_dir="$1" venv_dir
  venv_dir="$(mktemp -d)/venv"
  python3 -m venv "$venv_dir" >/dev/null 2>&1 || return 1
  "$venv_dir/bin/pip" install --quiet --disable-pip-version-check \
    -r "$project_dir/requirements.txt" >/dev/null 2>&1 || return 1
  echo "$venv_dir"
}

run_pytest() {
  local dir="$1" desc="$2" venv output
  shift 2
  if ! venv="$(setup_venv "$dir")"; then nok "$desc (Setup fehlgeschlagen)"; return; fi
  if output="$(cd "$dir" && "$venv/bin/python" -m pytest -q "$@" 2>&1)"; then
    ok "$desc"
  else
    nok "$desc"; echo "$output" | sed 's/^/     /'
  fi
}

verify_auftrag1() {
  head1 "Auftrag 1 — AI-Assisted Development"
  [ -f "$REPO_DIR/utils/validators.py" ] \
    && ok "utils/validators.py vorhanden" || nok "utils/validators.py fehlt"
  run_pytest "$REPO_DIR" "validate_email: pytest läuft grün" tests/test_validators.py
}

verify_auftrag2() {
  head1 "Auftrag 2 — Spec-Driven Development & ADR"
  run_pytest "$REPO_DIR" "validate_discount_code: pytest läuft grün" tests/test_discount.py
  [ -f "$REPO_DIR/specs/rabattcode.md" ] \
    && ok "Spec specs/rabattcode.md vorhanden" || nok "Spec fehlt"
  [ -f "$REPO_DIR/docs/adr/0001-rabattcode-validierung.md" ] \
    && ok "ADR 0001 vorhanden" || nok "ADR fehlt"
}

verify_auftrag3() {
  head1 "Auftrag 3 — AI in der CI/CD-Pipeline"
  local wf="$REPO_DIR/.github/workflows/ai-review.yml"
  if [ ! -f "$wf" ]; then nok "ai-review.yml fehlt"; return; fi
  if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" >/dev/null 2>&1; then
    python3 -c "import yaml; yaml.safe_load(open('$wf'))" >/dev/null 2>&1 \
      && ok "ai-review.yml ist gültiges YAML" || nok "ai-review.yml ist ungültiges YAML"
  else
    echo "⏭️  YAML-Prüfung übersprungen (PyYAML nicht installiert)"
  fi
  grep -q 'pull-requests: write' "$wf" && ok "Workflow hat pull-requests: write" || nok "Berechtigung fehlt"
}

verify_auftrag4() {
  head1 "Auftrag 4 — Prompt Injection (Analyseübung)"
  local doc="$BASE_DIR/tag12_Praxisauftrag04.md"
  [ -f "$doc" ] && ok "Musterlösung tag12_Praxisauftrag04.md vorhanden" || nok "Doku fehlt"
  grep -q 'Prompt' "$doc" 2>/dev/null && ok "Doku behandelt Prompt Injection" || nok "Doku unvollständig"
}

main() {
  local target="${1:-all}"
  case "$target" in
    1) verify_auftrag1 ;;
    2) verify_auftrag2 ;;
    3) verify_auftrag3 ;;
    4) verify_auftrag4 ;;
    all) verify_auftrag1; verify_auftrag2; verify_auftrag3; verify_auftrag4 ;;
    *) echo "Verwendung: bash tag12/verify.sh [1|2|3|4]"; exit 2 ;;
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
