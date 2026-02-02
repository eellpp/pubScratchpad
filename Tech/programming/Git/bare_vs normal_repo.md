Below is a practical “user guide” for **non-bare** vs **bare** Git repositories: what they are, why you’d use each, typical workflows, and the pitfalls / best practices to keep things clean and safe.

---

## Core concepts

### Non-bare repo (normal repo)

A **non-bare** repo is what you get from `git init` or `git clone` on your laptop:

* Has a **working directory** (your checked-out files you edit).
* Has a `.git/` directory that stores the repository data.

**Think:** “A place to work.”

### Bare repo

A **bare** repo is *only* the Git database (no working directory):

* Typically ends with `.git` (convention), e.g. `myproject.git`
* Contains `HEAD`, `objects/`, `refs/`, etc.
* You **don’t** directly edit files here.

**Think:** “A place to share.”

---

## Why have each one?

### Why you want a non-bare repo

* You’re developing, editing, testing, building.
* You want branches checked out as files.
* You want tooling (IDE, tests, build) running on a working tree.

### Why you want a bare repo

* You want a **central “remote”** on a server (home server, LAN server, etc.).
* It’s safer for collaboration because nobody is “working” directly in the shared repo.
* Git operations like pushing/fetching are clean and predictable.
* No risk of someone pushing into a repo that currently has checked-out files.

**Rule of thumb:**

* **Developers use non-bare.**
* **Servers host bare.**

---

## Intended use (common setups)

### Setup A: Solo developer + home server remote

* Laptop: non-bare repo
* Home server: bare repo as the remote
* Optional: deployment folder on server (a *separate* non-bare repo or a working tree) updated by hooks or pull.

### Setup B: Team repo

* Server: bare repo (central)
* Everyone clones it locally (non-bare) and pushes/pulls to/from the bare remote.

---

## Workflows

## 1) Non-bare workflow (everyday dev)

### Create repo

```bash
mkdir myproj && cd myproj
git init
```

### Typical loop

```bash
git checkout -b feature/x
# edit files
git add .
git commit -m "Implement X"
git push -u origin feature/x
```

### Update your branch

```bash
git fetch origin
git rebase origin/main   # or: git merge origin/main
```

### Good practices (non-bare)

* Commit small logical chunks.
* Use `.gitignore` early.
* Prefer feature branches over working on `main`.
* Rebase for clean history (if you like linear), merge for traceability (if you like explicit merges). Pick one style and stick to it.

---

## 2) Bare workflow (as the “remote”)

### Create a bare repo (on server)

```bash
git init --bare /srv/git/myproj.git
```

### Add it as remote (from your laptop)

```bash
git remote add origin user@server:/srv/git/myproj.git
git push -u origin main
```

### Cloning from bare repo (any client)

```bash
git clone user@server:/srv/git/myproj.git
```

### Good practices (bare)

* **Never “work” inside a bare repo.** No editing files there.
* Use permissions to control who can push.
* Prefer SSH access with keys; disable password login if possible.
* Back up the bare repo directory (it’s the source of truth).

---

## A very important gotcha: “Don’t push into a checked-out branch”

If you host a **non-bare** repo on the server and someone pushes to its currently checked-out branch (e.g., `main`), Git may refuse or you may end up with a messed up working directory.

That’s why **bare** repos are the standard for remotes.

If you *must* push into a non-bare repo (not recommended), you’d need special config like:

* `receive.denyCurrentBranch updateInstead` (still risky; use only if you understand consequences).

**Best standard practice:** Remote repo on server = **bare**.

---

## Deployment patterns (server side)

### Pattern 1: Bare repo + post-receive hook (recommended)

* Server has:

  * `/srv/git/myproj.git` (bare remote)
  * `/srv/www/myproj` (deployment working tree)
* On push, a hook updates the deployment tree.

High level idea:

* Push to bare remote
* Hook runs `git --work-tree=... --git-dir=... checkout -f main` (or pulls into deployment)

**Why it’s good:** clean separation between “remote store” and “live files”.

### Pattern 2: Bare repo + manual pull on deployment folder

* Deployment folder is a separate non-bare clone
* You SSH in and `git pull`
* Simple, less automation.

### Pattern 3: Non-bare repo on server as “remote” (avoid)

* Easy to set up, but easy to break.
* Often causes “push rejected” or messy working tree.

---

## Standards & best practices (both types)

### Branching & history

* Protect `main`: avoid force pushes on shared branches.
* Use tags for releases: `v1.2.0`.
* Write meaningful commit messages:

  * “Fix NPE in ingestion pipeline when header missing”
  * not “update”, “changes”

### Repo hygiene

* Put generated artifacts in `.gitignore` (build output, logs, local DBs, secrets).
* Never commit secrets. Use `.env` + `.env.example`.
* Keep large files out (use Git LFS if needed).

### Access & safety (especially for home servers)

* Use SSH keys; disable password auth.
* Limit who can access the repo path.
* Backups:

  * A bare repo is easy to backup by copying the directory.
  * You can also do `git bundle` for portable backups.

---

## What to “take care of” (pitfalls)

1. **Treat bare repo as storage only**

   * No file edits, no builds, no running apps from it.

2. **Don’t deploy directly from the bare repo**

   * Use a separate working directory (deploy folder) updated via hooks or pull.

3. **Avoid pushing to a server repo that has a checked-out branch**

   * Use a bare repo as remote instead.

4. **Permissions matter**

   * Bad permissions can let someone overwrite branches or delete tags.

5. **Backups**

   * Bare repo is source-of-truth: back it up regularly.

---

## Quick decision guide

* “I want to code here” → **non-bare**
* “I want others to push here / I want a central remote on my LAN server” → **bare**
* “I want to host code and also deploy a website/app” → **bare + separate deploy working tree**
