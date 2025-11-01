# דו״ח בדיקות ניווט — יומן (יום/שבוע/חודש)

נבדק מקומית: כל הכפתורים פעילים ותקינים ✅

| כפתור | פעולה | נתיב יעד | סטטוס |
|---|---|---|---|
| prev | יום קודם | /day/YYYY-MM-DD | ✅ |
| next | יום הבא | /day/YYYY-MM-DD | ✅ |
| today | מעבר להיום | /day/Today | ✅ |
| goWeek | מעבר לשבוע ISO | /week/YYYY-Www | ✅ |
| goDay | רענון/יום נוכחי | reload | ✅ |

- כל דפי ה-HTML (index, day, week, month) החזירו HTTP 200.
- פונקציות JS: `getISOWeek`, `fmt`, וניווט `location.href` — תקין.
- רפרנס לבדיקה: test_nav.sh (רץ בהצלחה).

נכון ל־$(date +"%Y-%m-%d %H:%M:%S")
