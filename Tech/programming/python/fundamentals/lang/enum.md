# 🧠 Python `enum` — User Guide

## ✅ What is an Enum?

An Enum (enumeration) represents a **fixed set of symbolic values**.

Instead of using fragile strings or integers:

```python
status = "OK"     # typo risk
status = 1        # unclear meaning
```

Use Enum:

```python
from enum import Enum

class Status(Enum):
    OK = "ok"
    ERROR = "error"
```

Benefits:

* Readable
* Type-safe
* Prevents invalid values
* Better than magic strings/numbers
* IDE autocompletion
* Stronger contract in APIs

---

# 🚀 Basic Usage

```python
from enum import Enum

class Status(Enum):
    SUCCESS = "success"
    FAILED = "failed"
    PENDING = "pending"
```

### Accessing

```python
Status.SUCCESS
Status.SUCCESS.value
Status.SUCCESS.name
```

Output:

```
Status.SUCCESS
"success"
"SUCCESS"
```

### Compare

Always compare by identity:

```python
if status is Status.SUCCESS:
    ...
```

Comparing to raw strings is **not ideal**, but possible:

```python
status.value == "success"
```

---

# 🏗 Types of Enums

---

## 1️⃣ Normal Enum

Best default choice.

```python
from enum import Enum
class Color(Enum):
    RED = 1
    BLUE = 2
```

---

## 2️⃣ `IntEnum`

Behaves like integers **but still Enum safe**.

Useful for:

* DB storage as int
* Protocol codes
* Legacy systems

```python
from enum import IntEnum

class Code(IntEnum):
    OK = 200
    NOT_FOUND = 404
```

Supports numeric comparisons:

```python
Code.OK == 200     # True
```

---

## 3️⃣ `StrEnum` (Python 3.11+)

Behaves like string — **highly useful for APIs**.

```python
from enum import StrEnum

class Role(StrEnum):
    USER = "user"
    ADMIN = "admin"
```

Now:

```python
Role.ADMIN == "admin"   # True
```

Best for:

* REST API responses
* JSON models
* Config values

---

## 4️⃣ `Flag` and `IntFlag`

Bitwise flags (advanced).

```python
from enum import Flag, auto

class Permission(Flag):
    READ = auto()
    WRITE = auto()
    EXECUTE = auto()
```

Use:

```python
perm = Permission.READ | Permission.WRITE
```

Useful for:

* OS permissions
* Feature toggles
* Bitmask systems

---

# 🔧 `auto()` — Auto Assign Values

Avoid manually assigning values:

```python
from enum import Enum, auto

class State(Enum):
    STARTED = auto()
    RUNNING = auto()
    STOPPED = auto()
```

Good when:

* Values don’t matter
* You only care about identities

---

# 🧪 Validation & Safe Conversion

Enums help block invalid values.

### Preventing bad inputs

```python
def set_status(status: Status):
    if not isinstance(status, Status):
        raise ValueError("Invalid status")
```

---

### Converting from raw input

```python
Status("success")
Status("invalid")   # raises ValueError
```

Wrap in safe conversion:

```python
try:
    status = Status(value)
except ValueError:
    ...
```

---

# 🌍 JSON & API Handling

JSON doesn’t understand Enums directly.

```python
import json
json.dumps(Status.SUCCESS.value)
```

Or serialize entire model:

```python
data = {"status": Status.SUCCESS.value}
```

---

## FastAPI / Pydantic (works beautifully)

```python
from enum import Enum
from pydantic import BaseModel

class Status(Enum):
    success = "success"
    failed = "failed"

class Response(BaseModel):
    status: Status
```

* Input validated
* Auto docs
* Auto OpenAPI support

---

# 🗃️ Databases

### Store `.value`, not the enum object.

Example SQL insert:

```python
status.value
```

When reading from DB:

```python
Status(db_value)
```

---

# 🧭 `@unique` — Prevent Duplicate Values

Avoid accidental duplicates.

```python
from enum import Enum, unique

@unique
class Currency(Enum):
    USD = "usd"
    EURO = "eur"
```

Duplicate values now crash at class creation.

---

# ⚠️ Common Pitfalls & Gotchas

---

### ❌ Don’t compare Enum to raw string

Bad:

```python
if status == "success":
```

Prefer:

```python
if status is Status.SUCCESS:
```

---

### ❌ Don’t mix Enums from different classes

```python
Status.SUCCESS == OtherStatus.SUCCESS  # False
```

---

### ❌ Mutable values inside Enum members

Enum members should be immutable.

Bad:

```python
class Bad(Enum):
    X = []
```

Shared mutable object → bugs.

---

# 🧩 Advanced Tricks

---

## Looping

```python
for s in Status:
    print(s)
```

---

## Get list

```python
[s.value for s in Status]
```

---

## Name lookup

```python
Status["SUCCESS"]
```

---

## Custom Methods in Enum

Enums can have behavior.

```python
class Status(Enum):
    SUCCESS = "success"
    FAILED = "failed"

    def is_failure(self):
        return self is Status.FAILED
```

---

# 🧭 When Should You Use Enum?

Use Enum when values:
✔ are fixed
✔ are meaningful symbols
✔ need validation
✔ want readable code
✔ want safer APIs
✔ avoid typo bugs
✔ need IDE support

Do NOT use enum for:
❌ frequently changing values
❌ user-generated values
❌ large dynamic sets
❌ values requiring DB lookup

---

# 🎯 Quick Decision Guide

| Need                    | Use            |
| ----------------------- | -------------- |
| Readable constants      | Enum           |
| Return API states       | StrEnum        |
| Numeric protocol values | IntEnum        |
| Permissions bitmask     | Flag / IntFlag |
| JSON-friendly           | StrEnum        |
| Legacy int systems      | IntEnum        |
| Prevent invalid values  | Enum           |

---


# Enum can have behaviour


When people say **“Enums can have behavior”** in Python, they mean:

> An `Enum` is not just a list of values. It is a *full class*, so it can contain **methods, properties, validation logic, and custom behavior**—just like normal classes.

This makes Enums much more powerful than simple constants or string lists.


## 1️⃣ Enums can have **methods**

You can attach functions that operate on enum members.

```python
from enum import Enum

class Status(Enum):
    SUCCESS = "success"
    FAILED = "failed"

    def is_success(self):
        return self is Status.SUCCESS
```

Usage:

```python
s = Status.SUCCESS
s.is_success()   # True
```

So instead of writing:

```python
if status == Status.SUCCESS:
```

You can encapsulate logic:

```python
if status.is_success():
```

Cleaner. More readable. Less repeated checks.

---

## 2️⃣ Enums can have **computed properties**

```python
class FileType(Enum):
    JSON = "json"
    CSV = "csv"

    @property
    def mime(self):
        return {
            FileType.JSON: "application/json",
            FileType.CSV: "text/csv"
        }[self]
```

Usage:

```python
FileType.CSV.mime
# -> "text/csv"
```

The enum now carries *knowledge* about itself.

---

## 3️⃣ Enums can override `__str__`, `__repr__`, etc.

```python
class Status(Enum):
    SUCCESS = "success"
    FAILED = "failed"

    def __str__(self):
        return self.value.upper()
```

Usage:

```python
print(Status.SUCCESS)
# SUCCESS
```

You control representation.

---

## 4️⃣ Enums can validate or normalize values

Example: Smart behavior based on meaning.

```python
class HttpStatus(Enum):
    OK = 200
    NOT_FOUND = 404
    SERVER_ERROR = 500

    def is_error(self):
        return self.value >= 400
```

Usage:

```python
HttpStatus.OK.is_error()          # False
HttpStatus.NOT_FOUND.is_error()   # True
```

Encapsulation = better API design.

---

## 5️⃣ Enums can have custom constructors

Yes — they are classes.

```python
class Role(Enum):
    USER = "user"
    ADMIN = "admin"

    def describe(self):
        return f"Role({self.value})"
```

Usage:

```python
Role.ADMIN.describe()
# -> "Role(admin)"
```

---

## 6️⃣ Enums can work in real systems

### Example: Backend API

```python
class OrderStatus(Enum):
    NEW = "new"
    SHIPPED = "shipped"
    CANCELLED = "cancelled"

    def can_transition_to(self, other):
        allowed = {
            OrderStatus.NEW: {OrderStatus.SHIPPED, OrderStatus.CANCELLED},
            OrderStatus.SHIPPED: set(),
            OrderStatus.CANCELLED: set()
        }
        return other in allowed[self]
```

Usage:

```python
OrderStatus.NEW.can_transition_to(OrderStatus.SHIPPED)   # True
OrderStatus.SHIPPED.can_transition_to(OrderStatus.NEW)   # False
```

Here the “behavior” enforces business rules.

---

# 🧠 Why this is powerful

Enums become:

* **self-aware domain objects**
* not just static constants
* carry *meaning + logic*
* reduce duplicated code
* improve readability
* enforce correctness

This is *huge* in:

* backend services
* ETL pipelines
* state machines
* APIs
* business logic
* validation

---

# ⚠️ When to add behavior?

Use Enum behavior when:
✔ logic relates to the meaning of the enum
✔ avoids duplicated “if enum == …” checks
✔ improves readability

Don’t overdo it. Keep them focused.

---

# 🎯 Final takeaway

**Python Enums can behave like real objects, not just labels.**
They can:

* have methods
* have properties
* encapsulate business logic
* validate behavior
* improve code design

That’s what “Enums can have behavior” truly means.

