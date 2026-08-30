#!/usr/bin/env bash
# Lokale Verifikation der Praxis-Aufträge von Tag 05.
#
#   bash tag05/verify.sh        # alle Aufträge
#   bash tag05/verify.sh 2      # nur Auftrag 2
#
# Die Lösungsdateien liegen dort, wo sie im eigenen Repo auch liegen müssen:
# im Wurzel-Verzeichnis bzw. in .github/. Auftrag 3 erweitert das Gate aus
# Auftrag 2 in derselben Datei ci.yml.

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WF_DIR="$REPO_DIR/.github/workflows"
PASS=0
FAIL=0

ok()   { echo "✅ $1"; PASS=$((PASS + 1)); }
nok()  { echo "❌ $1"; FAIL=$((FAIL + 1)); }
head1() { echo ""; echo "━━━ $1 ━━━"; }

# Prüft eine Workflow-Datei mit einem Python-Ausdruck über 'd' und 'jobs'.
wf_check() {
  python3 - "$1" "$2" <<'PY'
import sys
try:
    import yaml
except ImportError:
    sys.exit(2)
path, expr = sys.argv[1], sys.argv[2]
try:
    with open(path, encoding="utf-8") as fh:
        d = yaml.safe_load(fh)
except Exception:
    sys.exit(1)
if not isinstance(d, dict):
    sys.exit(1)
jobs = d.get("jobs")
jobs = jobs if isinstance(jobs, dict) else {}
sys.exit(0 if eval(expr) else 1)
PY
}

# Legt ein Wegwerf-Venv an und installiert requirements.txt.
setup_venv() {
  local venv_dir
  venv_dir="$(mktemp -d)/venv"
  python3 -m venv "$venv_dir" >/dev/null 2>&1 || return 1
  "$venv_dir/bin/pip" install --quiet --disable-pip-version-check \
    -r "$REPO_DIR/requirements.txt" >/dev/null 2>&1 || return 1
  echo "$venv_dir"
}

verify_auftrag1() {
  head1 "Auftrag 1 — Broken Pipeline Challenge"

  wf_check "$WF_DIR/a1-hello.yml" 'bool(jobs) and all(isinstance(j, dict) and j.get("runs-on") for j in jobs.values())' \
    && ok "Bug 1: a1-hello.yml ist gültiges YAML mit runs-on im Job" \
    || nok "Bug 1: a1-hello.yml ist kein gültiges YAML oder runs-on fehlt"

  if grep -q 'actions/setup-python@' "$WF_DIR/a2-actions.yml" 2>/dev/null \
     && ! grep -q 'setup-pyton' "$WF_DIR/a2-actions.yml"; then
    ok "Bug 2: a2-actions.yml referenziert actions/setup-python korrekt"
  else
    nok "Bug 2: Action-Name in a2-actions.yml stimmt nicht"
  fi

  grep -qiE '^[[:space:]]*pytest' "$REPO_DIR/requirements.txt" 2>/dev/null \
    && ok "Bug 3: requirements.txt enthält pytest" \
    || nok "Bug 3: pytest fehlt in requirements.txt"

  if [ -f "$WF_DIR/a4-tests.yml" ] && grep -qi 'pytest' "$WF_DIR/a4-tests.yml" \
     && ! grep -qE 'working-directory:.*src' "$WF_DIR/a4-tests.yml"; then
    ok "Bug 4: a4-tests.yml nutzt einen existierenden Testpfad"
  else
    nok "Bug 4: a4-tests.yml zeigt noch auf einen Ordner, den es nicht gibt"
  fi

  local doku="$REPO_DIR/DOKUMENTATION.md"
  if [ -f "$doku" ] && grep -qi 'a1-hello' "$doku" && grep -qi 'a2-actions' "$doku" \
     && grep -qi 'a3-deps' "$doku" && grep -qi 'a4-tests' "$doku"; then
    ok "DOKUMENTATION.md nennt die Ursache je Workflow (a1–a4)"
  else
    nok "DOKUMENTATION.md dokumentiert nicht alle vier Workflows"
  fi
}

verify_auftrag2() {
  head1 "Auftrag 2 — PR-Gate und Branch Protection"
  local doku="$REPO_DIR/DOKUMENTATION.md"

  [ -f "$WF_DIR/ci.yml" ] \
    && ok "ci.yml vorhanden" \
    || { nok "ci.yml fehlt"; return; }

  wf_check "$WF_DIR/ci.yml" '"lint" in jobs and "test" in jobs' \
    && ok "ci.yml enthält die Jobs lint und test" \
    || nok "ci.yml enthält nicht beide Jobs (lint, test)"

  grep -qE 'pull_request' "$WF_DIR/ci.yml" \
    && ok "ci.yml triggert auf pull_request" \
    || nok "Trigger pull_request fehlt — im PR gäbe es keinen Status zu melden"

  { [ -f "$REPO_DIR/.github/pull_request_template.md" ] || [ -f "$REPO_DIR/.github/PULL_REQUEST_TEMPLATE.md" ]; } \
    && ok "Pull-Request-Template vorhanden" \
    || nok "Pull-Request-Template fehlt"

  grep -qE '^[^#[:space:]]+[[:space:]]+@' "$REPO_DIR/.github/CODEOWNERS" 2>/dev/null \
    && ok "CODEOWNERS vorhanden und befüllt" \
    || nok "CODEOWNERS fehlt oder enthält keine Zuweisung"

  git -C "$REPO_DIR" log --merges --oneline 2>/dev/null | grep -q . \
    && ok "Merge-Commit in der History (über Pull Request gemergt)" \
    || nok "Kein Merge-Commit — wurde direkt auf main gepusht?"

  if [ -f "$doku" ] && grep -qiE 'ruleset|branch.?protection|geschützt' "$doku" \
     && grep -qiE '(pull/[0-9]+|#[0-9]+)' "$doku"; then
    ok "DOKUMENTATION.md beschreibt Ruleset und Pull Request"
  else
    nok "DOKUMENTATION.md nennt Ruleset oder PR-Nummer nicht"
  fi
}

verify_auftrag3() {
  head1 "Auftrag 3 — Pipeline schneller machen"
  local doku="$REPO_DIR/DOKUMENTATION.md"
  local venv

  grep -qE 'cache:[[:space:]]*(pip|poetry|pipenv)|actions/cache@' "$WF_DIR/ci.yml" 2>/dev/null \
    && ok "Dependency-Caching in ci.yml aktiviert" \
    || nok "Kein Caching in ci.yml"

  grep -qE '^[[:space:]]*concurrency:' "$WF_DIR/ci.yml" 2>/dev/null \
    && ok "concurrency-Block in ci.yml vorhanden" \
    || nok "concurrency-Block fehlt"

  wf_check "$WF_DIR/ci.yml" 'len(jobs) >= 2 and not any(isinstance(j, dict) and j.get("needs") for j in jobs.values())' \
    && ok "lint und test laufen parallel (kein needs: mehr)" \
    || nok "ci.yml enthält noch needs: — die Jobs laufen nacheinander"

  if [ -f "$doku" ] && grep -qi 'vorher' "$doku" && grep -qi 'nachher' "$doku"; then
    ok "DOKUMENTATION.md enthält die Laufzeit vorher und nachher"
  else
    nok "Vorher/Nachher-Messung fehlt in DOKUMENTATION.md"
  fi

  if ! venv="$(setup_venv)"; then
    nok "Dependencies aus requirements.txt installieren"
    return
  fi
  ok "Dependencies aus requirements.txt installiert"

  ( cd "$REPO_DIR" && "$venv/bin/pytest" -q >/dev/null 2>&1 ) \
    && ok "pytest -q läuft grün" \
    || nok "pytest -q schlägt fehl"

  ( cd "$REPO_DIR" && "$venv/bin/flake8" app.py tests/ conftest.py >/dev/null 2>&1 ) \
    && ok "flake8 meldet keine Verstösse" \
    || nok "flake8 meldet Verstösse"
}

main() {
  local target="${1:-all}"

  case "$target" in
    1) verify_auftrag1 ;;
    2) verify_auftrag2 ;;
    3) verify_auftrag3 ;;
    all) verify_auftrag1; verify_auftrag2; verify_auftrag3 ;;
    *) echo "Verwendung: bash tag05/verify.sh [1|2|3]"; exit 2 ;;
  esac

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📊 Tag 05 Praxis — Zusammenfassung"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ Erfüllt:    $PASS"
  echo "❌ Fehlen:     $FAIL"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  [ "$FAIL" -eq 0 ] || exit 1
}

main "$@"
