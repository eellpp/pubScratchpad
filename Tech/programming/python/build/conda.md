conda is a package manager. Anaconda is the distribution.   
conda can be installed separately from anaconda.  
conda can be compared to pip + virtualenv  


## Conda repo vs pypi repo
pypi repo is the python repo containing all python packages. However it is not guaranteed to have all platform specific package version. Especially windows  
conda repo contains python repo for all major environments  


### create env with specific python version using custom channel
conda create -y -n py36 python=3.6 --channel <path to custom channel> --override-channel

### create dev env
conda create --name dev

source activate <env name>

### Reusing enviroments
conda env export > environment.yml  
conda env create -f environment.yml 

conda should fetch the package mapping to conda or pypi channels


### List Env
conda env list

### Get info on conda env
conda info --env  
conda config --get-channels

### search within a channel
conda search --channel <channel url> <package_name>

## Conda Config File
The conda configuration file, .condarc, is an optional runtime configuration file that allows advanced users to configure various aspects of conda, such as which channels it searches for packages, proxy settings, and environment directories. 

### Condarc path
condarc file is frequently found in:  
- macOS: /Users/Username.  
- Linux: ~/. condarc.  
- Windows: C:\Users\Username.  

Example config file  
https://docs.conda.io/projects/conda/en/latest/configuration.html

```bash
default_channels:

ssl_verify: false
```


# 🧠 Why Use Conda?

Conda is not just a package manager. It is:

* ✔ A **Python version manager**
* ✔ A **virtual environment manager**
* ✔ A **package manager for Python + non-Python libs** (like SSL libs, Java, gcc, numpy deps etc.)

This makes it especially useful for:

* Data workloads
* ML libraries
* Systems depending on native binaries
* Enterprise reproducibility

---

# 🧭 Core Concepts at a Glance

| Thing             | Meaning                                                       |
| ----------------- | ------------------------------------------------------------- |
| Base environment  | Global conda system env (Avoid installing your app here)      |
| Conda environment | Isolated Python + dependencies                                |
| pip               | Python package manager (works inside env)                     |
| venv              | Python virtual environment alternative (lighter, Python-only) |
| environment.yml   | Standard reproducible conda env file                          |
| requirements.txt  | pip equivalent reproducibility file                           |

---

# 🚀 Install Conda

Either install:

* **Anaconda** (heavy, comes with packages)
* **Miniconda** (recommended: lightweight)
* **Mamba** (faster conda alternative)

---

# ✅ 1️⃣ Create a New Conda Environment

Create env with specific Python version

```bash
conda create -n myenv python=3.11
```

List envs:

```bash
conda env list
```

Activate:

```bash
conda activate myenv
```

Deactivate:

```bash
conda deactivate
```

Delete env:

```bash
conda remove --name myenv --all
```

---

# 🐍 2️⃣ Install / Change Python Version in an Existing Env

To install new python version inside environment:

```bash
conda install python=3.12
```

Check version:

```bash
python --version
```

---

# 📦 3️⃣ Installing Packages

---

## ✔ Preferred: Install via conda

```bash
conda install numpy
```

Install from conda-forge (huge ecosystem):

```bash
conda install -c conda-forge numpy
```

---

## ✔ You can also use pip inside conda

Activate env → install normally:

```bash
conda activate myenv
pip install requests
```

This is common and safe when done correctly.

---

### ⚠️ Golden Rule

> Don’t mix `conda install` and `pip install` randomly.

Use strategy:
1️⃣ Install Python & main libs via conda
2️⃣ Then install remaining packages via pip
3️⃣ Prefer **conda-forge channel first**

---

# 📜 4️⃣ Export Environment to Recreate on Another Machine

---

### Option A: Best — Export exact environment

```bash
conda env export > environment.yml
```

Copy file → recreate elsewhere:

```bash
conda env create -f environment.yml
```

Perfect for:

* deployment
* CI/CD
* reproducibility
* team sharing

---

### Option B: Export only top-level packages

More portable:

```bash
conda env export --from-history > environment.yml
```

---

### Option C: Using pip style (only Python deps)

Inside env:

```bash
pip freeze > requirements.txt
```

Recreate:

```bash
pip install -r requirements.txt
```

---

# 🧪 5️⃣ Local Dev Workflow (conda + pip + venv strategy)

---

## Recommended Architecture

### 🔹 Local Development

Use Conda for:

* Python version management
* Big libs / system deps

Use pip for:

* small python packages
* frameworks
* internal libs

Example flow:

```bash
conda create -n project python=3.12
conda activate project
conda install -c conda-forge pandas
pip install fastapi uvicorn
```

Save env:

```
conda env export > environment.yml
```

---

## 🔹 Where does `venv` fit in?

### Use `venv` when

* lightweight environment needed
* pure Python project
* production Docker builds
* server installs
* minimal dependency problems

Example:

```bash
python -m venv venv
source venv/bin/activate   # Linux/Mac
venv\Scripts\activate      # Windows
pip install -r requirements.txt
```

---

# 🏭 6️⃣ Production Recommendations

---

## 🏆 Best Practice Options

### Option 1 — Production Uses Conda

Use when:

* Scientific packages
* GPU / ML
* Complex system dependencies

Workflow:

```
conda env export > environment.yml
conda env create -f environment.yml
conda activate env
```

---

### Option 2 — Dev Conda → Prod pip

Use when:

* prod is docker / cloud minimal base image
* only Python deps matter

Workflow:

```bash
pip freeze > requirements.txt
```

Then production:

```bash
python -m venv venv
pip install -r requirements.txt
```

---

# 🔥 Conda Useful Commands Cheat Sheet

List packages:

```bash
conda list
```

Search package:

```bash
conda search pandas
```

Update package:

```bash
conda update numpy
```

Update entire env:

```bash
conda update --all
```

Remove package:

```bash
conda remove pandas
```

---

# ⚠️ Common Mistakes & Fixes

---

### ❌ Installing packages into base environment

→ Causes conflicts
Use create env always

---

### ❌ Mixing pip + conda without discipline

Fix:

* install core deps via conda
* remaining via pip

---

### ❌ Forgetting to export env

Fix:

```
conda env export > environment.yml
```

---

### ❌ Using requirements.txt for conda environment

Use environment.yml instead

---

# 🎯 Quick Decision Guide

| Scenario                   | Best Tool              |
| -------------------------- | ---------------------- |
| Need Python + system libs  | Conda                  |
| Need exact reproducibility | environment.yml        |
| Simple web backend         | venv + pip             |
| Docker build               | pip + requirements.txt |
| ML / Data workloads        | Conda                  |
| Enterprise reproducibility | Conda                  |
| Minimal server             | venv                   |

---

# 🏁 Final Summary

Conda gives you:

* Python version isolation
* Virtual environments
* Package management including system libs
* Exact environment reproducibility

Combined with pip + venv when appropriate, you get:

* Great developer workflow
* Stable production replication
* Strong reproducibility guarantees

