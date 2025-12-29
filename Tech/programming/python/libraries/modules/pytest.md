## 1. pytest 

Think of pytest as:

* **Your main test runner** (instead of `unittest`)
* A **lightweight framework** that:

  * auto-discovers tests
  * gives clean `assert` usage
  * provides powerful **fixtures** for setup/teardown
  * has tons of plugins (`pytest-cov`, `pytest-xdist`, etc.)

You’ll typically use it for:

* **API / web services** – testing routes, auth, error handling
* **Backend ETL / batch jobs** – testing transformations, file I/O, DB operations

---

## 2. Install & basic usage

```bash
pip install pytest
# common extras
pip install pytest-cov pytest-xdist
```

Run tests from project root:

```bash
pytest                 # run everything
pytest tests/etl       # run only ETL tests
pytest -k "user"       # run tests whose name contains "user"
pytest -m "integration" # run tests with marker 'integration'
```

---

## 3. Typical project structure (API + ETL)

Example:

```text
my_project/
  src/
    my_project/
      __init__.py
      api/
        app.py
        routes_user.py
      etl/
        jobs/
          load_orders.py
          transform_sales.py
  tests/
    api/
      test_user_routes.py
      test_auth.py
    etl/
      test_transform_sales.py
      test_load_orders.py
    conftest.py
  pyproject.toml   # include pytest config here if you like
```

pytest will automatically look into `tests/` and find files named:

* `test_*.py` or `*_test.py`
* and functions/classes named `test_*`

---

## 4. Writing your first pytest tests

### Basic test

```python
# tests/etl/test_math_example.py
def test_add():
    assert 1 + 2 == 3
```

### Expecting an exception

```python
import pytest

def divide(a, b):
    return a / b

def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        divide(1, 0)
```

### Parameterized tests (very useful for ETL rules)

```python
import pytest

from my_project.etl.rules import normalize_country

@pytest.mark.parametrize("raw, expected", [
    ("INDIA", "India"),
    (" india ", "India"),
    ("usa", "USA"),
])
def test_normalize_country(raw, expected):
    assert normalize_country(raw) == expected
```

---

## 5. Fixtures – the real superpower

A **fixture** is reusable setup/teardown logic that you inject into tests.

### Simple fixture

```python
# tests/conftest.py
import pytest

@pytest.fixture
def sample_orders():
    return [
        {"id": 1, "amount": 100},
        {"id": 2, "amount": 200},
    ]
```

Use it in tests:

```python
# tests/etl/test_transform_sales.py
from my_project.etl.transform_sales import total_amount

def test_total_amount(sample_orders):
    assert total_amount(sample_orders) == 300
```

pytest automatically provides `sample_orders` by name.

---

### Fixture scope (speed optimization)

```python
@pytest.fixture(scope="session")
def db_engine():
    # e.g. create a SQLAlchemy engine to a test DB
    ...

@pytest.fixture(scope="function")
def db_session(db_engine):
    # transactional session per test
    ...
```

* `session` → created once per test run (good for DB engine, TestClient, etc.)
* `function` → created for each test (good for clean DB session, temp directory, etc.)

---

## 6. API Web Service Testing with pytest

### Example (FastAPI style, but same idea for Flask/others)

```python
# src/my_project/api/app.py
from fastapi import FastAPI

app = FastAPI()

@app.get("/ping")
def ping():
    return {"status": "ok"}
```

Test:

```python
# tests/api/test_ping.py
import pytest
from fastapi.testclient import TestClient
from my_project.api.app import app

@pytest.fixture(scope="session")
def client():
    return TestClient(app)

def test_ping(client):
    resp = client.get("/ping")
    assert resp.status_code == 200
    assert resp.json() == {"status": "ok"}
```

---

### Testing endpoints with dependencies (DB, auth, external APIs)

Use fixtures + monkeypatch/mock.

Example: external API client (e.g. `requests.get`):

```python
# src/my_project/api/routes_user.py
import requests
from fastapi import APIRouter

router = APIRouter()

@router.get("/user/{user_id}")
def get_user(user_id: int):
    resp = requests.get(f"https://example.com/api/users/{user_id}")
    resp.raise_for_status()
    data = resp.json()
    return {"id": data["id"], "name": data["name"]}
```

Test with monkeypatch:

```python
# tests/api/test_user_route.py
import pytest
from fastapi.testclient import TestClient
from my_project.api.app import app

@pytest.fixture(scope="session")
def client():
    return TestClient(app)

def test_get_user(monkeypatch, client):
    def fake_get(url):
        class FakeResponse:
            def raise_for_status(self): ...
            def json(self):
                return {"id": 42, "name": "Alice"}
        return FakeResponse()

    import requests
    monkeypatch.setattr(requests, "get", fake_get)

    resp = client.get("/user/42")
    assert resp.status_code == 200
    assert resp.json() == {"id": 42, "name": "Alice"}
```

Key ideas:

* Use **fixtures** for test clients and DB connections
* Use **monkeypatch/mocks** for external services

---

## 7. Testing Backend ETL Jobs

You usually have:

* functions that transform data (dicts, lists, DataFrames)
* code that reads/writes files
* code that interacts with DBs or S3

### a) Pure transformation tests – keep input small & explicit

```python
# src/my_project/etl/transform_sales.py
def total_amount(orders):
    return sum(o["amount"] for o in orders if o["amount"] > 0)
```

```python
# tests/etl/test_transform_sales.py
def test_total_amount_basic():
    orders = [{"amount": 10}, {"amount": -5}, {"amount": 20}]
    assert total_amount(orders) == 30
```

---

### b) Using `tmp_path` for file-based ETL

pytest gives you a `tmp_path` fixture → a temporary folder:

```python
# src/my_project/etl/jobs/load_orders.py
import json
from pathlib import Path

def load_orders(path: Path):
    with path.open() as f:
        return json.load(f)
```

```python
# tests/etl/test_load_orders.py
import json

from my_project.etl.jobs.load_orders import load_orders

def test_load_orders(tmp_path):
    path = tmp_path / "orders.json"
    data = [{"id": 1}, {"id": 2}]
    path.write_text(json.dumps(data))

    result = load_orders(path)
    assert result == data
```

---

### c) Integration tests with a real (test) DB

* Spin up a test DB (local Postgres, SQLite, docker container)
* Use fixture for DB engine/session
* Use `@pytest.mark.integration` so you can run them separately:

```python
import pytest

@pytest.mark.integration
def test_full_etl_run(db_session, tmp_path):
    # (…) run your full pipeline:
    # extract -> transform -> load
    # Assert on final DB state or output files
    ...
```

Then:

```bash
pytest -m "integration"
pytest -m "not integration"   # unit tests
```

---

## 8. Configuring pytest (pyproject.toml)

You can configure pytest centrally:

```toml
# pyproject.toml
[tool.pytest.ini_options]
minversion = "8.0"
addopts = "-ra -q"
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
```

Common options:

* `addopts` – default CLI options (`-ra` = show extra summary, `-q` = quiet)
* `testpaths` – where tests live
* `xfail_strict` – treat broken xfail as failures
* markers definition (for linting markers):

```toml
[tool.pytest.ini_options]
markers = [
  "integration: marks tests as integration tests",
  "slow: marks tests as slow",
]
```

---

## 9. Coverage (production expectation)

Use `pytest-cov`:

```bash
pip install pytest-cov
pytest --cov=src/my_project --cov-report=term-missing
```

In CI you might enforce minimum coverage:

```bash
pytest --cov=src/my_project --cov-fail-under=80
```

---

## 🔟 Running tests fast (parallel, selection)

* Run in parallel (for big ETL test suites):

  ```bash
  pip install pytest-xdist
  pytest -n auto
  ```

* Run only failed tests from last run:

  ```bash
  pytest --lf
  ```

* Run a single test function:

  ```bash
  pytest tests/api/test_user_route.py::test_get_user
  ```

---

## 1️⃣1️⃣ What “production-ready” pytest use looks like

For API + ETL projects, a solid baseline:

1. **pytest** as test runner
2. **tests/ folder**, separated into `api/` and `etl/`
3. **fixtures** in `conftest.py` for:

   * test client
   * DB session
   * common sample datasets
4. **markers** like `integration`, `slow`
5. **pytest-cov** with minimum coverage in CI
6. **pytest config in `pyproject.toml`** for consistency
7. External systems mocked/monkeypatched in unit tests
8. A smaller set of real **integration tests** (DB + external services in staging or docker)

---
Good questions—this is exactly the kind of “how do I wire this into my tools?” stuff that matters in real projects.

---

# 1. Can `setup.py` or `pyproject.toml` tell pytest to run only certain tests?

### a) With **`pyproject.toml`** (recommended way)

You can control **what pytest *discovers*** and/or **what it *runs by default***.

#### 1. Control which files/functions are considered tests

In `pyproject.toml`:

```toml
[tool.pytest.ini_options]
python_files = ["it_*.py", "test_*.py"]        # only files matching these
python_functions = ["it_*", "test_*"]         # only functions matching these
python_classes = ["Test*", "IT*"]             # only classes matching these
```

So if you want only tests starting with, say, `it_`:

```toml
[tool.pytest.ini_options]
python_files = ["it_*.py"]
python_functions = ["it_*"]
```

pytest will **ignore** everything else by default.

---

#### 2. Use `addopts` with `-k` to filter by name pattern

If you want to **run only tests whose name contains a pattern** (even if more exist), you can set:

```toml
[tool.pytest.ini_options]
addopts = "-k some_pattern"
```

Examples:

```toml
[tool.pytest.ini_options]
addopts = "-k etl"
```

Now `pytest` will *by default* only run tests whose name contains `etl` (file, class, or function name).

> ⚠️ Note: `-k` is a substring matcher, not a strict prefix; but you can control your naming so it behaves like one.

---

### b) With **`setup.py`**

pytest does **not** normally read configuration from `setup.py`. Historically, pytest config could go into:

* `pytest.ini`
* `tox.ini`
* `setup.cfg`

For example, in **`setup.cfg`** (old style):

```ini
[tool:pytest]
python_files = it_*.py
```

But in **`setup.py`** itself, putting pytest config is not the pattern. You *can* have custom commands that call `pytest` with specific args, but that’s not how people do global config anymore.

So:

* **Modern way** → use `pyproject.toml` (or `pytest.ini`).
* **Older but still used** → `setup.cfg` with `[tool:pytest]`.
* **Not recommended** → trying to encode pytest config inside `setup.py`.

---

## 2. Is pytest supported by PyCharm?

Yes, **PyCharm has first-class support for pytest**.

In practice, you get:

* You can set **pytest as the default test runner** for the project.
* You can **run/debug individual tests** by clicking the gutter icons (green play button next to test functions).
* It understands:

  * test discovery
  * fixtures
  * parametrized tests
* It can **show test trees**, filter tests, rerun failed tests, etc.
* Coverage (with pytest + coverage) integrates nicely into PyCharm’s UI.

If you haven’t already:

* Go to **Settings → Tools → Python Integrated Tools → Testing**
* Set **Default test runner = pytest**.

After that, you just right-click a test file / folder / function → *Run with pytest*.

---

### TL;DR

* **Yes**, you can tell pytest (via `pyproject.toml`) to only discover or run tests matching certain patterns:

  * `python_files`, `python_functions`, `python_classes`
  * or `addopts = "-k pattern"`
* **No**, `setup.py` isn’t the place to configure pytest; use `pyproject.toml`, `pytest.ini`, or `setup.cfg` instead.
* **Yes**, pytest is fully supported in **PyCharm** and is basically the “normal” test framework there now.

