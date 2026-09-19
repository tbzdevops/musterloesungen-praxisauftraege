#!/usr/bin/env bash
# Lokale Verifikation der Praxis-Aufträge von Tag 12 (AI in DevOps).
#
#   bash tag12/verify.sh        # beide Aufträge
#   bash tag12/verify.sh 1      # nur Auftrag 1
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
  head1 "Auftrag 1 — Spec-Driven Development mit AI"
  local spec="$REPO_DIR/specs/rabattcode.md"
  [ -f "$spec" ] && ok "Spec specs/rabattcode.md vorhanden" || nok "Spec fehlt"
  grep -qiE '^#+ *out.of.scope' "$spec" 2>/dev/null \
    && ok "Spec hat Ziel, Anforderungen, Akzeptanzkriterien, Out of Scope" || nok "Spec unvollständig"
  [ -f "$REPO_DIR/discounts/validator.py" ] \
    && ok "discounts/validator.py vorhanden" || nok "discounts/validator.py fehlt"
  run_pytest "$REPO_DIR" "validate_discount_code: pytest läuft grün" tests/
}

verify_auftrag2() {
  head1 "Auftrag 2 — Prompt Injection (Analyseübung)"
  local doc="$REPO_DIR/DOKUMENTATION.md"
  [ -f "$doc" ] && ok "DOKUMENTATION.md vorhanden" || nok "DOKUMENTATION.md fehlt"
  grep -qiE '^## *Auftrag 2' "$doc" 2>/dev/null && ok "Abschnitt Auftrag 2 vorhanden" || nok "Abschnitt Auftrag 2 fehlt"
  grep -q '^```' "$doc" 2>/dev/null && ok "Gehärteter System-Prompt als Codeblock" || nok "Codeblock fehlt"
  grep -qi 'diff' "$doc" 2>/dev/null && ok "Transfer auf den PR-Diff beschrieben" || nok "Transfer fehlt"
}

main() {
  local target="${1:-all}"
  case "$target" in
    1) verify_auftrag1 ;;
    2) verify_auftrag2 ;;
    all) verify_auftrag1; verify_auftrag2 ;;
    *) echo "Verwendung: bash tag12/verify.sh [1|2]"; exit 2 ;;
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
