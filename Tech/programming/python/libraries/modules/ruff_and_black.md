A **practical, production-focused guide** to using **Ruff (linter)** and **Black (formatter)** together for:

* API web services
* Backend processing services
* PySpark / data-engineering scripts


---

## 1. Mental model: Ruff vs Black

* **Black**

  * Opinionated code *formatter*
  * Rewrites your code to a consistent style
  * You don’t argue with it; you accept its style → fewer style discussions

* **Ruff**

  * Very fast *linter* (and import sorter)
  * Replaces Flake8 + many plugins (pyflakes, pycodestyle, isort, etc.)
  * Catches:

    * unused imports/variables
    * likely bugs
    * style & complexity issues
    * import order
    * some security & correctness smells

> **Pattern**:
>
> * Let **Black** handle spacing/formatting.
> * Let **Ruff** enforce quality + imports + misc rules.

---

## 2. Installation

### With `pip` (in your env / conda env)

```bash
pip install black ruff
```

### With conda (if you prefer)

```bash
conda install -c conda-forge black ruff
```

No custom builds; both install like normal packages.

---

## 3. Project-wide config with `pyproject.toml`

Use a **single `pyproject.toml` at repo root** to keep config in one place.

### Example `pyproject.toml` for your context

```toml
[tool.black]
line-length = 100
target-version = ["py311"]   # adjust to your Python version(s)
skip-string-normalization = true  # optional: keeps your " vs '

[tool.ruff]
line-length = 100
target-version = "py311"

[tool.ruff.lint]
# Basic rule families:
# E,F = pycodestyle/pyflakes (errors)
# I   = isort (import sorting)
# B   = bugbear (common bugs)
# UP  = pyupgrade (modern Python idioms)
select = ["E", "F", "I", "B", "UP"]

# Typical ignores when using Black
ignore = [
  "E203",  # spacing before :  (Black-compatible)
  "E501",  # line length (let Black handle)
]

# Don’t lint virtualenvs, build artifacts, etc.
exclude = [
  ".git",
  ".venv",
  "venv",
  "__pycache__",
  "build",
  "dist",
  "migrations",  # e.g. Django migrations
]

[tool.ruff.lint.isort]
# Your first-party packages (for import grouping)
known-first-party = ["myapi", "backend", "jobs", "pyspark_jobs"]
combine-as-imports = true
```

You can tweak `line-length` and `target-version` to match your environment.

---

## 4. Running locally

### Format with Black

* Entire project:

  ```bash
  black .
  ```

* Single file:

  ```bash
  black app/api/views.py
  ```

### Lint with Ruff

* Check only:

  ```bash
  ruff check .
  ```

* Check **and autofix** where safe:

  ```bash
  ruff check . --fix
  ```

Typical dev flow:

1. Save code
2. Run `black .`
3. Run `ruff check . --fix`
4. Run tests

Or even better: hook Black + Ruff into your **editor** and/or **pre-commit** so you rarely run them manually.

---

## 5. Editor integration (highly recommended)

Most modern editors/IDEs have plugins:

* **VS Code**:

  * Set Black as formatter
  * Add Ruff as linter (Ruff extension)
* **PyCharm**:

  * External tools or recent built-in Ruff integration
* **Neovim/Vim**:

  * `null-ls`, `ale`, or language-server-level integration
* **VSCode-like setup**:

  * Format on save using Black
  * Show Ruff diagnostics inline

This gives you instant feedback while coding.

---

## 6. Pre-commit hooks (the “don’t rely on memory” option)

Use [`pre-commit`](https://pre-commit.com/) so code gets checked **before each commit**.

Install:

```bash
pip install pre-commit
```

Create `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/psf/black
    rev: 24.3.0   # pin a specific version
    hooks:
      - id: black

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.4.4   # pin a specific version
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
```

Then:

```bash
pre-commit install
```

Now, every `git commit` will:

1. Run Black → reformat files
2. Run Ruff → fix what it can, fail if issues remain

Dev flow:

* Try to commit
* If it fails, let Black/Ruff change files
* Re-run tests if needed
* Commit again

---

## 7. CI integration (GitHub Actions / GitLab / Jenkins)

In CI, you usually **don’t auto-fix**; you just fail if code doesn’t pass.

Example GitHub Actions snippet:

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install deps
        run: |
          pip install --upgrade pip
          pip install ruff black

      - name: Run Black (check only)
        run: black --check .

      - name: Run Ruff
        run: ruff check .
```

CI is your “last line of defense” to ensure formatter/linter are enforced.

---

## 8. Practical profiles for your use-cases

### A. API Web Services (FastAPI/Flask/Django/etc.)

**Goals**:

* Clean, readable handler code
* Avoid common bugs & security-ish smells
* Enforce import order & consistent formatting

Recommended Ruff rule set (already in example):

* `E, F` – base errors
* `I` – import sorting
* `B` – bugbear (e.g. mutable defaults, unused loop variables)
* `UP` – pyupgrade (modern syntax)

Extras to consider:

* `S` (security) via `ruff`’s bandit rules (optional; can be noisy)
* If you use type hints seriously: add a type checker (mypy/pyright) later.

Typical uses:

* Catch `except: pass`, unused variables, unreachable code.
* Be strict about mistakes in auth/middleware/logging layers.

---

### B. Backend Processing Services / Batch Jobs

**Goals**:

* Maintainability over time
* Beware of “big ball of mud” scripts
* Clear logging & control flow

Same Ruff base rules + consider:

* Complexity limits via `C90`-style rules (cyclomatic complexity) if you want to prevent giant functions. For example:

  ```toml
  [tool.ruff.lint]
  select = ["E", "F", "I", "B", "UP", "C90"]
  ```

* Black ensures all of your large batch jobs have a consistent structure → easier to navigate.

Good patterns:

* Use Ruff to enforce no unused imports or variables (common in evolving jobs).
* Use Black to normalize indentation and keep big functions readable.

---

### C. PySpark / Data Engineering Scripts

**Goals**:

* Avoid silent bugs in transformations
* Keep scripts readable despite chained calls
* Avoid “presto spaghetti”

Tips:

* Use Black’s line breaking to make chained Spark calls more readable:

  ```python
  (
      df.filter(...)
        .groupBy(...)
        .agg(...)
        .write
        .mode("overwrite")
        .parquet(output_path)
  )
  ```

* Ruff catches:

  * Unused imports (`from pyspark.sql import functions as F` but never used)
  * Unused variables
  * Accidental shadowing of builtins (`list`, `id`, etc.)
  * Bare `except` in job orchestration logic

* For ad-hoc one-off jobs you might loosen some rules; for long-lived production jobs keep the full ruleset.

You can also exclude very transient directories (e.g., `experiments/`) if you want more freedom there.

---

## 9. Ignoring specific rules / lines when required

Sometimes you intentionally violate a rule (e.g. debug code, weird compatibility hack).

### Ignore a **single line**

```python
value = some_very_long_call(...)  # noqa: E501
```

For Ruff specifically, you can be more explicit:

```python
value = some_very_long_call(...)  # noqa: E501, B008
```

### Ignore a rule for a whole file

Top of file:

```python
# ruff: noqa: E501
```

or in config, put that file in a more specific `per-file-ignores`:

```toml
[tool.ruff.lint.per-file-ignores]
"migrations/*.py" = ["E501", "E302"]
"tests/*" = ["B008"]
```

Use this sparingly, but it’s useful when integrating legacy code.

---

## 10. How they cooperate together

**Ordering**:

1. **Black** formats the code.
2. **Ruff** sorts imports + enforces rules (and may autofix some).

Or invert it:

* Some people run Ruff first (with import sorting), then Black, then Ruff again in check-only mode.
* With pre-commit, order is determined by the hooks—both approaches are workable as long as it’s consistent.

The important bit:

* **Let Black own formatting** (line length, spaces, etc.)
* Configure Ruff to not fight Black (ignore `E203`, `E501`).

---

## 11. Recommended “starter kit” for your stack

For *API web services + backend workers + PySpark jobs*:

1. Add `pyproject.toml` with:

   * Black config
   * Ruff config as shown above
2. Add `.pre-commit-config.yaml` with Black + Ruff
3. In CI:

   * `black --check .`
   * `ruff check .`
4. Treat Ruff failures as **real bugs / maintainability issues**, not just style nitpicks.
5. Gradually tighten rules as the codebase matures (e.g., add `S` for security, `C90` for complexity, etc.).
