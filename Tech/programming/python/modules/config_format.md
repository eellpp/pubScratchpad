A practical “when do I use what?” guide for config formats in Python projects — **not** about syntax, just about real-world usage, trends, and what’s considered modern vs. legacy.

---

## 1. Python files (`.py`) as config

**What it is in practice:**
You import a module like `settings.py` / `config.py` and read variables from it.

**Typical use cases**

* **Django projects** – Historically (and still often), `settings.py` is the main config. You sometimes see `local_settings.py`, or `settings_dev.py`, etc.
* **Older or in-house frameworks** – Where config needs to include **logic** (e.g., computing paths, reading environment vars, conditional settings).
* **Power-user scripts or tools** – When the user is expected to be a Python developer and comfortable editing Python directly.

**Pros (why people still use it)**

* Full power of Python: if/else, loops, function calls, environment detection.
* Easy to refactor/organize using imports.

**Cons / why it’s less common for new tooling**

* **Security**: executing arbitrary user config as code.
* Harder to parse or validate automatically.
* Can’t easily be read by tools written in other languages.

**Modern trend**

* Still common in **web apps** (Django, Flask apps with `settings.py`), but **tooling** (packaging, linters, formatters, CI tools) is moving away from `.py` config and towards **declarative files**, especially **TOML** and **YAML**.

---

## 2. INI / `.cfg` (`.ini`, `.cfg`, `.conf`)

Think of `setup.cfg`, `tox.ini`, etc.

**Typical use cases**

* **Legacy / older Python tooling**

  * `setup.cfg` (old-style packaging config before `pyproject.toml`).
  * `tox.ini` for `tox` test environments (still widely used).
  * `pytest.ini` (though `pyproject.toml` support is growing).
* **Simple key–value app configs** in older scripts or internal tools.

**Why it was popular**

* Simple, human-readable, built into Python (`configparser`).
* Good enough for flat configuration with sections.

**Cons**

* Limited nesting; “hierarchical” configuration is awkward.
* Poor type expressiveness; everything is basically strings.
* Harder to express complex structured data.

**Modern trend**

* **Slowly declining** in new projects, replaced by TOML or YAML, but:

  * You will still see `tox.ini`, `pytest.ini`, etc. for many mature projects.
  * `setup.cfg` is slowly being replaced by `pyproject.toml`.

You can think of INI as **“legacy but still alive in long-standing tools.”**

---

## 3. JSON (`.json`)

**Typical use cases**

* **Interchange with other systems**: When config is shared between Python and:

  * JavaScript frontends
  * REST APIs
  * external services
* **Machine-generated config**: Tools dumping config that will be read by Python.
* **Kinda portable**: When you want a config format that any language can read.

**Why people pick JSON**

* Ubiquitous and language-agnostic.
* Strict, simple, easy to parse in virtually any environment.

**Cons**

* No comments (usually a big downside for human-edited config).
* Not very ergonomic for complex, human-maintained configs.

**Modern trend**

* JSON is **dominant for data & APIs**, but not usually the first choice for **hand-written project config** anymore.
* In Python projects, JSON config is often used when:

  * It’s also consumed by JavaScript or another language.
  * The config is more “data” than “settings.”

---

## 4. YAML (`.yml`, `.yaml`)

**Typical use cases**

* **Infrastructure / Ops / DevOps** around Python:

  * GitHub Actions workflows (`.github/workflows/*.yml`)
  * Docker Compose (`docker-compose.yml`)
  * Kubernetes manifests
  * CI/CD pipelines for Python projects
* **Applications that want flexible, human-editable config**, e.g.:

  * ML/experiment configs (Hydra, OmegaConf, etc.)
  * Web apps/microservices using YAML to define routes, rules, or pipelines.
* Configuration for tools like `pre-commit` (`.pre-commit-config.yaml`).

**Why people like YAML**

* Very human-friendly for large nested structures.
* Allows comments, anchors, etc.
* Good ecosystem support (`PyYAML`, `ruamel.yaml`, etc.).

**Cons**

* Can be confusing/fragile due to indentation.
* More complex and less predictable than TOML/JSON (edge cases, types).
* Bad YAML is hard to debug.

**Modern trend**

* YAML is **standard** for DevOps/infrastructure configuration, and that bleeds into Python ecosystems using those tools.
* For pure **Python-only project metadata**, the trend is **toward TOML** not YAML.
* For **application runtime config**, YAML is still very common and not going away soon.

---

## 5. TOML (`.toml`)

This is the star of modern Python packaging.

**Typical use cases**

* **Project metadata & tool config** (strong convergence here):

  * `pyproject.toml` – central file for:

    * Packaging (build backend, project metadata; replacing `setup.py`/`setup.cfg`)
    * Tool configs: `black`, `ruff`, `mypy`, `pytest`, etc., all increasingly support TOML sections.
* Some **application config** where you want something:

  * Cleaner than INI
  * More rigid and less crazy than YAML
  * With comments allowed and good typing

**Why TOML is now “the thing”**

* Officially blessed by PEP 518 / PEP 621 for Python packaging.
* Easy to parse, supports nested tables, clear typing.
* Works well as a shared config home for many tools via `pyproject.toml`.

**Cons**

* Slightly less popular outside the Python/Rust world (but growing).
* Not as expressive/compact as YAML for deeply nested configs.

**Modern trend**

* **Strong convergence** in Python ecosystem:
  `pyproject.toml` is becoming the **single hub** for:

  * Packaging
  * Formatting (black)
  * Linting (ruff)
  * Type checking (mypy)
  * Test config (pytest increasingly supports it)
* New tools tend to say “configure me in `pyproject.toml` or my own `*.toml`”.

---

## 6. Summary: Which format is used where?

### a. Python ecosystem meta / tooling

* **Old style**:

  * `setup.py` (Python code)
  * `setup.cfg` (INI)
  * `tox.ini`, `pytest.ini`

* **Modern style (convergence)**:

  * **`pyproject.toml` (TOML)** as the central config.
  * Many tools: black, ruff, isort, mypy, pytest, etc., prefer TOML now.
  * INI remains mostly for tools that started with it (tox, some pytest configs), but they often support TOML too.

### b. Application runtime config (your own service/app)

* **`.py` config**:

  * When you need logic, imports, environment checks in config.
  * Common in Django or older frameworks.
* **YAML**:

  * When humans/Ops edit configs with nested structures (ML pipelines, microservices routes, infra-like config).
* **JSON**:

  * When config needs to be shared with non-Python systems (JS frontends, external services) or machine-generated.
* **TOML**:

  * Emerging option for simple, typed application config, especially if you already like TOML because of `pyproject.toml`.

### c. Infra & Ops around Python

* **YAML** dominates: Kubernetes, GitHub Actions, Docker Compose, CI pipelines.
* Python just consumes them or runs on top of them.

---

## 7. Legacy vs modern at a glance

You can roughly think of them like this (for Python):

* **Legacy (but still widely used):**

  * `.py` configs for framework settings (Django, older apps)
  * `setup.py`, `setup.cfg` (packaging)
  * `tox.ini` / `pytest.ini` (some testing tools)
  * INI for simple app configs

* **Modern / preferred for new tooling:**

  * **TOML** (`pyproject.toml`) for project + tool config.
  * **YAML** for infra, CI/CD, and rich human-edited runtime configs.
  * JSON for cross-language or machine-generated configs.

There isn’t a single “one config format to rule them all”, but there **is** a clear convergence in **Python tooling** around **TOML**, anchored by `pyproject.toml`.

---
