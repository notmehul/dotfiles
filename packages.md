# Global packages (not symlinkable — reinstall on a new machine)

## Python — uv-managed (see docs/python.md)
Default interpreter is uv-managed **3.12** (`python-preference = only-managed` in `uv/uv.toml`).
Reinstall the default interpreter + global CLI tools:
```sh
uv python install 3.12 --default --preview
uv tool install git-filter-repo
uv tool install pyright
uv tool install jupyterlab
```
Project dependencies live in each project's own `uv` venv — not here.

## Node — Homebrew-provided (single source)
Node comes from Homebrew (`brew "node"`, in the Brewfile); nvm was removed. Reinstall globals:

## npm globals (`npm i -g …`)
- @fission-ai/openspec
- corepack
- eas-cli
- openclaw
- typmo-cli

## bun globals (`bun add -g …`)
- clawhub
