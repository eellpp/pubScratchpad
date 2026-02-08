# 📘 User Guide: Logging with systemd & journald (Debian)

## 1️⃣ What Is systemd Logging (journald)?

On modern Linux (including Debian), **systemd captures service logs into `journald`**.

Instead of:

```text
/var/log/myapp.log
```

You get:

```text
app → stdout/stderr → systemd → journald → journalctl (query)
```

### What this solves

* ✅ Central logging for all services
* ✅ Automatic timestamps
* ✅ Logs tied to service name
* ✅ Logs include service restarts
* ✅ Built-in rotation & disk limits
* ✅ Query by time, service, severity

This is **production-grade logging without extra tooling**.

---

## 2️⃣ Basic Setup (Correct Way to Log an App)

### Example systemd service

```ini
# /etc/systemd/system/customer_segmentation.service
[Unit]
Description=Customer Segmentation Service
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/customer_segmentation/app.py
Restart=always
RestartSec=5

StandardOutput=journal
StandardError=journal
SyslogIdentifier=customer_segmentation

[Install]
WantedBy=multi-user.target
```

Reload and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable customer_segmentation
sudo systemctl start customer_segmentation
```

---

## 3️⃣ Best Practices (Production-Grade Logging)

### ✅ 1. Always tag logs with app identity

Use:

```ini
SyslogIdentifier=customer_segmentation
```

This allows:

```bash
journalctl -t customer_segmentation
```

---

### ✅ 2. Log to stdout/stderr in your app

In Python:

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [customer_segmentation] %(levelname)s: %(message)s",
)
```

In Java (Logback/Log4j): configure console appender.

---

### ✅ 3. Make journald persistent

By default, logs may be volatile. Make them survive reboots:

```bash
sudo nano /etc/systemd/journald.conf
```

```ini
Storage=persistent
```

Restart:

```bash
sudo systemctl restart systemd-journald
```

---

### ✅ 4. Configure log retention & disk limits

```ini
SystemMaxUse=500M
SystemKeepFree=1G
MaxRetentionSec=7day
```

This prevents log files from filling your disk.

---

### ✅ 5. Log service start explicitly

```python
import os, logging
logging.info("Service started pid=%s", os.getpid())
```

This makes restarts obvious in logs.

---

### ✅ 6. Use structured fields in logs

This makes grep and Elastic ingestion powerful:

```python
logging.error("status=failed customer_id=%s error=%s", cid, err)
```

---

## 4️⃣ Quick Common Commands (Daily Ops Cheat Sheet)

### 🔎 View logs

```bash
journalctl -u customer_segmentation        # all logs
journalctl -u customer_segmentation -f     # live logs
journalctl -u customer_segmentation -n 200 # last 200 lines
journalctl -u customer_segmentation -r     # newest first
```

---

### ⏱ Filter by time

```bash
journalctl -u customer_segmentation --since "1 hour ago"
journalctl -u customer_segmentation --since today
journalctl -u customer_segmentation --since "2026-02-08 05:00"
```

---

### 🚨 Errors only

```bash
journalctl -u customer_segmentation -p err
journalctl -u customer_segmentation | grep -i error
```

---

### 🧠 Grep for patterns

```bash
journalctl -u customer_segmentation | grep -E "timeout|exception|failed"
journalctl -u customer_segmentation | grep -A 20 Traceback
```

---

### 📜 View in vim / less

```bash
journalctl -u customer_segmentation | less
journalctl -u customer_segmentation | vim -
```

---

### 🗂 Export logs to file

```bash
journalctl -u customer_segmentation > /tmp/customer_segmentation.log
```

---

## 5️⃣ Log Rotation & Disk Management

Check disk usage:

```bash
journalctl --disk-usage
```

Vacuum old logs:

```bash
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=500M
```

journald automatically rotates logs — **no logrotate needed** unless you also log to files.

---

## 6️⃣ Advanced Logging Patterns

### 🔁 Mirror logs to file (optional)

```ini
StandardOutput=journal+append:/var/log/customer_segmentation/app.log
StandardError=journal+append:/var/log/customer_segmentation/app.log
```

Then you can:

```bash
grep -i error /var/log/customer_segmentation/app.log
```

(Use `logrotate` for this file.)

---

### 📦 JSON logging (Elastic-friendly)

```python
import json, logging

logging.info(json.dumps({
    "service": "customer_segmentation",
    "event": "batch_failed",
    "batch_id": 42,
    "reason": "timeout"
}))
```

This becomes searchable data later.

---

### 🔌 Central log ingestion

Typical pipeline:

```
systemd → journald → Filebeat/Fluent Bit → Elasticsearch
```

This keeps your local logs usable while enabling observability dashboards.

---

## 7️⃣ Common Mistakes to Avoid

| Mistake                    | Why It’s Bad                    |
| -------------------------- | ------------------------------- |
| Logging to random files    | Hard to manage, rotate, monitor |
| Not tagging logs           | Can’t filter by service         |
| No log limits              | Disk fills → system crashes     |
| Not persisting journald    | Logs lost after reboot          |
| Logging secrets            | Security risk                   |
| Logging without timestamps | Debugging nightmare             |

---

## 8️⃣ Minimal Logging Template (Copy-Paste Ready)

### systemd unit snippet

```ini
StandardOutput=journal
StandardError=journal
SyslogIdentifier=myapp
```

### Python logging snippet

```python
import logging, os

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [myapp] %(levelname)s: %(message)s",
)

logging.info("Service started pid=%s", os.getpid())
```

---

## 9️⃣ Debugging Workflow (Real Operator Playbook)

When something breaks:

```bash
systemctl status customer_segmentation
journalctl -u customer_segmentation -n 200
journalctl -u customer_segmentation --since "30 min ago" | grep -i error
```

This sequence catches **80–90% of real-world failures** fast.

---

## 🔚 Final Mental Model

> systemd = service lifecycle
> journald = structured log store
> journalctl = query engine
> grep/vim = human inspection tools

Once you internalize this, logging on Linux becomes clean, powerful, and boring (which is exactly what you want in production 😄).
.
