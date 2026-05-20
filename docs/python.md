# Python: single source of truth via uv

We standardised Python on **[uv](https://docs.astral.sh/uv/)**: uv manages the
interpreter *and* per-project environments, pinned to exact versions, reproducibly
across machines. This replaces the previous tangle (python.org Framework, pyenv,
anaconda, `~/Library/Python` user-sites, Homebrew python).

## Current state (done)

- **Default `python3` / `python`** → uv-managed **3.12.12** (shims in `~/.local/bin`,
  created by `uv python install 3.12 --default --preview`).
- **Global policy** in [`uv/uv.toml`](../uv/uv.toml): `python-preference = "only-managed"`
  — uv never uses system/brew Python; it always uses its own.
- **Global CLI tools** reinstalled under uv: `git-filter-repo`, `pyright`, `jupyterlab`
  (see [`packages.md`](../packages.md)).
- **Removed:** pyenv (1.1 GB), `~/Library/Python/{3.9,3.11,3.14}`, anaconda conda-init
  block. PATH de-duplicated.

## How to work day-to-day

```sh
# new project
uv init myproj && cd myproj      # creates pyproject.toml + .python-version (3.12)
uv add requests pandas           # deps go in THIS project's venv, not globally
uv run script.py                 # runs in the project venv

# pin a project to a specific Python
uv python pin 3.13

# install/replace a global CLI tool
uv tool install ruff
```

Rule of thumb: **libraries → `uv add` in a project; standalone CLI tools → `uv tool install`.**
Nothing goes into a global `pip install` anymore.

## Remaining step — retire the Framework python (needs `sudo`, do when ready)

The python.org Framework 3.11 is still installed and on `PATH` so its old tools
(streamlit, spacy, the ~50 globally-pip'd libraries) keep working during the transition.
Once you've confirmed everything you need is a uv tool or lives in a project venv:

```sh
# 1. drop it from PATH — remove this line from ~/.config/zsh/zprofile:
#    PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"

# 2. uninstall the framework (sudo)
sudo rm -rf "/Library/Frameworks/Python.framework/Versions/3.11"
sudo rm -rf "/Applications/Python 3.11"
sudo pkgutil --forget org.python.Python.PythonFramework-3.11 2>/dev/null
sudo pkgutil --forget org.python.Python.PythonApplications-3.11 2>/dev/null

# 3. open a new shell; confirm uv still owns python3
python3 --version   # -> 3.12.x from ~/.local/bin
```

Homebrew's `python@3.13/3.14` stay installed — they're dependencies of brew formulae
(ranger, memo, whisper), not something you call directly. Apple's `/usr/bin/python3`
is left untouched.

## New machine

`install.sh` + `brew bundle` handle configs/packages. For Python, run the commands in
[`packages.md`](../packages.md) to recreate the uv interpreter and global tools.
