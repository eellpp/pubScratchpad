# 🧰 Python `typing` Module – User Guide

---

## 1️⃣ Why typing matters in real projects

Even in dynamic Python, type hints give you:

* 📎 Better IDE auto-complete
* 🧠 Earlier bug detection (mypy / pyright)
* 📚 Self-documenting code
* 🧪 Safer refactoring
* 🧩 Clearer contracts across large teams

Typing **does not affect runtime behavior** (unless you intentionally use validators like Pydantic or runtime checkers). It’s mostly **for tooling + humans**.

---

## 2️⃣ Enabling typing

Just annotate functions, classes, variables.

```python
def add(a: int, b: int) -> int:
    return a + b
```

This communicates:

* parameters must be `int`
* return value is `int`

---

## 3️⃣ Modern type syntax (Python 3.9+)

Prefer **built-in collection types**:

✔ Modern:

```python
list[str]
dict[str, int]
tuple[int, float]
```

❌ Older:

```python
from typing import List, Dict, Tuple
```

Use the modern form unless stuck on old Python.

---

## 4️⃣ Optional, Union & Literal

### Optional

`Optional[T]` means `T` or `None`.

```python
def find(id: int) -> Optional[str]:
    ...
```

Modern equivalent:

```python
def find(id: int) -> str | None:
    ...
```

---

### Union

Either type:

```python
def parse(value: int | str) -> str:
    ...
```

Old syntax:

```python
Union[int, str]
```

---

### Literal

Restrict values to specific allowed values.

Useful for:

* enum-like choices
* API flags
* mode values

```python
from typing import Literal

def read(mode: Literal["r", "w", "a"]) -> None:
    ...
```

---

## 5️⃣ Typed collections for real world

### Typed dicts

Useful in ETL / JSON / API scenarios.

```python
from typing import TypedDict

class User(TypedDict):
    id: int
    name: str
    email: str | None
```

Usage:

```python
def process_user(u: User):
    print(u["id"])
```

Why this matters:

* prevents key typos
* validates shapes statically
* excellent for data pipelines & API schemas

---

## 6️⃣ Protocols (duck typing with structure)

Great for dependency injection, testing, clean architecture.

```python
from typing import Protocol

class Notifier(Protocol):
    def send(self, message: str) -> None:
        ...
```

Anything with `send(str)` is accepted — no inheritance required.

Works great for:

* replacing concrete DB / S3 / Kafka clients
* unit testing
* plugin systems

---

## 7️⃣ Callable types

Useful for callback-style APIs or ETL transforms.

```python
from typing import Callable

Processor = Callable[[str, int], bool]
```

Or inline:

```python
def run_task(fn: Callable[[int], str]) -> None:
    ...
```

---

## 8️⃣ TypeVar and Generics

### Simple Generics

Reusable type logic.

```python
from typing import TypeVar, Generic

T = TypeVar("T")

def first(items: list[T]) -> T:
    return items[0]
```

Now:

```python
first([1,2,3]) → int
first(["a","b"]) → str
```

Useful for reusable ETL helpers, repo layers, caches.

---

### Bound TypeVar

Restrict to subtype.

```python
T = TypeVar("T", bound=BaseModel)
```

---

## 9️⃣ Self (modern, Python 3.11+)

For methods that return `self`.

```python
from typing import Self

class Builder:
    def configure(self) -> Self:
        return self
```

Great for builder patterns and fluent APIs.

---

## 🔟 Annotated (attach metadata)

Useful for validation frameworks, FastAPI, etc.

```python
from typing import Annotated
from typing import Optional

UserId = Annotated[int, "must be positive"]
```

Frameworks can interpret annotations to enforce validation / docs.

---

## 1️⃣1️⃣ TypeAlias and NewType

### Named aliases

For clarity.

```python
from typing import TypeAlias

UserId: TypeAlias = int
```

---

### New logical distinct types

Still int underneath but different meaning.

```python
from typing import NewType

UserId = NewType("UserId", int)
OrderId = NewType("OrderId", int)
```

Prevents:

```python
process(UserId(5))
process(OrderId(5))  # ❌ type checker will warn
```

Excellent for finance, ETL, safe domain modeling.

---

## 1️⃣2️⃣ Dataclasses typing

Works same as classes:

```python
from dataclasses import dataclass

@dataclass
class Order:
    id: int
    amount: float
```

Add immutability:

```python
@dataclass(frozen=True)
class Event:
    name: str
```

---

## 1️⃣3️⃣ Async typing

```python
from typing import Awaitable

def fetch() -> Awaitable[str]:
    ...
```

---

## 1️⃣4️⃣ Common “production mistakes” to avoid

### ❌ Over-typing

Bad:

```python
def f(x: int | str | float | list | dict) -> Any:
```

Typing should **clarify**, not confuse.

---

### ❌ Ignoring `None`

If a value can be None — type it.
If it cannot — don’t.

---

### ❌ Using `Any` too much

`Any` turns typing off like a virus.

Prefer:

* `Unknown` patterns
* Explicit types
* Proper generics

But use `Any` wisely when:

* 3rd-party untyped libs
* APIs with unknown schemas

---

## 1️⃣5️⃣ Running static type checks

Install:

```bash
pip install mypy
```

Run:

```bash
mypy src/
```

For stricter, safer code:

```bash
mypy --strict src/
```

Pyright (faster, great in VS Code):

```bash
pip install pyright
pyright
```

---

## 1️⃣6️⃣ What to type in real systems?

### ❤️ APIs / Web Services

Type:

* request models
* response models
* service layers
* DB layer
* external API clients

Often use:

* `TypedDict`
* dataclasses / pydantic models
* Protocols
* Literal for API modes

---

### 📊 ETL / Data Engineering

Type:

* schema shapes
* transformation functions
* identifiers (`NewType`)
* pipeline stages

Benefits:

* prevents column/key mistakes
* safer refactoring
* self-documenting transformations

---

### ⚙️ Backend Services

Type:

* domain models
* repositories
* command handlers
* interfaces

Use:

* Protocol
* NewType
* Generic repos
* Optional + Union carefully

---

## 🏁 Final Guidance

### ✔ If starting fresh

* Use modern syntax (`list[str]`, `str | None`)
* Type important boundaries
* Use TypedDict or dataclasses for structured data
* Add mypy / pyright to CI
* Don’t chase 100% coverage — prioritize clarity

---

### ✔ If migrating legacy code

* Add types gradually
* Start at service boundaries
* Avoid breaking changes
* Enable `--strict` later

---

### TL;DR

* `typing` adds safety without runtime cost.
* Modern Python prefers:

  * `list[str]` not `List[str]`
  * `str | None` not `Optional[str]`
* Use:

  * `TypedDict` for JSON / ETL
  * `Protocol` for interfaces
  * `NewType` for meaningful domain identities

