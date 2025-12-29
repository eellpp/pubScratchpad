# 🧠 Class Attribute vs Property in Python

They solve **different** problems.

---

# ✅ Class Attribute

A **variable defined on the class itself**, shared by all instances unless overridden.

### ✔️ Defined at class level

```python
class User:
    role = "guest"   # class attribute
```

### ✔️ Access

```python
User.role         # via class
User().role       # via instance
```

### ✔️ Shared Across Instances

```python
u1 = User()
u2 = User()

u1.role = "admin"
print(u1.role)  # admin  (instance override)
print(u2.role)  # guest  (still original)
print(User.role) # guest
```

Instances **can shadow** the class attribute by assigning a value.

---

## 🔥 When to Use Class Attributes

Use class attributes when the data is:

* Same for all objects
* Static / constant-like
* Metadata / defaults
* Configuration

### Examples

#### 🌍 App Config Defaults

```python
class APIClient:
    timeout = 5
```

#### 🎯 Enum-style constants

```python
class Status:
    SUCCESS = "success"
    FAILED = "failed"
```

#### 📦 Shared Counters

```python
class Task:
    counter = 0

    def __init__(self):
        Task.counter += 1
```

---

## ⚠️ Common Mistake

Mutable class attributes are **shared** (danger!)

```python
class Example:
    tags = []

e1 = Example()
e2 = Example()

e1.tags.append("x")
print(e2.tags)   # ['x'] -> shared!

```

Use instance attribute instead:

```python
def __init__(self):
    self.tags = []
```

---

# 🏠 Property

A `property` turns a **method into an attribute-like interface**.

### ✔️ Defined with `@property`

```python
class Product:
    def __init__(self, price):
        self._price = price

    @property
    def price(self):
        return self._price
```

Looks like attribute:

```python
p = Product(100)
print(p.price)
```

But executes logic internally.

---

## 🌟 Why Properties Are Powerful

They allow you to:

* **Compute values dynamically**
* **Add validation**
* **Lazy load values**
* **Protect internal state**
* Change behavior without breaking API

---

## 🛡️ Property with Setter

```python
class Product:
    def __init__(self, price):
        self._price = price

    @property
    def price(self):
        return self._price

    @price.setter
    def price(self, value):
        if value < 0:
            raise ValueError("Price cannot be negative")
        self._price = value
```

Usage:

```python
p = Product(50)
p.price = 10     # Valid
p.price = -1     # Raises error
```

Now consumers use it like a normal field, but you maintain control.

---

# 🧩 Key Differences (Side-by-Side)

| Concept       | Class Attribute                      | Property                                   |
| ------------- | ------------------------------------ | ------------------------------------------ |
| Where defined | On class                             | On instance                                |
| Shared?       | Yes shared by default                | Per instance                               |
| Purpose       | Common data / constants              | Managed computed attribute                 |
| Has logic?    | No                                   | Yes (getter/setter)                        |
| Access style  | `Class.attr` or `obj.attr`           | `obj.attr`                                 |
| Use cases     | defaults, metadata, config, counters | validation, computed fields, encapsulation |

---

# 🏗 Real Engineering Use Cases

---

## 1️⃣ Backend / API Models

Expose "attribute style" but validate internally

```python
class User:
    def __init__(self, email):
        self._email = None
        self.email = email

    @property
    def email(self):
        return self._email
    
    @email.setter
    def email(self, value):
        if "@" not in value:
            raise ValueError("Invalid email")
        self._email = value
```

Clean public API for callers.

---

## 2️⃣ ETL / Data Pipeline Objects

Lazy computation only when needed

```python
class DataJob:
    @property
    def records(self):
        print("Loading heavy dataset…")
        return load_big_file()
```

Call:

```python
job = DataJob()
job.records   # expensive only when accessed
```

---

## 3️⃣ Performance / Cached Computation

Compute once → reuse

```python
from functools import cached_property

class Report:
    @cached_property
    def data(self):
        print("Expensive computation")
        return compute()
```

---

## 4️⃣ Compatibility / API Stability

You can evolve your class without breaking users.

Initially:

```python
user.age = 20
```

Later you need validation:
Turn it into a property – no caller change needed.

This is a HUGE reason properties exist.

---

# 🚫 What Properties Are NOT

They are NOT:

* shared storage
* constants
* replacements for variables

They are for **controlled attribute access**.

---

# 🧭 Quick Decision Guide

### Use **Class Attribute** when:

✔ value same for all
✔ acts like constant
✔ config / metadata
✔ default value

### Use **Property** when:

✔ value depends on logic
✔ requires validation
✔ represents computed data
✔ needs backward-compatible behavior
✔ lazy load / cache
✔ protect internal state

---

# 🎯 Final Summary

* **Class Attribute** → shared static data
* **Property** → attribute syntax + logic control
* Properties help build **clean public APIs**, **validation**, **safety**, and **future flexibility**
* Class attributes help with **constants**, **shared defaults**, and **meta behavior**

