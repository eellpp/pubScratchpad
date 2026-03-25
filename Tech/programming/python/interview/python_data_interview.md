
# 🧠 1. Core Python (Data Engineering Context)

### 🔹 Data Structures & Performance

1. When would you choose `list` vs `deque`  in a data pipeline?
```text
Quick rule of thumb
Use:
- list for general batching and normal record processing
- deque for queues, sliding windows, and frequent front removals
- array for memory-efficient storage of large homogeneous primitive values

In real data engineering
Most of the time:
- list is the default
- deque is chosen for queue/window mechanics. Choose deque when you need fast pushes/pops from both ends.

Interview-quality follow-up
A strong candidate should also say:
If the dataset is truly large, I would avoid relying on any of these as the primary storage structure and instead use streaming, chunking, disk-backed staging, or columnar tools like PyArrow/NumPy/Pandas depending on the workload.
```
3. Explain memory implications of large Python lists vs generators.

```text
Lists: Stores all values in memory at once
Generator: Produces values one at a time (lazy evaluation)

generator : data = (x*x for x in range(10_000_000))
- low memory footprint: data is not all loaded to memeory
- Generators reduce memory but not CPU . Computation still happen but is just deferred

reading all the lines of a big file vs reading the file using generator

```


5. What are the time complexities of common dict operations, and when do they degrade?
6. How would you handle deduplication of a 100M-row dataset in Python?
```text
Practical production answer
For a 100M-row dataset in Python, my preferred order is usually:
If I must stay on one machine
DuckDB / SQLite / external sort
or hash partition + partition-level dedup
If the data is already in parquet / analytics stack
use DuckDB / Spark / Polars / SQL engine
Only if keys are small and memory is sufficient
stream rows and keep a set of seen keys
```

* You are given a very large CSV file (~50GB). Each row needs to be: parsed, filtered, transformed written to an output file

Version A
```python
def read_data(file):
    return [parse(line) for line in file]

def filter_data(data):
    return [row for row in data if is_valid(row)]

def transform_data(data):
    return [transform(row) for row in data]

data = read_data(open("input.csv"))
data = filter_data(data)
data = transform_data(data)

for row in data:
    write(row)
```

Version B
```python
def read_data(file):
    for line in file:
        yield parse(line)

def filter_data(data):
    for row in data:
        if is_valid(row):
            yield row

def transform_data(data):
    for row in data:
        yield transform(row)

data = read_data(open("input.csv"))
data = filter_data(data)
data = transform_data(data)

for row in data:
    write(row)
```
What are the memory implications?  
- version A O(n)  
- version B O(1)

Can you reuse data in Version B?  
- No, generators are one-time iterators 

What happens if you do list(transform_data(...))
- converting to list breaks streaming and will consume large amount of memory
---

### 🔹 Iteration & Streaming

5. What is the difference between:

   * iterable
   * iterator
   * generator

6. How would you process a 10GB CSV file efficiently in Python?

7. What is `yield from` and when is it useful in pipeline design?

---

### 🔹 File Handling

8. How do you safely read/write large files in Python?
   
To safely read large files in Python, I would use with open(...) and stream the file line by line or in fixed-size chunks instead of calling read() or readlines(). 
For writing, I would write incrementally rather than building the full output in memory. If the output is important, I would write to a temporary file, flush and optionally fsync, then atomically replace the target file with os.replace() so partial files are never exposed. I would also be explicit about encoding, handle IO exceptions, and use structured readers like csv for structured text formats.

```python
try:
    with open("input.txt", "r", encoding="utf-8") as f:
        for line in f:
            process(line)
except OSError as e:
    logger.exception("File operation failed: %s", e)
```

```python
with open("out.txt", "w", encoding="utf-8") as f:
    for row in generate_rows():
        f.write(format_row(row))
```

10. What is the difference between buffered vs unbuffered IO?
11. How would you implement chunk-based file processing?

---

# ⚙️ 2. Python for Data Pipelines

### 🔹 Serialization & Formats

11. Compare:

* JSON
* Pickle
* Parquet (conceptually)

12. Why is Pickle unsafe in production systems?

13. How would you stream JSON parsing for large files?

---

### 🔹 Error Handling

14. How should exception handling be designed in a data pipeline?
15. When should you:

* retry
* fail fast
* send to DLQ (dead letter queue)

16. What is the cost of exceptions in Python?

---

### 🔹 Logging & Observability

17. How would you design structured logging in Python?
18. Difference between:

* `print`
* `logging`
* structured logs (JSON logs)

---

# 🚀 3. Concurrency & Parallelism

### 🔹 Core Concepts

19. Difference between:

* threading
* multiprocessing
* asyncio

20. Why does the GIL matter in data engineering?

---

### 🔹 Practical Use

21. When would you use multiprocessing for ETL jobs?

22. How do you avoid memory explosion when using multiprocessing?

23. What is the difference between:

```python
map()
concurrent.futures.ThreadPoolExecutor
ProcessPoolExecutor
```

---

### 🔹 Async IO

24. When is `asyncio` useful in data pipelines?
25. Explain backpressure in async pipelines.

---

# 🧩 4. Python 3.9-Specific & Modern Practices

This is where you differentiate **modern Python devs** from legacy ones.

---

### 🔹 Dictionary Merge (`|` operator) — NEW in 3.9

26. What does this do?

```python
a = {"x": 1}
b = {"y": 2}
c = a | b
```

👉 Follow-up:

* Difference from `update()`?
* When is this safer?

---

### 🔹 Type Hinting Improvements

27. What changed in Python 3.9 regarding type hints?

Example:

```python
list[int]   # instead of List[int]
```

👉 Why is this important for:

* data pipelines
* large codebases

---

### 🔹 Standard Collections Generics

28. Why is this better?

```python
dict[str, int]
```

instead of:

```python
from typing import Dict
```

---

### 🔹 String Methods

29. What does `removeprefix()` and `removesuffix()` do?

👉 Where is it useful in ETL pipelines?

---

### 🔹 ZoneInfo (Timezones) — NEW

30. What is `zoneinfo` module?

👉 Why is it important for:

* financial data
* distributed systems

---

# 🧱 5. Memory & Performance

### 🔹 Object Model

31. What is the difference between:

* shallow copy
* deep copy

32. What is `__slots__` and when would you use it?

---

### 🔹 Generators vs Lists

33. Compare:

```python
[x*x for x in range(10_000_000)]
(x*x for x in range(10_000_000))
```

👉 Memory + execution tradeoff?

---

### 🔹 Profiling

34. How do you find bottlenecks in Python code?

Tools:

* `cProfile`
* `line_profiler`
* memory profilers

---

# 🏗️ 6. Real-World Scenario Questions

### 🔹 Scenario 1: Large Data Processing

> You need to process 50GB of logs daily on a single machine.

Ask:

* How would you design this in Python?
* What libraries/tools would you use?
* How do you ensure fault tolerance?

---

### 🔹 Scenario 2: API Data Ingestion

> You are pulling data from a rate-limited API.

Ask:

* How do you handle retries and backoff?
* How do you parallelize safely?

---

### 🔹 Scenario 3: Idempotent Pipelines

> Your job fails halfway. How do you restart safely?

---

### 🔹 Scenario 4: Data Consistency

> You are writing to S3 / DB. How do you ensure:

* no duplicates
* no missing records

---

# 🧪 7. Code Review / Practical Questions

### 🔹 Example 1

```python
def process(data):
    result = []
    for d in data:
        result.append(transform(d))
    return result
```

Ask:

* What is wrong for large datasets?
* How to fix?

---

### 🔹 Example 2

```python
def read_file(path):
    return open(path).read()
```

Ask:

* Problems?
* Fix for production?

---

# 🎯 8. Senior-Level Deep Questions

These are high-signal questions.

1. How does Python memory management affect long-running pipelines?
2. What are tradeoffs between Python vs Spark vs DuckDB?
3. How would you design a Python-based streaming engine?
4. How do you ensure reproducibility in data pipelines?

---

# 🧭 What This Evaluates

This set helps you detect:

| Skill                            | Signal                        |
| -------------------------------- | ----------------------------- |
| Real data engineering experience | Streaming, memory awareness   |
| Modern Python knowledge          | 3.9 features                  |
| System thinking                  | Scenarios                     |
| Production maturity              | Logging, retries, idempotency |

---

If you want, I can:

* Turn this into a **scoring rubric**
* Create **hands-on coding test**
* Or generate **"good vs bad answers" cheat sheet** (very useful for interviews)
