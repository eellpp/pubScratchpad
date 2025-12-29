## 1. How third-party libraries usually use logging

Most well-behaved libraries do this internally:

```python
import logging
logger = logging.getLogger(__name__)
```

Key points:

* They **do not** call `basicConfig()` or add handlers.
* They just emit logs to their module logger (e.g. `"pyspark.sql"`, `"requests"`, `"boto3"`, etc.).
* Those logs **bubble up** to the **root logger**.
* Whatever handlers/formatters you attach to the **root** will also see their logs.

So if you configure logging once in your main:

```python
# main.py
from logging_setup import setup_logging
import logging

setup_logging(log_level="INFO", log_file="app.log")

logger = logging.getLogger(__name__)
logger.info("My app started")
```

Any imported library that uses `logging.getLogger(__name__)` will automatically:

* Write to your **console** handler
* Write to your **file** handler
* Use your **formatter** (timestamp, line number, corr_id, etc.)

You usually don’t need to “do something special” for them.

---

## 2. How to structure your logging framework with library loggers

### a) Configure once at the “top”

Do all logging setup **in your main entrypoint**, *before* you start heavy imports / framework startup if possible.

```python
def main():
    setup_logging(...)
    # import stuff that logs a lot (optionally here)
    ...
```

### b) Use per-module loggers in **your** code

```python
logger = logging.getLogger(__name__)
```

### c) Control third-party verbosity by logger name

Example: make PySpark and `urllib3` quieter:

```python
import logging

logging.getLogger("pyspark").setLevel(logging.WARN)
logging.getLogger("py4j").setLevel(logging.WARN)
logging.getLogger("urllib3").setLevel(logging.WARNING)
```

You can also crank something up:

```python
logging.getLogger("mycompany.special_module").setLevel(logging.DEBUG)
```

This is the main “integration point”:
**you don’t integrate by changing their config, you integrate by tuning their levels and letting everything go through your handlers.**

---

## 3. PySpark as a special case

PySpark is *slightly* special because:

* Most of the heavy logs (from executors, driver JVM, etc.) are **JVM logs** via **Log4j / Log4j2**, not Python’s `logging`.
* Only the Python wrapper side (`pyspark`, `py4j`, some helpers) use the Python `logging` module.

So you have **two** logging worlds:

### A. JVM / Spark / Log4j logs

These are controlled by:

* `log4j2.properties` or `log4j.properties` in `$SPARK_HOME/conf`
* `sparkContext.setLogLevel("WARN")` etc.
* Spark config: `--conf "spark.executor.extraJavaOptions=..."`, etc.

Your Python logging setup **does not** affect these directly.

Usual pattern:

* Let Spark write its own logs (stdout or log files).
* Or configure Spark’s log4j to be more quiet (e.g., only WARN or ERROR).

### B. Python side (`pyspark`, `py4j`) logs

These behave like normal Python loggers:

```python
logging.getLogger("pyspark").setLevel(logging.INFO)   # or WARNING
logging.getLogger("py4j").setLevel(logging.ERROR)
```

And they will:

* Use your root handlers (console + file).
* Get your formatter (timestamps, line number, corr_id, etc).

So:

> PySpark is not “an exception” in terms of Python logging;
> it just also brings along a big JVM logging system that you configure separately.

---

## 4. Other libraries that bring their own loggers

Quite a lot of serious libraries do.

### Examples (not exhaustive):

* HTTP & cloud: `requests`, `urllib3`, `botocore`, `boto3`
* DB / ORM: `sqlalchemy`, `psycopg`, etc.
* Web: `uvicorn`, `gunicorn`, `django`, `fastapi` (via `uvicorn`), `flask` (via `werkzeug`)
* Task queues: `celery`
* Scraping: `scrapy`
* ML frameworks sometimes log via Python logging on the Python side.

Most of them:

* Use `logging.getLogger("package_name" or "__name__")`
* Don’t mess with handlers
* Play very nicely with your root configuration.

### The rare “annoying” cases

Sometimes a library:

* Calls `logging.basicConfig()` on import, or
* Adds its own handler with its own format.

Result: you get **duplicate logs** or ugly extra output.

How to fix:

1. Configure logging **after** importing, using `force=True` (Python 3.8+):

   ```python
   import logging
   logging.basicConfig(..., force=True)
   ```

   or your custom `setup_logging()` that clears handlers:

   ```python
   root_logger = logging.getLogger()
   root_logger.handlers.clear()
   # then add your handlers
   ```

2. Or surgically adjust that library’s logger:

   ```python
   noisy_logger = logging.getLogger("uvicorn.access")
   noisy_logger.handlers.clear()
   noisy_logger.propagate = True  # let it use root handlers instead
   ```

This pattern also works for nearly any other “I brought my own handler” library.

---

## 5. How this fits your “production logging framework”

Given the production setup we discussed earlier:

* Attach **all your handlers** (console, rotating file, JSON, etc.) to the **root logger**.
* Let **all third-party loggers propagate** to root.
* Control them by name with `setLevel` to avoid noise.
* Special systems (like Spark’s JVM logs) are configured in their own world (log4j), not in Python.

A typical “data engineering / PySpark” app might have:

```python
setup_logging(log_level="INFO", log_file="job.log")

# Quiet down super-chatty libs:
logging.getLogger("pyspark").setLevel(logging.WARN)
logging.getLogger("py4j").setLevel(logging.WARN)
logging.getLogger("urllib3").setLevel(logging.WARNING)
logging.getLogger("botocore").setLevel(logging.WARNING)

# Optionally: Spark JVM log level:
spark.sparkContext.setLogLevel("WARN")
```

Now:

* Your own code logs at INFO/DEBUG as you want.
* Third-party libraries are visible but not overwhelming.
* Everything (including library logs) goes into a **consistent format** (with time, class, function, line number, corr_id, markers) that your log parser can ingest.

