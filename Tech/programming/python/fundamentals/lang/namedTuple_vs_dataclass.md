
# 1️⃣ `collections.namedtuple`

```python
from collections import namedtuple

Point = namedtuple("Point", ["x", "y"])
p = Point(10, 20)
```

### What it is

* A **dynamically created subclass of tuple**
* Lightweight, immutable
* Indexable like a tuple
* Attribute access like an object

```python
p[0]      # 10
p.x       # 10
```

### Features

✔ Immutable (by design)
✔ Very small memory footprint
✔ Fast
✔ Has helper methods:

```python
p._asdict()
p._replace(y=99)
p._fields
```

### Downsides

❌ No type hints support originally (only comments)
❌ Less readable (factory function, string field list)
❌ Harder to extend with methods
❌ Default values are awkward

---

# 2️⃣ `typing.NamedTuple` (modern class syntax)

```python
from typing import NamedTuple

class Point(NamedTuple):
    x: int
    y: int
```

Usage:

```python
p = Point(10, 20)
```

### What it is

* Still a **tuple subclass**
* But declared using **normal class syntax**
* Fully supports static typing

### Benefits over `namedtuple`

✔ Much more readable
✔ Type hints built-in
✔ Easy to add methods

```python
class Point(NamedTuple):
    x: int
    y: int

    def mag(self):
        return (self.x**2 + self.y**2)**0.5
```

✔ Supports defaults

```python
class Point(NamedTuple):
    x: int
    y: int = 0
```

### Downsides

❌ Still immutable
❌ Still behaves like tuple (which may surprise people sometimes)

---

# 3️⃣ `dataclasses.dataclass`

```python
from dataclasses import dataclass

@dataclass
class Point:
    x: int
    y: int
```

Usage:

```python
p = Point(10, 20)
```

### What it is

* **Regular class**
* Generates boilerplate:

  * `__init__`
  * `__repr__`
  * `__eq__`
  * Optional immutability

### Benefits

✔ Readable & Pythonic
✔ Type hints required (and enforced)
✔ Mutable by default (you *can* change values)
✔ Or make it immutable:

```python
@dataclass(frozen=True)
class Point:
    x: int
    y: int
```

✔ Supports defaults easily
✔ Supports methods
✔ Works naturally with inheritance
✔ Plays well with IDEs, linters, typing tools

### Downsides

❌ Slightly more memory than tuple types
❌ Slight overhead vs namedtuple (rarely matters)

---

# When to use which?

### Use `namedtuple`

* You need **very lightweight immutable objects**
* Performance/memory critical
* You don’t care about typing
* Very simple small structs

Example: parsing CSV rows, quick coordinate structures

---

### Use `typing.NamedTuple`

* You want **immutability + typing**
* You want readable class definition syntax
* You may add methods
* You like tuple behavior but want clarity

Example: lightweight domain objects in typed codebases

---

### Use `@dataclass`

* Best default choice today
* You want clarity + maintainability
* You may want mutability
* You may want methods / behavior
* You want easy defaults, inheritance, flexibility

Example: almost all model-ish Python objects

---

# Quick Summary Table

| Feature    | namedtuple      | NamedTuple              | dataclass             |
| ---------- | --------------- | ----------------------- | --------------------- |
| Base       | tuple           | tuple                   | normal class          |
| Immutable  | Yes             | Yes                     | Optional              |
| Type hints | No              | Yes                     | Yes                   |
| Syntax     | factory         | class                   | class                 |
| Memory     | smallest        | small                   | slightly more         |
| Best for   | minimal structs | typed immutable structs | modern Python classes |

