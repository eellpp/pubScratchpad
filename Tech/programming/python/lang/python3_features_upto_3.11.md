# ✅ Modern Python Language Features You Should Know

---

## 1️⃣ Data Classes (Python 3.7+)

Simplifies class boilerplate for “data objects”.

```python
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str
    active: bool = True
```

Benefits
✔ Auto `__init__`, `__repr__`, `__eq__`
✔ Type-aware
✔ Optional immutability with `frozen=True`
✔ Performance with `slots=True` (Python 3.10+)

Use Cases

* API models
* ETL records
* Config/value types

---

## 2️⃣ Type Hints & Modern Typing (Python 3.5+ → hugely improved 3.10+)

Python now has powerful static typing support.

```python
def process(user: User) -> bool:
    ...
```

Modern typing additions:
✔ `Union` shortcut → `str | int`
✔ `Optional[X]` → `X | None`
✔ `TypedDict` (structured dicts)
✔ `Protocol` (interface-like behavior)
✔ `Literal` (constrained values)
✔ `Final`, `Annotated`

Helps:

* large projects
* correctness
* IDE autocompletion
* maintainability

---

## 3️⃣ Enum (Python 3.4+)

Human-readable constants.

```python
from enum import Enum

class Status(Enum):
    SUCCESS = "success"
    FAILED = "failed"
```

Much safer than magic strings / integers.

---

## 4️⃣ F-Strings (Python 3.6+)

Fast, readable string formatting.

```python
user = "Tom"
print(f"Hello {user}")
```

Extras:

```python
print(f"{value=}")   # shows name + value
```

---

## 5️⃣ Assignment Expression “Walrus Operator” (Python 3.8+)

Assign inside expressions.

```python
if (data := fetch()):
    handle(data)
```

Useful in:

* reading streams
* loops
* conditionals
* performance-sensitive code

---

## 6️⃣ Structural Pattern Matching (Python 3.10+)

Python’s version of `switch`, but much more powerful.

```python
match event:
    case {"type": "login", "user": name}:
        ...
    case {"type": "logout"}:
        ...
    case _:
        ...
```

Great for:

* JSON events
* API payloads
* DSL parsing
* ETL pipelines

---

## 7️⃣ Keyword-Only & Positional-Only Parameters

### Positional-only (Python 3.8+)

```python
def add(a, b, /):
    return a + b
```

### Keyword-only

```python
def load(path, *, encoding="utf8"):
    ...
```

Helps:

* API stability
* clarity
* preventing misuse

---

## 8️⃣ Async / Await (Modern Asyncio)

Modern async ecosystem is production-ready.

```python
async def fetch():
    return await http.get(url)
```

Great for:

* web services
* streaming
* API clients
* IO-heavy ETL

Also includes:

* async context managers
* async generators

---

## 9️⃣ `pathlib` (Modern File Handling)

Replaces `os.path` with an object-oriented approach.

```python
from pathlib import Path
p = Path("data.txt")
print(p.read_text())
```

Much cleaner for:

* filesystem code
* ETL input handling
* config paths

---

## 🔟 `contextlib` Enhancements

Better resource management.

```python
from contextlib import contextmanager

@contextmanager
def resource():
    setup()
    yield
    cleanup()
```

Also:

* `ExitStack`
* `suppress`
* async versions

---

## 1️⃣1️⃣ Caching & Performance Helpers

### `functools.cached_property`

Compute once → reuse.

```python
from functools import cached_property

class Report:
    @cached_property
    def data(self):
        return load_big_dataset()
```

---

## 1️⃣2️⃣ Better Itertools & Generators

Python has leaned heavily into lazy evaluation patterns:

* generator expressions
* `yield from`
* `itertools` functional power tools

Great for ETL & streaming systems.

---

## 1️⃣3️⃣ Modern Exceptions & Cleaner Error Handling

Exception groups (Python 3.11)

```python
except* ValueError:
```

Helpful for concurrency / async workloads.

---

## 1️⃣4️⃣ Performance & Runtime Improvements

Python 3.11+ specifically:

* significantly faster execution
* better tracing
* better startup performance

No code changes needed — just upgrade.

---

# 🧭 Quick Comparison Summary

| Feature                | Why It Exists                   |
| ---------------------- | ------------------------------- |
| Dataclasses            | lightweight data models         |
| Typing                 | correctness + maintainability   |
| Enum                   | human readable constants        |
| F-Strings              | cleaner + faster formatting     |
| Walrus                 | cleaner expressions             |
| Pattern Matching       | expressive control flow         |
| Async                  | scalable IO concurrency         |
| Pathlib                | modern file handling            |
| Contextlib             | safe resource cleanup           |
| cached_property        | lazy efficiency                 |
| Itertools / Generators | streaming pipelines             |
| Exception Groups       | structured async error handling |

---

# 🎯 Final Takeaway

Modern Python is:

* safer (typing + enums)
* faster (runtime improvements)
* cleaner (dataclasses, f-strings, pathlib)
* more expressive (pattern matching, async)
* more scalable (async, generators, typing)
