# Don’t mix Conda + pip randomly

## 1️⃣ What does “Don’t mix Conda + pip randomly” actually mean?

Both **conda** and **pip** can install Python packages, but they manage dependencies differently:

* **Conda**:

  * Solves the whole environment (Python version, C libs, BLAS/MKL, etc.).
  * Tracks all installed packages in its own database.
* **pip**:

  * Only knows about Python packages.
  * Doesn’t understand Conda’s dependency graph or compiled system libs.

If you alternate like this inside **one** env:

```bash
conda install numpy
pip install some-package
conda install scipy
pip install --upgrade numpy
```

you risk:

* `pip` upgrading/downgrading a package (`numpy`, `pandas`, etc.) that **Conda** installed in a carefully solved set → binary mismatches, weird crashes.
* Conda thinking one version is installed, but pip actually overwrote it.
* Subtle bugs: imports work, but you get segfaults, “DLL load failed”, or random runtime errors.

So “don’t mix randomly” means:

> Don’t just conda-install and pip-install back and forth without a plan, especially for big compiled libs (numpy, scipy, pytorch, etc.).

---

## 2️⃣ Safe pattern: Conda + pip together

It’s totally fine to use **pip inside a Conda env** if you follow a rule:

### ✅ Recommended workflow

1. **Create env with Conda (and pip)**

```bash
conda create -n myenv python=3.11 pip
conda activate myenv
```

2. **Install everything available from Conda first**

Prefer `conda-forge` or main channel:

```bash
conda install numpy pandas requests
# or
conda install -c conda-forge numpy pandas requests
```

3. **Only use pip for packages that Conda doesn’t have**

```bash
pip install my-rare-library
```

4. **After using pip, avoid more `conda install` in that env**
   (Conda may try to “fix” things and you can get conflicts.)

If you later need a lot of new stuff → create a new env instead of heavily mutating the old one.

---

## 3️⃣ Installing packages from a **remote PyPI repo** (e.g., private index)

You can use `pip` inside your Conda env to install packages from:

* a **private PyPI server**
* an internal mirror
* Artifactory / Nexus / Devpi, etc.

Assuming you’ve already:

```bash
conda activate myenv
```

### Option A: One-off install from custom index

```bash
pip install \
  --index-url https://mycompany.com/pypi/simple \
  some_package
```

If you want to use the remote index **in addition** to the public PyPI:

```bash
pip install \
  --extra-index-url https://mycompany.com/pypi/simple \
  some_package
```

* `--index-url` → *replace* default PyPI.
* `--extra-index-url` → *add* another source alongside PyPI.

If your remote repo uses self-signed cert or special HTTPS:

```bash
pip install \
  --index-url https://mycompany.com/pypi/simple \
  --trusted-host mycompany.com \
  some_package
```

---

### Option B: Configure pip globally/for user

So you don’t type URLs every time.

Create/edit:

* **Linux/macOS**: `~/.config/pip/pip.conf` *or* `~/.pip/pip.conf`
* **Windows**: `%APPDATA%\pip\pip.ini`

Example content:

```ini
[global]
index-url = https://mycompany.com/pypi/simple
; or to keep public PyPI as well:
; extra-index-url = https://pypi.org/simple
trusted-host = mycompany.com
```

Now, inside any Conda env:

```bash
pip install some_package
```

will use your remote repo automatically (according to config).

---

## 4️⃣ Inside Conda env, which `pip` is used?

After:

```bash
conda activate myenv
```

* `python` → Python from `myenv`
* `pip` → pip linked to **that same Python** in `myenv`

You can verify:

```bash
which python
which pip      # or `where pip` on Windows
```

All `pip install ...` now affects **only that env**, not your base/system Python.

---

## 5️⃣ Quick “do/don’t” summary

**Do:**

* ✅ Use Conda envs as the main isolation unit.
* ✅ Install as much as possible via `conda` (prefer `conda-forge` for big stacks).
* ✅ Use `pip` *only* for packages unavailable in Conda.
* ✅ After using pip, treat that env as “pip-touched” and avoid further big conda changes.

**Don’t:**

* ❌ Ping-pong between `conda install` and `pip install --upgrade` for core libs.
* ❌ Use pip to upgrade stuff like `numpy`, `pandas`, `scipy` if they came from Conda.
* ❌ Share one env between radically different projects; make new envs instead.
