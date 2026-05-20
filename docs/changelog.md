# Config overhaul — change log

A record of the work that turned `~/.config` into a single source of truth.
Steady-state docs live in [`../README.md`](../README.md) and [`python.md`](python.md);
this file explains *what changed and why*.

## 1. Repo hygiene
- Went from **953 tracked files → ~40 config files**. The bulk removed was
  `spicetify/` (911 binary/font files) — spicetify is no longer used.
- Added a comprehensive [`.gitignore`](../.gitignore): secrets, machine state,
  caches, `node_modules`, editor DBs, Raycast extension binaries, `.DS_Store`.
- Untracked machine-state that had been committed: root `.DS_Store`, `colors.sh`/
  `icons.sh` (moved into `sketchybar/`), `zed/embeddings`+`prompts`, `fish_variables`.

## 2. Single source of truth via symlinks
- [`install.sh`](../install.sh) symlinks repo files into the locations tools expect
  (`~/.zshrc`, `~/.gitconfig`, `~/.claude/…`, `~/.codex/…`, Cursor). Idempotent;
  backs up anything it replaces to `.install-backups/`. Doubles as the new-machine
  bootstrap. Built this way because the harness (and good practice) won't let configs
  outside the repo be the source — so the repo owns the file and home points at it.
- Captured previously-loose configs: `zsh`, `bash`, `git`, `gh`, `cmux`, `openspec`,
  `opencode`, `cursor`, `claude`, `codex`, `sketchybar`.

## 3. Secrets → a single `.env`
- All API keys now live in one gitignored [`.env`](../.env.example) (template tracked),
  sourced by `zsh/zshrc`. Configs reference env vars instead of hardcoding:
  - Codex: `bearer_token_env_var = "TYPMO_API_KEY"`; context7 reads `CONTEXT7_API_KEY`.
  - Gemini: Notion header uses `${NOTION_API_KEY}`.
- `zed/settings.json` keeps its context7 key inline (Zed lacks reliable env-var
  expansion for extension settings) and is gitignored.
- No secret value is in git history.

## 4. Python → uv (see [python.md](python.md))
- Was a tangle of 5 Pythons (Framework, pyenv, anaconda, `~/Library/Python`, brew).
- Now: uv-managed **3.12** is the default `python3`; `uv/uv.toml` enforces
  `only-managed`. Removed pyenv (1.1 GB), `~/Library/Python/{3.9,3.11,3.14}`, and the
  dead anaconda conda-init block. Global CLI tools (`git-filter-repo`, `pyright`,
  `jupyterlab`) reinstalled as uv tools.
- Remaining manual step (needs sudo): uninstall the python.org Framework — see python.md.

## 5. Node → Homebrew
- Removed nvm (~2.1 GB) and the unused `node@22`. Node is now Homebrew-provided (one
  install; `gemini-cli`/`netlify-cli` need it anyway). npm globals reinstalled onto it.
- No `.nvmrc` was in use, so nothing relied on per-project node versions.

## 6. Disk, shell tools, git, zoxide
- **~29 GB reclaimed** from regenerable caches (npm 17 GB, uv, HuggingFace, Spotify, brew).
  Repeatable via [`maintenance.sh`](../maintenance.sh).
- **CLI tools** added to the Brewfile + wired into `zshrc` (guarded): `fzf` (Ctrl-T/Alt-C),
  `atuin` (Ctrl-R history), `bat` (cat/man pager), `duf` (df).
- **git/config** modernized: `push.autoSetupRemote`, `pull.rebase`, `fetch.prune`,
  `rebase.autoStash`, zdiff3 conflicts, histogram diff, rerere, sorted branches/tags,
  and aliases (`lg`, `st`, `co`, `amend`, `wip`, …).
- **zoxide** restored and made to stick: initialized with `--cmd cd` so it replaces `cd`,
  auto-learns directories, and `cdi` opens an fzf picker. Database seeded with existing
  project dirs (the empty DB was why it felt broken before).

## Known follow-ups
- **Agent skills** are triplicated and drifted across `opencode/skill`, `~/.claude/skills`,
  `~/.codex/skills` — owner is reviewing which version wins per skill.
- **Framework Python** removal (sudo step) when ready.
- Rotate any API keys that were previously sitting in plaintext, as good hygiene.
- Optional, not done: direnv+uv auto-venv; `fd`/`dust`/`delta`; macOS `defaults` tweaks.
