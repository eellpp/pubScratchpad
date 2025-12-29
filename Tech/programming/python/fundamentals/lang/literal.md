# ✅ What is `Literal`?

`Literal` allows you to say:

> “This function only accepts *these exact string values*.”

Example:

```python
from typing import Literal

def set_mode(mode: Literal["dev", "test", "prod"]):
    print("Mode set to", mode)
```

Valid:

```python
set_mode("dev")
```

Invalid (type checker will flag):

```python
set_mode("staging")   # ❌ not allowed
```

This improves:

* correctness
* readability
* IDE autocomplete
* static checking (mypy, pyright, Pylance)

---

# 🧠 Why Use Literal Strings?

They are useful when you have **fixed accepted options**, like:

* modes
* statuses
* flags
* feature choices
* API parameter values
* command names

Instead of:

```python
def set_state(state: str): ...
```

Which accepts anything — and bugs slip through.

Literal makes intent clear and validated.

---

# 🚀 Real Examples

---

### 🔹 Function parameters

```python
def log_level(level: Literal["info", "warn", "error"]):
    ...
```

---

### 🔹 Return types

```python
def get_state() -> Literal["running", "stopped"]:
    return "running"
```

---

### 🔹 Multiple Literals

Python supports:

```python
Color = Literal["red", "green", "blue"]

def paint(color: Color):
    ...
```

This is a common pattern.

---

# 🎯 Python Versions

* `Literal` introduced → **Python 3.8**
* Backport available via:

```bash
pip install typing_extensions
```

Usage:

```python
from typing_extensions import Literal
```

---

# 🧪 Works Great With IDEs

VSCode, PyCharm, MyPy, Pyright:

* show autocomplete of allowed values
* warn invalid inputs
* catch mistakes early

---

# 🧩 Literal vs Enum?

| Literal                      | Enum                         |
| ---------------------------- | ---------------------------- |
| lighter                      | heavier but powerful         |
| no runtime object            | runtime behavior possible    |
| static-only                  | supports methods / behavior  |
| good for simple param guards | good for domain model states |

Use Literal for **simple constraints**.
Use Enum when values have meaning/behavior.

---

# ⚠️ Limitations / Notes

* Checked only by static tools, not enforced at runtime
* Too many Literals → messy
* Prefer Enums for business logic
* Don’t use for user-generated values or large dynamic sets

---

# ✅ What is `LiteralString`?

`LiteralString` is a **security-focused typing feature** introduced in **Python 3.11 (PEP 675)**. It helps you prevent bugs and vulnerabilities by marking places in your code that should *only* accept **string literals written in source code**, not dynamically constructed or user-supplied strings.


It’s a type that means:

> “This argument must be a literal string value, not a variable, not user input, not formatted text.”

Example:

```python
from typing import LiteralString

def run_query(query: LiteralString):
    ...
```

Allowed:

```python
run_query("SELECT * FROM users")
```

❌ Not allowed (static type error):

```python
user_input = input()
run_query(user_input)          # rejected
run_query(f"SELECT {table}")   # rejected
```

Static checkers like **Pyright, MyPy, PyCharm** stop you from accidentally allowing unsafe strings.

---

# 🧠 Why Use `LiteralString`?

---

## 1️⃣ Prevents injection vulnerabilities

Stops insecure use cases like:

* SQL injection
* Shell command injection
* Format string injection

Example:

```python
def safe_exec(command: LiteralString):
    ...
```

This ensures:

```python
safe_exec("rm -rf /tmp")    # allowed
safe_exec(user_input)       # ❌ blocked
```

You now **cannot accidentally pass untrusted input**.

---

## 2️⃣ Protects API boundaries

If a function expects only fixed trusted strings, declare it.

Example: safe logging keys, feature flags, mode names:

```python
def set_mode(mode: LiteralString):
    ...
```

Flashy incorrect cases get flagged.

---

## 3️⃣ Encourages safer design

It forces you to separate:

* **trusted static strings**
* **untrusted runtime strings**

This leads to safer APIs and clearer intent.

---

## 4️⃣ Works with constants

You *can* still use constants, but only if defined as literals.

```python
MODE = "prod"

set_mode(MODE)   # allowed
```

---

# 🚨 Key Difference vs `Literal[...]`

`Literal`:

* restricts to a fixed set of allowed values
* used for correctness / API clarity
* example:

```python
def mode(m: Literal["dev","prod"]):
```

`LiteralString`:

* allows **any literal**
* purpose is **security**
* blocks **dynamic runtime strings**

They solve different problems.

---

# 🧩 Where It’s Useful (Real-World)

---

### ✔ Database libraries

```python
def execute_sql(sql: LiteralString):
```

### ✔ Shell wrappers

```python
def run(command: LiteralString):
```

### ✔ HTML templating

```python
def render(template: LiteralString):
```

### ✔ Logging format patterns

```python
def log(fmt: LiteralString, *args):
```

Anywhere unsafe string composition is risky.

---

# 🔧 Versions

Python:

* Built-in from **3.11+**

```python
from typing import LiteralString
```

Older Python:

```bash
pip install typing_extensions
```

```python
from typing_extensions import LiteralString
```

---

# ⚠️ Limitations

* Enforced only by static type checkers, not runtime
* Not meant for everything
* Intended primarily for **security-sensitive APIs**

---

# 🏁 Summary

Use `LiteralString` when:

* only static strings should be allowed
* user input must NOT be passed
* you want to stop injection bugs early
* you want safer API contracts

It’s mainly a **secure-coding tool**, not a correctness constraint like `Literal`.

