#!/usr/bin/env bash
set -euo pipefail

report="per_student_report.md"
: > "$report"

ok()  { printf "✅ %s\n" "$*" | tee -a "$report" ; }
errl(){ printf "❌ %s\n" "$*" | tee -a "$report" ; E=1; }

title(){ printf "\n## %s\n\n" "$1" | tee -a "$report"; }

trim(){ sed -E "s/^[[:space:]]+//; s/[[:space:]]+$//"; }

# פונקציית בדיקה כללית: $1=קובץ, $2=מספר עמודות צפוי (7/8), $3=שם הקבצה קבועה לציפייה (או ריק)
check_file(){
  local f="$1" cols="$2" expect_group="${3:-}"
  title "$f"

  [ -f "$f" ] || { errl "חסר קובץ: $f"; return; }
  grep -q "<table" "$f"  || { errl "$f: חסרה <table>"; return; }
  grep -q "<tbody" "$f"  || { errl "$f: חסר <tbody>"; return; }

  local total=0 bad=0

  # קורא שורות <tr> עד </tr>, מפצל לפי <td ...>
  awk -v RS="</tr>" -v FS="<td[^>]*>" -v COLS="$cols" -v EG="$expect_group" -v FILE="$f" 
