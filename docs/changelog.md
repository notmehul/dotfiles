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
  Repeatable via [`maintenance.sh`](../maintenance.sh), which also runs a
  `brew linkage` check after cleanup — pruning old kegs can leave a dependent
  pointing at a deleted `.dylib` (e.g. node vs llhttp); the check surfaces it
  so you `brew reinstall` the formula instead of hitting a `dyld` abort later.
- **CLI tools** added to the Brewfile + wired into `zshrc` (guarded): `fzf` (Ctrl-T/Alt-C),
  `atuin` (Ctrl-R history), `bat` (cat/man pager), `duf` (df).
- **git/config** modernized: `push.autoSetupRemote`, `pull.rebase`, `fetch.prune`,
  `rebase.autoStash`, zdiff3 conflicts, histogram diff, rerere, sorted branches/tags,
  and aliases (`lg`, `st`, `co`, `amend`, `wip`, …).
- **zoxide** restored and made to stick: initialized with `--cmd cd` so it replaces `cd`,
  auto-learns directories, and `cdi` opens an fzf picker. Database seeded with existing
  project dirs (the empty DB was why it felt broken before).

## 7. Fish-like zsh
- Added `zsh-autosuggestions` (inline history suggestions, → to accept),
  `zsh-fast-syntax-highlighting` (command coloring, sourced last), and
  `zsh-completions` — all via Brewfile, sourced in `zsh/zshrc` (no plugin manager).
- Enabled the completion system: `compinit -u` (the `-u` trusts Homebrew's
  group-writable `/opt/homebrew/share`, the standard fix for the "insecure
  directories" warning) + two zstyles (menu select, case-insensitive matching).
- Startup stays ~0.6 s (no measurable cost).

## 8. Agent skills → one canonical pool
- Skills had **triplicated and drifted** across `opencode/skill/`, `~/.claude/skills/`,
  and `~/.codex/skills/`. Research confirmed the ecosystem converged on the
  [Agent Skills standard](https://agentskills.io): **Codex and OpenCode read
  `~/.agents/skills` natively**, and Claude Code follows symlinks placed in
  `~/.claude/skills`. The old per-tool dirs are no longer in any tool's search path.
- Consolidated all 12 authored skills into **`~/.agents/skills`** (its own git repo),
  picking the best version per skill (OpenCode's de-Clauded/expanded copies won
  everywhere except `skill-creator`, where Codex's eval-driven version won). Wording
  kept tool-neutral for portability.
- `install.sh` symlinks each pooled skill into `~/.claude/skills` (also a safety net for
  the `skills` CLI bug where global installs skip the Claude symlink). Removed the legacy
  `opencode/skill/` (16 files) and `~/.codex/skills/` authored copies. Third-party skills
  (ui-ux-pro-max, find-skills, remotion, cua-driver) stay CLI/app-managed and gitignored.

## 9. Perceptual color normalization (The Dark Side accents)
- The shared accent palette (purple/blue/amber/pink/etc.) had been copied as **raw
  syntax hues** into `sketchybar/colors.sh`, `cmux/cmux.json`, and `zed/settings.json`.
  Those hues were never iso-luminant: measured in OKLab they spanned **L 0.52 (purple)
  to 0.77 (amber)**, so a focused "dev" space looked ~half as bright as a "media" space,
  and pure-white (`#ffffff`, L 1.0) status text outshone every icon. The unevenness was
  baked into the colors, not an opacity/overlay artifact.
- Normalized all eight accents to a single **OKLab L≈0.70** (vivid variant: each hue
  pinned to the max chroma it holds at that lightness, hue preserved), and dropped the
  neutral foreground from `#ffffff` to a gray at the same L (`#9e9e9e`) — softer for the
  GeistMono label font while still **~7–8:1 WCAG contrast** on the bar (AAA). Now every
  glyph on the bar reads at one intensity. Conversion math: sRGB→OKLab, fix L, binary-
  search max in-gamut chroma per hue.
- Kept the same hexes in sync across the files (`zed/settings.json` gitignored, so it
  changed on disk only; `starship.toml` prompt accents synced too). Pre-existing
  terminal-ANSI colors (`Aqua`/`Teal` `#7287fd`, `Red` `#d20f39`, yellow `#e5c07b`)
  were left as-is — they belong to the kitty/ghostty ANSI palette, where intentional
  luminance variation is correct.
- **Follow-up — sketchybar runs hotter (L≈0.75, not 0.70).** On the actual bar the
  normalized colors read dull because the bar background is very translucent
  (`0x44000000` + 30px blur) so the desktop bleeds through and mutes them, unlike the
  more-opaque editor/terminal (`#000000B3`). So `sketchybar/colors.sh` alone was bumped
  to **OKLab L≈0.77** with chroma pushed near the gamut edge (×0.96) — deliberately
  brighter than zed/cmux/starship so it *looks* equally vivid. These hexes are now
  intentionally NOT in sync with the others; don't re-flatten them.

## Known follow-ups
- **Framework Python** removal (sudo step) when ready.
- Rotate any API keys that were previously sitting in plaintext, as good hygiene.
- Optional, not done: direnv+uv auto-venv; `fd`/`dust`/`delta`; macOS `defaults` tweaks.
