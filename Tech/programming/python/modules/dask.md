# 🧩 Dask User Guide (For Pipelines + Parallel Execution)

## 1. What is Dask (in your context)?

Dask is a library for **parallel and distributed computing** in Python.
For your use cases, the key thing Dask gives you is:

> A way to express **pipelines as a dependency graph (DAG)** and have them executed in **parallel** while respecting those dependencies.

You don’t manually manage threads/processes or their scheduling — Dask does that.

---

## 2. When to use Dask vs ProcessPoolExecutor

### ✅ Dask is a good fit when:

* You have **multi-step pipelines** with dependencies:

  * `load → clean → analyze → summarize`
  * Many inputs (e.g. many files) flowing through the same pipeline.
* You want to:

  * Build the whole computation as a **graph**, then run it.
  * Possibly scale out later (bigger machine / cluster).
  * Visualize / inspect your pipeline.

### ✅ ProcessPoolExecutor is usually better when:

* You just have **independent tasks**:

  * “Run this function on 50 different arguments, 5 at a time, no dependencies.”
* You don’t need a DAG, just a pool of workers.
* You prefer the simplicity of:

  ```python
  with ProcessPoolExecutor(max_workers=5) as ex:
      futures = [ex.submit(func, arg) for arg in args]
  ```

**Rule of thumb:**

* **Independent jobs → ProcessPoolExecutor**
* **Dependent pipelines / DAGs → Dask**

---

## 3. Core Concepts in Dask

### 3.1 Task Graph (DAG)

Dask builds a **Directed Acyclic Graph**:

* **Nodes** = tasks (functions + their arguments)
* **Edges** = dependencies (task B needs result of task A)

Dask’s scheduler:

* Runs tasks whose dependencies are satisfied.
* Parallelizes independent tasks.
* Preserves order where dependencies exist.

---

### 3.2 Lazy Execution with `dask.delayed`

`dask.delayed` lets you turn ordinary Python functions into **lazy tasks**.

You write:

```python
from dask import delayed

@delayed
def load(path): ...

@delayed
def clean(df): ...

@delayed
def analyze(df): ...

@delayed
def summarize(results): ...
```

Then build a pipeline:

```python
paths = ["file1.csv", "file2.csv", ...]

lazy_results = []
for p in paths:
    df = load(p)
    clean_df = clean(df)
    res = analyze(clean_df)
    lazy_results.append(res)

final = summarize(lazy_results)
```

At this point:

* Nothing has run yet.
* You just have a **graph** describing what to do.

To execute:

```python
result = final.compute()
```

Dask then schedules everything in parallel where possible.

---

### 3.3 Schedulers

Dask can run on:

* `scheduler="threads"` → thread pool in **one process**
* `scheduler="processes"` → local **process** pool
* `scheduler="distributed"` → external Dask cluster (separate scheduler + workers)

You choose at `.compute()` time:

```python
final.compute(scheduler="threads")
# or:
final.compute(scheduler="processes")
```

---

## 4. Dependent Pipelines in Practice

### Example: per-file pipeline + global summary

```python
from dask import delayed

@delayed
def load_data(path):
    ...

@delayed
def clean_data(df):
    ...

@delayed
def analyze(df):
    ...

@delayed
def summarize(results):
    ...
```

Build the graph:

```python
paths = [f"file_{i}.csv" for i in range(10)]

lazy_results = []
for p in paths:
    df = load_data(p)
    clean = clean_data(df)
    res = analyze(clean)
    lazy_results.append(res)

final = summarize(lazy_results)
summary = final.compute()  # executes DAG
```

What Dask does:

* `load_data(file_0)...load_data(file_9)` → independent, run in parallel.
* `clean_data` for a file waits for its corresponding `load_data`.
* `analyze` waits for its `clean_data`.
* `summarize` waits for **all** `analyze` tasks.

This gives you **pipeline parallelism**: stage 2 for file A can start as soon as stage 1 for file A is done, even while stage 1 for file B is still running.

---

## 5. Error Handling in Dask Pipelines

### 5.1 Default behaviour (unhandled exception)

If some task (say `analyze(clean_df)` for file 3) raises:

* That task is marked as **errored**.
* All **downstream tasks** depending on it are also marked errored.
* Other independent branches can still succeed.
* `.compute()` on the final node (`final`) will raise that exception (first relevant one).

You don’t get partial results + error list by default. You get an exception at compute time.

---

### 5.2 Pattern for “partial success” pipelines

If you want “run everything, collect which ones failed”, wrap your function in a **safe task**:

```python
from dask import delayed

@delayed
def safe_analyze(df, path):
    try:
        result = analyze(df)
        return {"path": path, "ok": True, "result": result, "error": None}
    except Exception as e:
        return {"path": path, "ok": False, "result": None, "error": repr(e)}
```

Then:

```python
lazy_results = []
for p in paths:
    df = load_data(p)
    clean = clean_data(df)
    res = safe_analyze(clean, p)
    lazy_results.append(res)

final = summarize(lazy_results)  # summarize handles ok/failed entries
summary = final.compute()
```

Now:

* Dask sees no unhandled exceptions.
* All tasks run.
* Final summary can decide what to do with failures.

This is the **production-friendly** way when you want robustness.

---

## 6. Logging in Dask Pipelines

Your requirement: **“all logs should be in a single log file of the parent process”**.

### 6.1 Using the threaded scheduler (recommended if possible)

If you run with:

```python
final.compute(scheduler="threads")
```

Then:

* All tasks run in the **same process** (different threads).
* You can configure logging once at the top:

```python
import logging

logging.basicConfig(
    filename="pipeline.log",
    level=logging.INFO,
    format="%(asctime)s [%(threadName)s] %(levelname)s %(name)s: %(message)s",
)

log = logging.getLogger("pipeline")
```

In tasks:

```python
def load_data(path):
    log.info("Loading %s", path)
    ...
```

Result:
All logs go into **one file**, with thread names to distinguish concurrent tasks.
This is the easiest way to match your “single parent log file” goal.

---

### 6.2 Using the processes scheduler

If you run with:

```python
final.compute(scheduler="processes")
```

Then:

* Dask uses multiple **processes**.
* Each process has its own logging context.
* If you configure logging with the same `filename="pipeline.log"` in each process:

  * They all append to the same file.
  * This usually works OK, but:

    * lines may interleave
    * rotation is more complex
* Dask itself does **not** automatically forward worker logs back to a central logger.

To get strict centralization (parent-only writing), you’d need a **QueueHandler/QueueListener** pattern so workers send logs over a queue to a central logger. That’s doable but more involved.

**Practical advice:**
If you don’t absolutely need multi-process speed and you care about simple, clean logging → prefer the **threaded scheduler**.

---

## 7. Scheduler Choice Cheat Sheet

### `scheduler="threads"`

Use when:

* Tasks are I/O-bound or release the GIL (NumPy, Pandas, etc.).
* You want **easy logging** into a single file.
* Single-machine environment.

### `scheduler="processes"`

Use when:

* Tasks are CPU-bound pure Python (GIL-heavy).
* You really need multiple cores for speed.
* You’re OK with multi-process logging caveats or you implement a centralized logging pattern.

### Distributed scheduler

Use when:

* You need to scale beyond a single machine.
* You want advanced cluster features, monitoring UI, etc.
* Out of scope for your current scripts, but good to know it exists.

---

## 8. Quick Comparison: Dask vs ProcessPoolExecutor

| Aspect                | Dask (`delayed`)                       | ProcessPoolExecutor                      |
| --------------------- | -------------------------------------- | ---------------------------------------- |
| Model                 | DAG of dependent tasks                 | Flat pool of independent tasks           |
| Dependencies          | Native (based on function arguments)   | Manual (you orchestrate order yourself)  |
| Lazy execution        | Yes (`.compute()`)                     | No (submissions start immediately)       |
| Pipelines             | Natural fit                            | You must encode control flow manually    |
| Logging (simple case) | Easy with `threads` scheduler          | Needs central logging if using processes |
| Best for              | Pipelines, graphs, ETL, multi-step ops | Simple parallel loops, independent jobs  |
| Scaling out           | Dask has built-in path to clusters     | Not designed for clusters                |

---

## 9. Practical Recommendations for You

Based on what you’ve been asking:

1. **For 50 independent calls, 5 at a time** →
   Use `ProcessPoolExecutor` (simpler and perfectly adequate).

2. **For multi-step pipelines on many inputs** (load → clean → analyze → summarize, etc.) →
   Dask with `dask.delayed` is a great fit:

   * Express the pipeline as a DAG
   * Use `final.compute(scheduler="threads")`
   * Configure logging once, enjoy a single log file.

3. For **robustness**:

   * Wrap “risky” stages in `safe_*` delayed functions that catch exceptions and return structured `{ok, result, error}` objects.
   * Let the final aggregation step decide how to handle failures.

