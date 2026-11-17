#!/usr/bin/env bash
# Lokale Verifikation der Praxis-Musterlösung von Tag 15 (DevSecOps).
#
#   bash tag15/verify.sh        # alles
#   bash tag15/verify.sh 1      # nur P1
#   bash tag15/verify.sh 2      # nur P2
#   bash tag15/verify.sh 3      # nur P3
#
# Prüft findings.md mit denselben Regeln wie die Classroom-Prüfung
# (praxis-day15, .github/classroom/checks/day-15.sh) und den Fix aus P3.
# Snyk und ZAP selbst laufen in .github/workflows/tag15-praxis.yml.

set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 2
FINDINGS=findings.md
PASS=0
FAIL=0

ok()    { echo "✅ $1"; PASS=$((PASS + 1)); }
nok()   { echo "❌ $1"; FAIL=$((FAIL + 1)); }
head1() { echo ""; echo "━━━ $1 ━━━"; }
crit()  { if findings_ok "$1"; then ok "$2"; else nok "$2"; fi; }

# Gleicher Parser wie in der Classroom-Prüfung. Bei Änderungen beide anpassen.
findings_ok() {
  python3 - "$1" "$FINDINGS" <<'PY'
import re, sys

criterion, path = sys.argv[1], sys.argv[2]
try:
    text = open(path, encoding="utf-8").read()
except OSError:
    sys.exit(1)

def section(title_re):
    """Text unter der ersten Überschrift, die title_re trifft, bis zur nächsten gleich hohen oder höheren."""
    lines = text.splitlines()
    for i, line in enumerate(lines):
        m = re.match(r"^(#{2,3})\s+(.*)$", line)
        if m and re.search(title_re, m.group(2), re.I):
            level = len(m.group(1))
            out = []
            for nxt in lines[i + 1:]:
                n = re.match(r"^(#{1,6})\s", nxt)
                if n and len(n.group(1)) <= level:
                    break
                out.append(nxt)
            return "\n".join(out)
    return ""

def rows(block):
    """Datenzeilen der ersten Tabelle im Block, ohne Kopf- und Trennzeile."""
    table = []
    for line in block.splitlines():
        s = line.strip()
        if s.startswith("|"):
            table.append([c.strip() for c in s.strip("|").split("|")])
        elif table:
            break
    data = table[1:]
    return [r for r in data if not all(re.fullmatch(r":?-{2,}:?", c or "--") for c in r)]

def filled(cell):
    return bool(cell) and not re.fullmatch(r"[-–—\s]*", cell)

def cell(r, i):
    return r[i] if i < len(r) else ""

p1 = [r for r in rows(section(r"^P1\b")) if filled(cell(r, 2))]
p2 = rows(section(r"^P2\b"))

if criterion == "p1-rows":
    ok = sum(1 for r in p1 if filled(cell(r, 3))) >= 3
elif criterion == "p1-tools":
    tools = " ".join(cell(r, 1) for r in p1).upper()
    ok = "SCA" in tools and "SAST" in tools
elif criterion == "p1-triage":
    triage = re.compile(r"risiko|false|positiv|ausnutzbar|erreichbar|\bfp\b", re.I)
    ok = sum(1 for r in p1 if triage.search(cell(r, 4)) and filled(cell(r, 5))) >= 3
elif criterion == "p2-alerts":
    ok = sum(1 for r in p2
             if all(filled(cell(r, i)) for i in (1, 2, 3, 4))
             and re.search(r"/|localhost|http", cell(r, 3), re.I)) >= 2
elif criterion == "p2-sqli":
    block = section(r"Verifizierte SQL-Injection")
    req = re.search(r"Request:(.*?)(?=^\s*-\s*Beobachtung:|\Z)", block, re.S | re.M | re.I)
    obs = re.search(r"Beobachtung:(.*)", block, re.S | re.I)
    req_txt = req.group(1) if req else ""
    ok = (re.search(r"id=", req_txt, re.I) is not None
          and re.search(r"\bor\b|%20or|'", req_txt, re.I) is not None
          and obs is not None and len(re.findall(r"\w+", obs.group(1))) >= 3)
elif criterion == "p2-compare":
    cmp_rows = rows(section(r"^Vergleich"))
    ok = any(filled(cell(r, 0)) for r in cmp_rows) and any(filled(cell(r, 1)) for r in cmp_rows)
else:
    ok = False

sys.exit(0 if ok else 1)
PY
}

verify_p1() {
  head1 "P1 — SCA und SAST mit Snyk"
  crit p1-rows   "Drei Snyk-Findings mit Paket bzw. Datei und Severity eingetragen"
  crit p1-tools  "Mindestens ein Finding aus SCA und eines aus SAST"
  crit p1-triage "Jedes Finding ist eingestuft und hat eine Massnahme"
}

verify_p2() {
  head1 "P2 — DAST mit OWASP ZAP"
  crit p2-alerts  "Zwei ZAP-Alerts mit Risiko, URL und Behebung dokumentiert"
  crit p2-sqli    "SQL-Injection von Hand verifiziert (Request und Beobachtung)"
  crit p2-compare "Vergleich SAST / DAST ausgefüllt"
}

verify_p3() {
  head1 "P3 — Fix und Re-Scan"
  if grep -qE 'WHERE id=\?", \(id,\)' dsvpwa/attacks.py; then
    ok "dsvpwa/attacks.py nutzt einen parametrisierten Query"
  else
    nok "dsvpwa/attacks.py nutzt einen parametrisierten Query"
  fi
  if grep -qE 'WHERE id=" *\+' dsvpwa/attacks.py; then
    nok "Keine String-Verkettung mehr in der /users-Abfrage"
  else
    ok "Keine String-Verkettung mehr in der /users-Abfrage"
  fi
}

case "${1:-all}" in
  1) verify_p1 ;;
  2) verify_p2 ;;
  3) verify_p3 ;;
  all) verify_p1; verify_p2; verify_p3 ;;
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
