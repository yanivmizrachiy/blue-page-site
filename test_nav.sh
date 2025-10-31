#!/usr/bin/env bash
set -e
echo "== בדיקת קישורים באינדקס =="
for href in $(grep -oP "href=\"\\K[^\"]+" index.html); do
  [ -f "$href" ] && echo "✓ $href קיים" || { echo "❌ $href חסר"; exit 1; }
done
echo; echo "== בדיקת כפתורי חזרה =="
for page in grade7_science_tal.html grade8_A1_ronit.html grade8_A_tal.html grade9_T2_mekademet.html; do
  grep -qE "<a[^>]+class=\"?back\"?[^>]*href=\"index\.html\"" "$page" \
    && echo "✓ $page יש חזרה" || { echo "❌ $page חסר חזרה"; exit 1; }
done
echo; echo "== בדיקת טבלאות =="
for page in grade7_science_tal.html grade8_A1_ronit.html grade8_A_tal.html grade9_T2_mekademet.html; do
  grep -q "<table" "$page" && grep -q "<tbody" "$page" \
    && echo "✓ $page טבלה תקינה" || { echo "❌ $page חסר טבלה"; exit 1; }
done
echo; echo "✅ הכל תקין"
