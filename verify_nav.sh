#!/usr/bin/env bash
set -euo pipefail

stamp="$(date -Iseconds)"
report="nav_full_report.md"
: > "$report"

ok()  { printf "✅ %s\n" "$*" | tee -a "$report"; }
err() { printf "❌ %s\n" "$*" | tee -a "$report"; exit 1; }

printf "# דו״ח ניווט מלא (Auto QA)\n_זמן: %s_\n\n" "$stamp" | tee -a "$report"

# 1) index → שכבות (שימוש ב-grep -F כדי להימנע מרגקס וציטוטים)
for hub in grade7.html grade8.html grade9.html; do
  grep -Fq "href=\"$hub\"" index.html || err "index.html לא מפנה ל-$hub"
  ok "index.html → $hub"
done

# 2) שכבות: כותרת + קישורי הקבצות
grep -Fq "<h1>שכבת ז׳</h1>" grade7.html              || err "grade7.html: H1 חסר/שגוי"
grep -Fq "href=\"grade7_science_tal.html\"" grade7.html || err "grade7.html: כפתור הקבצה מדעית חסר/שגוי"
ok "שכבת ז׳: כותרת + קישור מדעית (טל נחמיה) תקינים"

grep -Fq "<h1>שכבת ח׳</h1>" grade8.html               || err "grade8.html: H1 חסר/שגוי"
grep -Fq "href=\"grade8_A1_ronit.html\"" grade8.html   || err "grade8.html: כפתור א1 (רונית פואל) חסר/שגוי"
grep -Fq "href=\"grade8_A_tal.html\""   grade8.html    || err "grade8.html: כפתור א (טל נחמיה) חסר/שגוי"
ok "שכבת ח׳: כותרת + קישורי הקבצות (א1/א) תקינים"

grep -Fq "<h1>שכבת ט׳</h1>" grade9.html               || err "grade9.html: H1 חסר/שגוי"
grep -Fq "href=\"grade9_T2_mekademet.html\"" grade9.html || err "grade9.html: כפתור ט2 (מקדמת) חסר/שגוי"
ok "שכבת ט׳: כותרת + קישור ט2 (מקדמת) תקינים"

# 3) דוחות: טבלה/כותרות/שורות
check_report() {
  local f="$1"
  [ -f "$f" ] || err "חסר דוח $f"
  grep -q "<table" "$f"  || err "$f: חסרה <table>"
  grep -q "<tbody" "$f"  || err "$f: חסר <tbody>"
  grep -Eq "<th[^>]*>#</th>.*<th[^>]*>שם פרטי</th>.*<th[^>]*>שם משפחה</th>.*<th[^>]*>כיתה</th>.*<th[^>]*>.*אירוע.*</th>.*<th[^>]*>ציון</th>.*<th[^>]*>הערות</th>" "$f" \
    || err "$f: כותרות הטבלה לא תואמות למפרט"
  local rows
  rows=$(grep -o "<tr>" "$f" | wc -l | tr -d " ")
  [ "$rows" -ge 1 ] || err "$f: אין שורות תלמידים"
  ok "$f: טבלה תקינה (${rows} שורות)"
}
check_report grade7_science_tal.html
check_report grade8_A1_ronit.html
check_report grade8_A_tal.html
check_report grade9_T2_mekademet.html

# 4) HTTP 200 מקומי
python3 -m http.server 8000 >/dev/null 2>&1 & PID=$!
sleep 0.7
chk(){ code=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:8000/$1"); printf "%-28s -> %s\n" "$1" "$code" | tee -a "$report"; [ "$code" = "200" ] || err "עמוד $1 לא חזר 200"; }
for p in "" index.html grade7.html grade8.html grade9.html grade7_science_tal.html grade8_A1_ronit.html grade8_A_tal.html grade9_T2_mekademet.html; do
  chk "$p"
done
kill $PID >/dev/null 2>&1 || true
ok "כל העמודים מחזירים 200 מקומית"

# 5) חתימה בקנבס (אם קיים) + הוספה ל-git
if [ -f canvas_backup.md ]; then
  {
    echo
    echo "## 🔒 חתימת אימות: $stamp"
    echo "- ניווט: index → שכבה (ז׳/ח׳/ט׳) → הקבצה — תקין."
    echo "- דוחות: כותרות + tbody + שורות — תקין."
    echo "- HTTP 200 לכל העמודים — תקין."
  } >> canvas_backup.md
  git add canvas_backup.md
fi

git add "$report" || true
echo
echo "📄 תקציר דו\"ח (סוף קובץ):"
tail -n 30 "$report"
