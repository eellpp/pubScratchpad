
# ✅ What is `pathlib`?

`pathlib` provides an **object-oriented way to work with files and directories** instead of manually handling strings.
It is cleaner, safer, cross-platform, and far easier than `os.path`.

```python
from pathlib import Path
```

---

# ✔️ 1. Creating Paths

## Current working directory

```python
p = Path.cwd()
print(p)
```

## Home directory

```python
home = Path.home()
```

## Create a path object

```python
p = Path("folder/subfolder/file.txt")
```

`pathlib` automatically handles Windows vs Linux slashes.

---

# ✔️ 2. Joining Paths (No More `os.path.join`!)

```python
p = Path("folder") / "subfolder" / "file.txt"
```

Equivalent to `folder/subfolder/file.txt`
On Windows → `folder\subfolder\file.txt`

---

# ✔️ 3. Check File / Directory Existence

```python
p.exists()          # True | False
p.is_file()         # Is it a file?
p.is_dir()          # Is it a directory?
```

---

# ✔️ 4. Reading & Writing Files

## Read Text

```python
content = Path("notes.txt").read_text()
```

## Write Text

```python
Path("notes.txt").write_text("Hello World")
```

## Binary

```python
data = Path("image.png").read_bytes()
Path("copy.png").write_bytes(data)
```

---

# ✔️ 5. Creating Directories

```python
Path("new_folder").mkdir()
```

Avoid error if exists:

```python
Path("new_folder").mkdir(exist_ok=True)
```

Create parent dirs if missing:

```python
Path("parent/child/grandchild").mkdir(parents=True, exist_ok=True)
```

---

# ✔️ 6. Listing Files in a Directory

```python
for p in Path(".").iterdir():
    print(p)
```

Only files:

```python
[p for p in Path(".").iterdir() if p.is_file()]
```

---

# ✔️ 7. Glob / Pattern Matching

## Get all `.txt` files

```python
for f in Path(".").glob("*.txt"):
    print(f)
```

## Recursive search

```python
for f in Path(".").rglob("*.txt"):
    print(f)
```

---

# ✔️ 8. File Name Parts

```python
p = Path("folder/sub/file.tar.gz")

p.name        # 'file.tar.gz'
p.stem        # 'file.tar'
p.suffix      # '.gz'
p.suffixes    # ['.tar', '.gz']
p.parent      # 'folder/sub'
p.anchor      # drive root if any
```

---

# ✔️ 9. Copy / Move / Delete Files

> pathlib doesn't copy/move itself — use `shutil` with `Path`

```python
import shutil
p = Path("file.txt")

shutil.copy(p, "backup.txt")
shutil.move(p, "new_location/file.txt")
p.unlink()        # delete file
```

Delete empty directory:

```python
Path("empty_dir").rmdir()
```

---

# ✔️ 10. Opening Files Manually

For custom reading behavior:

```python
with Path("file.txt").open("r", encoding="utf-8") as f:
    for line in f:
        print(line)
```

---

# ✔️ 11. Getting File Metadata

```python
p = Path("file.txt")
stat = p.stat()

stat.st_size     # file size
stat.st_mtime    # modified time
stat.st_ctime    # created time (platform dependent)
```

---

# ✔️ 12. Absolute & Normalized Paths

Absolute path:

```python
Path("file.txt").resolve()
```

Check if absolute:

```python
Path("/usr/bin").is_absolute()
```

---

# ✔️ 13. Environment-Safe Temporary Paths

```python
import tempfile
tmp = Path(tempfile.gettempdir())
```

---

# ✔️ 14. Convenient Short Snippets

## Delete all `.log` files

```python
for f in Path(".").glob("*.log"):
    f.unlink()
```

## Ensure directory exists before writing

```python
p = Path("logs/app.log")
p.parent.mkdir(parents=True, exist_ok=True)
p.write_text("log started")
```

## Rename a file

```python
Path("a.txt").rename("b.txt")
```

---

# ✔️ 15. When to Use `pathlib` vs `os`

Use **pathlib always** unless:

* working with legacy libraries
* working with very old Python (<3.4)

Convert Path → string when needed

```python
str(Path("file.txt"))
```

---

# 🎯 Summary Cheat Sheet

| Task              | Code                                 |
| ----------------- | ------------------------------------ |
| Current dir       | `Path.cwd()`                         |
| Home dir          | `Path.home()`                        |
| Join paths        | `Path() / "x" / "y"`                 |
| Exists?           | `p.exists()`                         |
| Is file / dir     | `p.is_file()` / `p.is_dir()`         |
| Read / Write text | `read_text()` / `write_text()`       |
| List files        | `iterdir()`                          |
| Search            | `glob()` / `rglob()`                 |
| Create dir        | `mkdir(parents=True, exist_ok=True)` |
| Delete            | `unlink()`                           |
| Metadata          | `stat()`                             |

---

If you want, I can also provide:

* **A quick PDF-style reference**
* **Advanced usage (permissions, symlinks, async, pathlib vs os perf)**
* **Dask / multiprocessing friendly pathlib usage**
  Just tell me 😊
