# 🧰 `setup.py` — A User Guide

---

## 1️⃣ What is `setup.py`?

`setup.py` is the **traditional build and packaging script** for Python projects.
It has historically been the *entry point* for:

* Building packages
* Publishing packages to PyPI
* Installing packages in editable mode
* Declaring dependencies
* Defining project metadata

It is a Python file, meaning:

* It **executes code**
* Can compute values dynamically
* Can do conditional logic

This flexibility is why it dominated Python packaging for over a decade.

---

## 2️⃣ Where is `setup.py` typically used?

### 📦 Open-source and internal libraries

If you maintain or contribute to packages like:

* util libraries
* SDKs
* reusable Python modules
* frameworks

Historically these used `setup.py`.

---

### ⚙️ Applications packaged like libraries

Even if not published to PyPI, some internal corporate apps package themselves using `setup.py` for:

* deployment
* environment consistency
* versioning

---

### 🧪 Developer workflows (`pip install -e .`)

Editable installs depend on it:

```
pip install -e .
```

Without `setup.py` (or `pyproject.toml` that supports it), editable installs are harder.

---

## 3️⃣ Modern Reality: Is `setup.py` Legacy?

### Short answer:

**Yes… but still very relevant.**

### Long answer:

The Python ecosystem is moving to:

* `pyproject.toml` (PEP 518 + PEP 621)
* Static declarative configuration
* Standardized builds via tools like:

  * `setuptools`
  * `poetry`
  * `flit`
  * `hatch`

Many modern projects now:

* Prefer **`pyproject.toml` only**
* Or keep `setup.py` only when needed

### But `setup.py` is still common because:

* Many major packages still use it
* Many companies have legacy infrastructure
* It supports dynamic configs easily
* Developers deeply understand it

So think of it as:

> “Mature, battle-tested, slowly being replaced — but far from dead.”

---

## 4️⃣ What `setup.py` is normally responsible for

### 🏷️ Declaring Metadata

Examples:

* name
* version
* author
* description
* classifiers

---

### 📥 Declaring Dependencies

Examples:

* install requirements
* optional dependencies
* extras

---

### 📁 Packaging Content

Controls:

* Which modules are packaged
* Data file inclusion
* Package discovery

---

### 🛠️ Build & Distribution

Used to:

```
python setup.py sdist
python setup.py bdist_wheel
```

Generates:

* source tar.gz
* wheel `.whl`

---

### 🚀 Publishing

Historically:

```
python setup.py upload
```

Now replaced by `twine`:

```
twine upload dist/*
```

---

## 5️⃣ Typical `setup.py` Layout

Here’s the conceptual structure most `setup.py` files follow:

```
from setuptools import setup, find_packages

setup(
    name="mypackage",
    version="0.1.0",
    description="My awesome Python package",
    packages=find_packages(),
    install_requires=[
        "requests",
        "pandas>=1.2"
    ],
    extras_require={
        "dev": ["pytest", "black"]
    },
)
```

Key takeaway:

> `setup()` is the heart of the file — everything feeds into it.

---

## 6️⃣ Advanced Capabilities

### ✅ Dynamic Versioning

Example:

* Read version from `__init__.py`
* Compute version from git tags
* Auto-increment versions

---

### ✅ Conditional Dependencies

Example:

* Only install a dependency on Windows
* Add extra dependencies for PyPy
* Different Python versions get different packages

---

### ✅ Build-time Logic

`setup.py` can:

* read environment variables
* check compilers
* run scripts
* compile C extensions

Something TOML cannot do.

---

## 7️⃣ Developer Commands You Should Know

### Install package

```
pip install .
```

### Editable install (development mode)

```
pip install -e .
```

### Create source distribution

```
python setup.py sdist
```

### Create wheel

```
python setup.py bdist_wheel
```

### Clean build artifacts

```
python setup.py clean
```

---

## 8️⃣ Relationship with `setup.cfg` and `pyproject.toml`

### 🔹 `setup.py` vs `setup.cfg`

* `setup.cfg` is a **static config file**
* removes Python execution
* but still uses setuptools
* often used *alongside* `setup.py`

Trend:

* Many modern setuptools projects put metadata in `setup.cfg`
* Keep `setup.py` minimal or absent

---

### 🔹 `setup.py` vs `pyproject.toml`

`pyproject.toml` is now the **official standard** for build configuration.

It can:

* Replace `setup.py` entirely
* Work with Poetry, Flit, Hatch, Setuptools
* Define build system + metadata declaratively

Trend:

* Python ecosystem is converging on `pyproject.toml`
* Newer projects prefer it
* Tooling is optimized for it

But:

* Some advanced/dynamic configs still require `setup.py`
* Many tools still expect it
* Legacy environments depend on it

---

## 9️⃣ When Should You Still Use `setup.py` Today?

Use `setup.py` if:

✔ you maintain an existing project using it
✔ you need dynamic config logic
✔ you rely on `pip install -e .` in legacy workflows
✔ you maintain corporate/internal libraries
✔ you support older Python toolchains

---

## 🔟 When Should You Avoid `setup.py` Now?

Prefer **`pyproject.toml` only** if:

✔ starting a brand-new library
✔ building modern tooling
✔ you need reproducible deterministic builds
✔ you want future-proof packaging
✔ you prefer Poetry / Flit / Hatch ecosystems

---

## 1️⃣1️⃣ Practical Rule of Thumb

| Scenario                                  | Suggested Approach                  |
| ----------------------------------------- | ----------------------------------- |
| Brand new public package                  | Use `pyproject.toml`, no `setup.py` |
| Existing package already using `setup.py` | Keep it or migrate slowly           |
| Complex dynamic build logic needed        | Keep `setup.py`                     |
| Corporate internal package                | `setup.py` or mixed hybrid          |
| DevOps, CI friendly clean projects        | Use `pyproject.toml`                |

---

## 🏁 Final Takeaway

* `setup.py` is **not dead**
* but **no longer the recommended first choice**
* it remains a **powerful, flexible, widely deployed standard**
* the ecosystem is **converging toward TOML-based builds**
* understanding `setup.py` is still essential for professional Python work

