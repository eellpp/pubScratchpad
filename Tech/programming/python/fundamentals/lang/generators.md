# 🧠 Python Generators — A Practical User Guide

## ✅ What is a Generator?

A **generator** is a special function that:

* produces values **one at a time** instead of returning all at once
* remembers its execution state automatically
* is **lazy** (computes only when asked)
* is memory efficient
* supports streaming behavior

Instead of creating a full list:

```python
def numbers():
    return [1, 2, 3]
```

A generator yields values one by one:

```python
def numbers():
    yield 1
    yield 2
    yield 3
```

Use:

```python
for n in numbers():
    print(n)
```

---

# 🧵 Why Generators Matter in Real Projects

Generators help when:
✔️ Data is huge
✔️ Data is streaming / continuous
✔️ We want performance
✔️ We want memory efficiency
✔️ We want clean stop/resume semantics

---

# 🏎️ Key Benefits

| Feature            | Why it matters                            |
| ------------------ | ----------------------------------------- |
| Lazy evaluation    | Load/compute only when needed             |
| Memory efficient   | Process TBs without RAM explosion         |
| Streaming          | Works well with APIs, Kafka, sockets      |
| Backpressure       | Consumers control speed                   |
| Clean iteration    | Less complex than manual iterators        |
| Better performance | Avoids building huge structures           |
| Readable           | Declarative style replaces loops & states |

---

# 🧰 Generator Basics

## ✔️ Creating Generators

### 1️⃣ Generator Function

Uses `yield`.

```python
def count_up_to(n):
    i = 1
    while i <= n:
        yield i
        i += 1
```

Usage:

```python
for i in count_up_to(5):
    print(i)
```

---

### 2️⃣ Generator Expression

Like list comprehension but lazy.

List comprehension:

```python
squares = [x*x for x in range(1_000_000)]
```

Generator:

```python
squares = (x*x for x in range(1_000_000))
```

---

# 🧮 Understanding Generator Execution

A normal function:

* runs immediately
* returns a value
* exits

A generator:

* returns a generator object immediately
* runs only when iterated
* pauses at `yield`
* resumes next line on next iteration

---

# 🔍 What happens on each iteration?

```python
def demo():
    print("Start")
    yield 1
    print("Resume")
    yield 2
```

Output:

```
Start
Resume
```

Execution flow:

* enters function
* runs until yield
* pauses
* resumes next time

---

# 🚨 Generator Stop Condition

When `yield` ends,
Python raises `StopIteration` internally.
For loops handle this for you — you never see it.

---

# 🧩 Practical Engineering Use Cases

---

## 1️⃣ Process Huge Files (ETL / Logs)

### ❌ BAD — loads entire file

```python
lines = open("data.log").readlines()
```

### ✅ GOOD — streams line by line

```python
def read_log(path):
    with open(path) as f:
        for line in f:
            yield line
```

Use:

```python
for line in read_log("data.log"):
    process(line)
```

Memory = O(1)

Perfect for:

* Big CSVs
* Logs
* JSON lines
* Streaming pipeline

---

## 2️⃣ Stream API Data (Pagination / Batch APIs)

```python
def fetch_pages(api):
    page = 1
    while True:
        data = api(page)
        if not data:
            break
        yield from data
        page += 1
```

Use:

```python
for record in fetch_pages(api_call):
    process(record)
```

Supports:

* REST pagination
* Database pagination
* Cloud APIs

---

## 3️⃣ Infinite Streams (Useful!)

```python
def infinite_counter():
    n = 0
    while True:
        yield n
        n += 1
```

Use carefully; always break externally.

---

## 4️⃣ Pipelines — Generator Chaining

Just like Unix pipes.

```python
def read_lines(path):
    with open(path) as f:
        for line in f:
            yield line

def filter_errors(lines):
    for l in lines:
        if "ERROR" in l:
            yield l

def extract_timestamp(lines):
    for l in lines:
        yield l.split()[0]
```

Pipeline:

```python
log = read_lines("sys.log")
errors = filter_errors(log)
timestamps = extract_timestamp(errors)

for t in timestamps:
    print(t)
```

No extra lists.
Streaming.
Fast.

---

## 5️⃣ Producer → Consumer Workflows

```python
def numbers():
    for i in range(10):
        yield i

def doubled(values):
    for v in values:
        yield v * 2

for x in doubled(numbers()):
    print(x)
```

---

# 🧪 Generators in Testing

Simulate test data stream:

```python
def fake_events():
    yield {"id": 1}
    yield {"id": 2}
    yield {"id": 3}
```

---

# ⚙️ Generator Utilities

---

## `yield from`

Flatten nested generators.

Instead of:

```python
for x in gen():
    for y in x:
        yield y
```

Use:

```python
yield from gen()
```

---

## `send()` — Two-Way Communication

Advanced but powerful.
Allows external input back into generator.

---

# 🧵 Generator vs Iterator vs Iterable

| Concept   | Meaning                                        |
| --------- | ---------------------------------------------- |
| Iterable  | object returned in loops (`list`, `str`, file) |
| Iterator  | object that produces values one by one         |
| Generator | a special iterator created via `yield`         |

So:

* All generators are iterators
* Not all iterators are generators

---

# ⚠️ Common Mistakes

❌ Forgetting `yield` → becomes normal function
❌ Returning large lists when streaming is needed
❌ Converting generator back to list unnecessarily
❌ Assuming generators rewind — they don’t
❌ Using generators where random access needed

---

# 🧭 When NOT to Use Generators

Avoid if:

* Data needs indexing
* Need random access
* Need repeated traversal without recompute
* Need persistence
* Stored forever

---

# 🧭 Quick Decision Guide

| Requirement                 | Use       |
| --------------------------- | --------- |
| Stream data                 | Generator |
| Huge file                   | Generator |
| Endless data                | Generator |
| Performance critical        | Generator |
| Pagination API              | Generator |
| Simple constant data        | List      |
| Need indexing/random access | List      |
| Need multiple passes        | List      |

---

# 🎯 Final Takeaways

Generators are:

* memory efficient
* lazy
* perfect for ETL, APIs, streaming, large data
* support clean pipelines
* improve performance significantly

They are **critical tools** in production Python systems.
