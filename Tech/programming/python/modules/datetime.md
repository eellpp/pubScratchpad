using 3.9 new ZoneInfo module convert the date time string from "America New York" to local system time zone 

You can do this using Python’s `datetime` + `zoneinfo` (Python 3.9+).
Key steps:

1️⃣ Parse the datetime string
2️⃣ Attach `America/New_York` timezone
3️⃣ Convert to your system’s local timezone

---

## ✅ Example

```python
from datetime import datetime
from zoneinfo import ZoneInfo

# Example input datetime string (NY time)
dt_str = "2025-02-01 15:30:00"

# 1) Parse to naive datetime
dt = datetime.strptime(dt_str, "%Y-%m-%d %H:%M:%S")

# 2) Attach New York timezone
ny_time = dt.replace(tzinfo=ZoneInfo("America/New_York"))

# 3) Convert to local system timezone
local_time = ny_time.astimezone()

print("NY time     :", ny_time)
print("Local time  :", local_time)
```

`astimezone()` with no argument converts to your machine’s local timezone automatically.

---

## 🕓 Output looks like

```
NY time     : 2025-02-01 15:30:00-05:00
Local time  : 2025-02-02 02:00:00+08:00
```

(Actual result depends on your system timezone)

---

## ⚠️ Important Notes

* If your string already contains timezone info (like ISO format), **do not** use `replace`. Instead parse it properly.
* This handles DST correctly because `ZoneInfo("America/New_York")` knows DST rules.
* Requires Python **3.9+**

---

## ✅ If your datetime string includes timezone offset already

Example: `"2025-02-01T15:30:00-05:00"`

```python
from datetime import datetime
ny_time = datetime.fromisoformat("2025-02-01T15:30:00-05:00")
local_time = ny_time.astimezone()
```

---


`datetime` handles:

* Dates
* Times
* Combined date & time
* Timezone-aware values
* Formatting & parsing strings
* Differences between dates/times

```python
from datetime import datetime, date, time, timedelta, timezone
```

---

# ✔️ 1️⃣ Get Current Date & Time

## Current local datetime

```python
datetime.now()
```

## Current UTC

```python
datetime.utcnow()
```

---

# ✔️ 2️⃣ Today’s Date

```python
date.today()
```

---

# ✔️ 3️⃣ Creating Dates & Times Manually

```python
d = date(2025, 1, 30)           # date(year, month, day)
t = time(14, 30, 10)             # time(hour, min, sec)
dt = datetime(2025, 1, 30, 14, 30, 10)
```

---

# ✔️ 4️⃣ Formatting Dates → String (strftime)

Convert datetime to readable string:

```python
dt = datetime.now()
dt.strftime("%Y-%m-%d %H:%M:%S")
```

Common format codes:

| Code | Meaning       |
| ---- | ------------- |
| `%Y` | 4-digit year  |
| `%m` | month (01–12) |
| `%d` | day           |
| `%H` | hour (24h)    |
| `%I` | hour (12h)    |
| `%M` | minute        |
| `%S` | second        |
| `%f` | microseconds  |
| `%A` | weekday name  |
| `%a` | weekday short |
| `%B` | month name    |

Example:

```python
dt.strftime("%A, %d %B %Y")
```

---

# ✔️ 5️⃣ Parsing String → Datetime (strptime)

```python
datetime.strptime("2025-01-30 14:30", "%Y-%m-%d %H:%M")
```

---

# ✔️ 6️⃣ Extract Parts of Date/Time

```python
dt = datetime.now()

dt.year
dt.month
dt.day
dt.hour
dt.minute
dt.second
dt.weekday()      # Monday=0 ... Sunday=6
dt.isoweekday()   # Monday=1 ... Sunday=7
```

---

# ✔️ 7️⃣ Date Math (Timedelta)

```python
today = date.today()

tomorrow = today + timedelta(days=1)
yesterday = today - timedelta(days=1)
```

Difference between two dates:

```python
delta = date(2025, 2, 1) - date(2025, 1, 30)
delta.days
```

Add hours/minutes:

```python
datetime.now() + timedelta(hours=5, minutes=30)
```

---

# ✔️ 8️⃣ Timezones

Timezone-aware now (UTC):

```python
datetime.now(timezone.utc)
```

Convert naive datetime to UTC:

```python
dt = datetime.now()
utc_dt = dt.replace(tzinfo=timezone.utc)
```

> For real-world timezone conversions (DST safe), use **`pytz`** or **`zoneinfo` (Python 3.9+)**

Example:

```python
from zoneinfo import ZoneInfo

datetime.now(ZoneInfo("Asia/Kolkata"))
```

---

# ✔️ 9️⃣ ISO Format Helpers

ISO datetime:

```python
datetime.now().isoformat()
```

Parse ISO string:

```python
datetime.fromisoformat("2025-01-30T14:30:00")
```

---

# ✔️ 🔟 Useful Short Snippets

## Get first day of month

```python
today.replace(day=1)
```

## Get start of day

```python
datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
```

## Get timestamp (epoch seconds)

```python
datetime.now().timestamp()
```

## From timestamp

```python
datetime.fromtimestamp(1706635000)
```

---

# 🎯 Quick Reference Cheat Sheet

| Task              | Code                         |
| ----------------- | ---------------------------- |
| Now               | `datetime.now()`             |
| Today             | `date.today()`               |
| Create date       | `date(y,m,d)`                |
| Create datetime   | `datetime(y,m,d,H,M,S)`      |
| Format → str      | `strftime()`                 |
| Parse str → dt    | `strptime()`                 |
| Add/subtract time | `timedelta(...)`             |
| UTC now           | `datetime.now(timezone.utc)` |
| ISO format        | `isoformat()`                |
