
## 1. Core Concepts (just enough theory)

* **Logger** – what you call: `logger.info(...)`
* **Handler** – where logs go: console, file, HTTP, etc.
* **Formatter** – what each log line looks like.
* **Level** – severity: `DEBUG, INFO, WARNING, ERROR, CRITICAL`

You normally:

1. Configure logging **once** (in `main` or app entrypoint)
2. In each module, do:

   ```python
   import logging
   logger = logging.getLogger(__name__)
   ```

---

## 2. A Production-Grade Setup Function

This gives you:

* Console logs (for dev / containers)
* Rotating file logs
* Rich prefix: time, level, logger name, file, func, line, correlation id (if any)

```python
# logging_setup.py
import logging
import logging.handlers
import sys

def setup_logging(
    log_level: str = "INFO",
    log_file: str = "app.log",
    max_bytes: int = 10 * 1024 * 1024,  # 10 MB
    backup_count: int = 5,
):
    # Convert level string to numeric level
    level = getattr(logging, log_level.upper(), logging.INFO)

    # Root logger
    root_logger = logging.getLogger()
    root_logger.setLevel(level)

    # Remove default handlers if any
    root_logger.handlers.clear()

    # ---- Formatter ----
    # Contains time, level, logger, file:line, function, and a placeholder
    # for a correlation id or other marker (if present).
    log_format = (
        "%(asctime)s | %(levelname)-8s | %(name)s | "
        "%(filename)s:%(lineno)d %(funcName)s | "
        "corr_id=%(corr_id)s | %(message)s"
    )
    date_format = "%Y-%m-%d %H:%M:%S"

    formatter = logging.Formatter(log_format, datefmt=date_format)

    # ---- Console handler ----
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(level)
    console_handler.setFormatter(formatter)
    root_logger.addHandler(console_handler)

    # ---- File handler with rotation ----
    file_handler = logging.handlers.RotatingFileHandler(
        log_file, maxBytes=max_bytes, backupCount=backup_count, encoding="utf-8"
    )
    file_handler.setLevel(level)
    file_handler.setFormatter(formatter)
    root_logger.addHandler(file_handler)

    # Optional: avoid noisy logger spam here if needed
    logging.getLogger("urllib3").setLevel(logging.WARNING)
    logging.getLogger("asyncio").setLevel(logging.WARNING)
```

### Notes

* `RotatingFileHandler` prevents infinite file growth.
* `corr_id` is just a placeholder. We’ll fill it via `extra` or a `LoggerAdapter` (next).

---

## 3. Using the Logger in Your Code

In each module:

```python
# my_module.py
import logging

logger = logging.getLogger(__name__)

def do_work(x: int) -> int:
    logger.debug("Starting do_work with x=%s", x)
    result = x * 2
    logger.info("Finished do_work", extra={"corr_id": "-"})  # or pass a real ID
    return result
```

### Why not f-strings in logs?

Prefer:

```python
logger.debug("User %s logged in", user_id)
```

over:

```python
logger.debug(f"User {user_id} logged in")
```

The first form lets `logging` skip string formatting entirely if the level is disabled → small but real perf win.

---

## 4. Log Levels – How to Use Them

**General mapping:**

* `DEBUG` – detailed internal info, dev-only / fine-grained troubleshooting
* `INFO` – high-level app flow: “started”, “processed X records”, “listening on port…”
* `WARNING` – something odd, but app continues. “retrying”, “slow response”, fallback used.
* `ERROR` – request or operation failed, but process continues.
* `CRITICAL` – app about to crash, or must restart, or severe data corruption risk.

Example:

```python
logger.debug("Fetching user from DB id=%s", user_id)
logger.info("User login successful id=%s", user_id)
logger.warning("User login from unusual location id=%s ip=%s", user_id, ip)
logger.error("Failed to save user preferences id=%s", user_id)
logger.critical("Database unavailable, shutting down")
```

---

## 5. Logging Exceptions Properly

Inside an exception handler:

```python
try:
    risky_operation()
except Exception:
    # Includes stack trace automatically
    logger.exception("Error while running risky_operation")
```

Equivalent longer form:

```python
logger.error("Error while running risky_operation", exc_info=True)
```

Use `logger.exception` only inside `except` blocks.

---

## 6. Adding Custom Prefixes / Context (corr IDs, user IDs, etc.)

### A. Simple per-call context via `extra`

In the formatter we used `%(corr_id)s`. You can provide that per log:

```python
logger.info(
    "Processing request",
    extra={"corr_id": "REQ-1234"}
)
```

If you *don’t* pass `corr_id`, logging will fail unless you set a default. Easiest fix: wrap logger with a `LoggerAdapter`.

### B. LoggerAdapter for automatic context

```python
import logging

class ContextLogger(logging.LoggerAdapter):
    def process(self, msg, kwargs):
        # Ensure corr_id always exists
        extra = kwargs.get("extra", {})
        extra.setdefault("corr_id", self.extra.get("corr_id", "-"))
        kwargs["extra"] = extra
        return msg, kwargs

base_logger = logging.getLogger(__name__)
logger = ContextLogger(base_logger, {"corr_id": "-"})

def handle_request(corr_id: str):
    request_logger = ContextLogger(base_logger, {"corr_id": corr_id})
    request_logger.info("Received request")
    # all further logs via request_logger get corr_id automatically
```

---

## 7. “Markers” for Log Parsers (ELK, Loki, Splunk, etc.)

Most log aggregators like:

* **Structured logs** – JSON
* or consistent **key=value** patterns

### Option 1: Key=Value style

```python
logger.info(
    "event=http_request method=%s path=%s status=%s duration_ms=%s",
    method, path, status, duration_ms,
)
```

This is easy for regex/grok parsers.

You can combine with context:

```python
logger.info(
    "event=http_request method=%s path=%s status=%s duration_ms=%s user_id=%s",
    method, path, status, duration_ms, user_id,
)
```

### Option 2: JSON logs (nicer for structured pipelines)

You can write a custom formatter:

```python
import json
import logging

class JsonFormatter(logging.Formatter):
    def format(self, record):
        log_record = {
            "time": self.formatTime(record, self.datefmt),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
            "filename": record.filename,
            "lineno": record.lineno,
            "func": record.funcName,
            "corr_id": getattr(record, "corr_id", "-"),
        }
        return json.dumps(log_record)

# Then in setup_logging, use JsonFormatter for certain handlers
```

Your log parser (e.g. Fluent Bit, Filebeat) can then treat each log line as a JSON object.

---

## 8. Best Industry Practices for Logging

### 1. Configure logging in **one place**

* Do it in your app entrypoint (`if __name__ == "__main__": setup_logging(...)`)
* Libraries should **never** call `basicConfig()`. They should just use `logging.getLogger(__name__)`.

### 2. Use logger per module

```python
logger = logging.getLogger(__name__)
```

This lets you:

* turn on `DEBUG` for just `myapp.service` but not `myapp.db`
* group logs by module in your observability stack

### 3. Avoid logging sensitive data

* No passwords, tokens, full credit card numbers, etc.
* Mask or hash anything sensitive:

  ```python
  logger.info("User login user_id=%s ip=%s", user_id, masked_ip)
  ```

### 4. Use **INFO** for “business events”, **DEBUG** for internals

Examples of good INFO logs:

* `event=user_login user_id=123`
* `event=order_created order_id=987 amount=29.99`
* `event=batch_processed records=1000 duration_ms=5300`

These become your high-level narrative of app behavior.

### 5. Don’t spam logs in hot loops

* Avoid logging inside tight loops or per-row operations.
* Instead, aggregate:

  ```python
  logger.info("Processed %s records in %s ms", count, duration_ms)
  ```

### 6. Always include a correlation/request ID in server apps

* For web services, generate a `corr_id` (or use trace_id from tracing system).
* Put it in:

  * response header
  * log context (`corr_id=...`)
* Makes debugging a single request across microservices much easier.

### 7. Use rotation & log retention

* Using `RotatingFileHandler` or `TimedRotatingFileHandler` is standard.
* In containerized environments, often you log to **stdout** and let the platform handle rotation.

### 8. Make log format **stable**

* Once your log parser depends on certain fields, don’t randomly change the format.
* If you migrate to structured JSON logs, do it intentionally and version formats if necessary.

---

## 9. Minimal Example Putting It All Together

```python
# main.py
from logging_setup import setup_logging
import logging

logger = logging.getLogger(__name__)

def main():
    setup_logging(log_level="DEBUG", log_file="app.log")

    logger.info("Application starting", extra={"corr_id": "BOOT"})

    try:
        1 / 0
    except ZeroDivisionError:
        logger.exception("Division failed", extra={"corr_id": "REQ-42"})

    logger.info("Application finished", extra={"corr_id": "BOOT"})

if __name__ == "__main__":
    main()
```

Run it, and you’ll get:

* Console logs
* Rotating log file `app.log`
* Timestamps, file, function, line number, level, corr_id
* Proper stack traces for exceptions
* A format that’s ready for log parsers (and can be evolved into JSON or key/value style)


