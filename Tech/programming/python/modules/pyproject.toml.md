# 🧰 `pyproject.toml` — A Modern User Guide

---

## 1️⃣ What is `pyproject.toml`?

`pyproject.toml` is the **modern, standardized configuration file** for Python projects.
It is defined by:

* **PEP 518** — Build system specification
* **PEP 621** — Project metadata
* **PEP 660** — Editable installs without `setup.py`

It serves as a **single home** for:

* packaging metadata (name, version, dependencies)
* build backend definition (setuptools / poetry / flit / hatch)
* tool configurations (black, ruff, pytest, mypy, etc.)

Think of it as:

> **“package.json for Python”**
> (but cleaner, more structured, and standard)

---

## 2️⃣ Why did Python move to `pyproject.toml`?

Because old packaging was fragmented:

* `setup.py` → dynamic metadata/code execution
* `setup.cfg` → static config
* `requirements.txt` → dependencies
* random dotfiles for tools

This caused problems:

* security risk (running arbitrary code)
* packaging inconsistency across tools
* poor interoperability
* hard automation

`pyproject.toml` fixes this by:

✔ providing **one standard place**
✔ readable & structured format (TOML)
✔ works across all build tools
✔ supports metadata without code execution
✔ supports modern packaging workflows

---

## 3️⃣ Where is `pyproject.toml` used in practice?

### ✔️ Modern Python Libraries

Most modern libs now use it:

* numpy (newer packaging parts)
* fastapi ecosystem packages
* rich
* ruff
* black
* many new OSS projects

---

### ✔️ Corporate / Internal Libraries

Teams prefer it because:

* deterministic builds
* easier CI automation
* clearer metadata ownership

---

### ✔️ Tool Configuration Hub

Instead of:

* `.flake8`
* `mypy.ini`
* `.black`
* `pytest.ini`
* `pyproject.cfg`

Tools now prefer sections inside `pyproject.toml`.

---

### ✔️ Build Backends

It supports different ecosystems:

| Build Tool | Use Case                       |
| ---------- | ------------------------------ |
| Setuptools | Traditional projects           |
| Poetry     | Dependency + packaging manager |
| Flit       | Lightweight library publishing |
| Hatch      | Modern packaging workflows     |

---

## 4️⃣ Minimum Meaningful `pyproject.toml`

A **basic setuptools project**:

```toml
[build-system]
requires = ["setuptools", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "mypackage"
version = "0.1.0"
description = "My awesome package"
requires-python = ">=3.9"
dependencies = [
  "requests",
  "pandas>=1.2"
]
```

This replaces **both** `setup.py` and `setup.cfg`.

---

## 5️⃣ What goes inside `pyproject.toml`?

There are **three major sections** conceptually:

---

### 1️⃣ Build System

Required.

Declares how the project should be built.

Examples:

**Setuptools**

```toml
[build-system]
requires = ["setuptools>=68", "wheel"]
build-backend = "setuptools.build_meta"
```

**Poetry**

```toml
[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```

**Flit**

```toml
[build-system]
requires = ["flit_core>=3.2"]
build-backend = "flit_core.buildapi"
```

This allows universal build tools (pip, build, hatchling, poetry) to work consistently.

---

### 2️⃣ Project Metadata (PEP 621)

The `[project]` section contains:

* name
* version
* authors
* dependencies
* Python version
* entry points

Example:

```toml
[project]
name = "analytics-engine"
version = "1.4.2"
description = "Stream processing analytics library"
authors = [
  { name="John Doe", email="john@example.com" }
]
license = { text = "MIT" }
requires-python = ">=3.10"

dependencies = [
  "pydantic>=2",
  "fastapi",
  "numpy<2"
]
```

Optional extras:

```toml
[project.optional-dependencies]
dev = ["pytest", "black", "ruff"]
spark = ["pyspark"]
```

Users install like:

```
pip install analytics-engine[spark]
```

---

### 3️⃣ Tool Configurations

Most modern tools support:

```toml
[tool.toolname]
```

---

## 6️⃣ Tool Config Examples

### 🔧 Black Formatter

```toml
[tool.black]
line-length = 100
target-version = ["py310"]
```

---

### 🧹 Ruff Linter

```toml
[tool.ruff]
line-length = 100
target-version = "py310"
select = ["E", "F", "I"]
ignore = ["E501"]
```

---

### 🧪 Pytest

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-q"
```

---

### 🐍 Mypy

```toml
[tool.mypy]
python_version = "3.11"
strict = true
```

---

### 🚀 Poetry (if using Poetry)

```toml
[tool.poetry]
name = "my-svc"
version = "0.2.0"
description = "service"
authors = ["me <me@mail.com>"]

[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.110"

[tool.poetry.dev-dependencies]
pytest = "^8.0"
```

---

## 7️⃣ Editable Installs (PEP 660)

Before:

```
pip install -e .
```

Required `setup.py`.

Now:

```
pip install -e .
```

Works **with only pyproject.toml** for compliant build backends.

This is huge for dev workflows.

---

## 8️⃣ Building & Publishing

### Build package

```
pip install build
python -m build
```

Creates:

* `dist/*.whl`
* `dist/*.tar.gz`

---

### Upload to PyPI

```
pip install twine
twine upload dist/*
```

No `setup.py` needed.

---

## 9️⃣ When should you use `pyproject.toml`?

Use it if:

✔ new project
✔ modern library
✔ want deterministic builds
✔ publishing to PyPI
✔ want clean CI automation
✔ want a single config file

Python ecosystem is converging here.

---

## 🔟 When might you still need `setup.py`?

Use (or keep) `setup.py` if:

✔ legacy project
✔ dynamic version logic required
✔ complicated custom build steps
✔ very old environments

But even these are shrinking cases.

---

## 1️⃣1️⃣ Comparison with Older Packaging

| Task              | Old Way              | Modern Way                |
| ----------------- | -------------------- | ------------------------- |
| Metadata          | setup.py / setup.cfg | pyproject.toml            |
| Dependencies      | requirements.txt     | pyproject.toml            |
| Build system      | implicit             | explicit                  |
| Editable installs | setup.py required    | works without it          |
| Tool configs      | many files           | unified in pyproject.toml |

---

## 🏁 Final Takeaways

* `pyproject.toml` is **the present and future** of Python packaging
* It **replaces** `setup.py` + `setup.cfg`
* It **centralizes**:

  * packaging metadata
  * build configuration
  * tool configuration
* It is now **widely adopted and standardized**
* If you start a new project → **use `pyproject.toml`**
* If you maintain legacy projects → learn it anyway (you’ll end up migrating)


