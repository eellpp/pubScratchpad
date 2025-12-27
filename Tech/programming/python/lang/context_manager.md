# 🧠 Python Context Manager — Practical User Guide

## ✅ What is a Context Manager?

A context manager lets you wrap a block of code with **setup → execution → cleanup**, guaranteeing cleanup even if:

* the code throws exceptions
* the user returns early
* errors occur midway

Think:

```
open resource  
do work safely  
always close resource
```

This is why you commonly see:

```python
with open("file.txt") as f:
    data = f.read()
```

After the block exits, `f.close()` is automatically called — even on exception.

---

# ⚙️ Where Context Managers Are Useful in Real Projects

### 1️⃣ File & Resource Handling (standard)

* File open/close
* Temporary files
* Network connections
* Sockets
* Streams

### 2️⃣ Database Transactions

* Connection/session lifecycle
* Auto-commit or rollback
* Ensuring no cursor leaks

### 3️⃣ Concurrency & Parallel Execution

* Thread & process management
* Lock acquisition/release safely

### 4️⃣ ETL / Data Pipelines

* Open/stream huge datasets
* Temporary staging resources
* Ensure cleanup even when pipelines fail

### 5️⃣ Logging & Tracing

* Measure execution time
* Add structured logs around a block

### 6️⃣ External APIs

* Session handling
* Retry boundaries
* Rate limiting windows

### 7️⃣ Testing

* Mocking environments
* Temporary overrides
* Controlled states

---

# 🔍 How Python Implements Context Managers

Anything usable in `with` must define:

```python
__enter__(self)
__exit__(self, exc_type, exc_val, exc_tb)
```

Example:

```python
class MyContext:
    def __enter__(self):
        print("Setup")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print("Cleanup")
        return False  # re-raise exceptions if any
```

Usage:

```python
with MyContext():
    print("Doing work")
```

---

# ✅ Best and Correct Ways to Create Context Managers

---

## ✔️ Option 1 — Using `contextlib.contextmanager` (Most Practical)

Best for **simple** context logic.

```python
from contextlib import contextmanager

@contextmanager
def db_session(conn):
    try:
        cursor = conn.cursor()
        yield cursor
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        cursor.close()
```

Usage:

```python
with db_session(conn) as cur:
    cur.execute("INSERT...")
```

Benefits:

* Clean & readable
* Less boilerplate
* Best for ETL / backend apps

---

## ✔️ Option 2 — Using Class-Based Context Manager

Best when state must be maintained.

Example: timed execution logger

```python
import time

class Timer:
    def __enter__(self):
        self.start = time.time()
        return self

    def __exit__(self, *args):
        self.end = time.time()
        self.elapsed = self.end - self.start
```

Usage:

```python
with Timer() as t:
    run_heavy_task()

print(t.elapsed)
```

Use this when:

* Need attributes after block
* Need reusable objects
* More complex logic

---

## ✔️ Option 3 — Using `ExitStack` (ADVANCED)

Useful when:

* You need multiple context managers dynamically
* Count unknown beforehand

```python
from contextlib import ExitStack

with ExitStack() as stack:
    files = [stack.enter_context(open(f)) for f in filenames]
    # use all files safely
```

Great for ETL pipelines reading:

* many input files
* dynamically discovered resources

---

# 🛡️ Handling Exceptions Correctly

### Returning `True` in `__exit__`

Means:

* Exception handled
* DO NOT propagate

Example swallowing exception:

```python
def __exit__(self, exc_type, exc, tb):
    return True
```

Be careful — only swallow when intentional.
Most production systems should **not swallow silently**.
Preferred:

```python
return False
```

This keeps exception propagation.

---

# 🧵 Context Managers + Concurrency

### Locks

Correct way:

```python
from threading import Lock
lock = Lock()

with lock:
    critical_section()
```

Avoid:

```python
lock.acquire()
try:
    critical_section()
finally:
    lock.release()
```

Same behavior, more error-safe.

---

### ThreadPool Executors

```python
from concurrent.futures import ThreadPoolExecutor

with ThreadPoolExecutor(max_workers=5) as pool:
    pool.map(process_item, items)
```

Automatically:

* shuts down pool
* waits for tasks
* prevents stuck thread leaks

---

# 🗃️ Context Managers in Database Handling

### SQLAlchemy

```python
with Session() as session:
    with session.begin():
        session.add(obj)
```

Guarantees:

* rollback on exception
* commit on success

---

### Psycopg (Postgres)

```python
with conn, conn.cursor() as cur:
    cur.execute(...)
```

---

# 📡 Requests Session Handling

```python
import requests

with requests.Session() as s:
    s.get(...)
```

Ensures:

* connection pool closed
* TCP cleanup

---

# 🧪 Testing Use Cases

### Temporary environment overrides

```python
import os
from contextlib import contextmanager

@contextmanager
def temp_env(name, value):
    old = os.getenv(name)
    os.environ[name] = value
    try:
        yield
    finally:
        if old is None:
            del os.environ[name]
        else:
            os.environ[name] = old
```

Usage:

```python
with temp_env("MODE", "TEST"):
    run()
```

---

# 📜 Context Managers + Logging

### Example: Structured Execution Block Logger

```python
from contextlib import contextmanager
import logging
import time

log = logging.getLogger()

@contextmanager
def log_block(name):
    start = time.time()
    log.info(f"Start {name}")
    try:
        yield
        log.info(f"End {name} success in {time.time() - start}s")
    except Exception as e:
        log.error(f"{name} failed: {e}")
        raise
```

Usage:

```python
with log_block("ETL Job"):
    run_pipeline()
```

Perfect for:

* ETL
* Batch processing
* Scheduled jobs

---

# 🚫 Common Mistakes

### ❌ Forgetting to return False in `__exit__`

Silently hides crashes

### ❌ Using try/finally everywhere instead of context managers

Bad readability
Hard to maintain

### ❌ Implementing cleanup manually

Error-prone

### ❌ Creating over-complex context managers

Prefer `contextmanager` decorator unless persistent state needed

---

# 🧭 Quick Decision Guide

| Need                            | Use                   |
| ------------------------------- | --------------------- |
| Simple setup/cleanup            | `@contextmanager`     |
| Need object state after context | Class context manager |
| Multiple dynamic resources      | ExitStack             |
| DB Transactions                 | Context always        |
| Locks / concurrency             | Context always        |
| Logging / tracing block         | Context great choice  |
| Reusable libraries              | Prefer class          |
| Internal quick utility          | Prefer decorator      |

---

# 🎯 Final Takeaways

Context managers:

* Make code safe
* Prevent resource leaks
* Improve readability
* Centralize cleanup logic
* Critical for production systems
* MUST be used in ETL, backend APIs, DB, concurrency, file IO
