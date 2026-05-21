# dotfiles (`~/.config`)

Single source of truth for my macOS setup. The repo lives at `~/.config`; configs
that tools expect elsewhere (`~/.zshrc`, `~/.gitconfig`, `~/.claude/…`, Cursor) are
**symlinked** back from here by [`install.sh`](install.sh). Edit the file in this repo →
the live config updates.

> **Branches:** `macos` (current) · `bspwm` (old Linux setup, archived).

## Set up a new machine

```sh
git clone https://github.com/notmehul/dotfiles.git ~/.config
cd ~/.config
brew bundle --file=Brewfile   # install all packages/casks/taps
./install.sh                  # symlink configs into place (backs up anything it replaces)
```

Then recreate the **secrets** (intentionally NOT in the repo — see below).

## Maintenance

```sh
./maintenance.sh            # reclaim disk from regenerable caches (npm, uv, bun, brew, pods)
./maintenance.sh --deep     # also clears re-downloadable caches (HuggingFace, Playwright, …)
./maintenance.sh --dry-run  # preview, change nothing
```

See [`docs/changelog.md`](docs/changelog.md) for the full record of how this repo was
set up, and [`docs/python.md`](docs/python.md) for the Python/uv workflow.

## What's tracked

| Area | Path | Linked to |
| --- | --- | --- |
| Shell | `zsh/zshrc`, `zsh/zprofile`, `bash/bash_profile` | `~/.zshrc`, `~/.zprofile`, `~/.bash_profile` |
| Git | `git/config`, `git/ignore` | `~/.gitconfig` (also read via XDG) |
| Packages | `Brewfile`, `packages.md` | — (run `brew bundle` / reinstall globals) |
| Python | `uv/uv.toml` (uv manages Python — see `docs/python.md`) | in-place |
| Scripts/docs | `install.sh`, `maintenance.sh`, `docs/` | — |
| Shell tooling | fzf, atuin, bat, duf, zoxide + zsh-autosuggestions/fast-syntax-highlighting/completions — via Brewfile, wired in `zsh/zshrc` | — |
| Window mgmt | `yabai/`, `skhd/`, `sketchybar/` | in-place (already under `~/.config`) |
| Terminal/prompt | `kitty/`, `starship.toml` | in-place |
| Editors | `cursor/settings.json`, `cursor/keybindings.json` | Cursor → `~/Library/Application Support/Cursor/User/` |
| AI tools | `claude/{CLAUDE.md,settings.json}`, `codex/AGENTS.md` | `~/.claude/`, `~/.codex/` |
| Misc | `gh/config.yml`, `opencode/`, `openspec/`, `htop/`, `neofetch/`, `cmux/` | in-place |

## Secrets — recreate per device (never committed)

API keys live in a single gitignored **`.env`** (sourced by `zsh/zshrc`); configs
reference them via env vars (e.g. Codex `bearer_token_env_var`, context7 `CONTEXT7_API_KEY`,
Gemini `${NOTION_API_KEY}`). Copy the template and fill it in:

```sh
cp .env.example .env   # then paste your keys
```

Other per-device secrets (recreate via each tool, not stored here):

| Secret | Regenerate with |
| --- | --- |
| `gh/hosts.yml` | `gh auth login` |
| `rclone/rclone.conf` | `rclone config` |
| `~/.codex/auth.json` | sign in to Codex |
| `~/.claude/settings.local.json` | recreated by Claude Code |
| `opencode/antigravity-accounts.json` | re-auth in OpenCode |
| `zed/settings.json` (context7 key, inline) | local-only; Zed lacks reliable env-var support |

## ⚠️ Not portable / kept local-only

These exist on disk but are **gitignored** because they mix in live secrets or
machine-specific state — recreate or hand-edit them per machine:

- **`~/.codex/config.toml`** — secrets now externalized to `.env` (`TYPMO_API_KEY`,
  `CONTEXT7_API_KEY`); file stays local-only because it also has a per-machine
  `[projects.*]` trust list and tool-managed plugin/marketplace state.
- **`~/.gemini/settings.json`** — Notion token externalized to `${NOTION_API_KEY}`.
- **`zed/settings.json`** — context7 key still inline (Zed lacks reliable env-var
  expansion for extension settings); kept local-only. Rotate if ever exposed.

**Things that simply can't live here (reinstall, don't symlink):**
- Global packages — `npm i -g …` / `bun add -g …`; see `packages.md`.
- Runtime/version managers: uv-managed Pythons (`uv python install`). Node is Homebrew-provided.
- App state/caches: `~/.claude/{projects,sessions,plugins,…}`, `~/.codex/{sessions,sqlite,…}`,
  `raycast/extensions`, `zed/embeddings`. All gitignored.

## Notes / cleanup backlog

- **Cursor atomic-save caveat:** Cursor may replace the symlinked `settings.json` with a
  real file on save. If your changes stop syncing to the repo, re-run `./install.sh`.
- **Skill duplication:** the same skills live in `opencode/skill/`, `~/.claude/skills/`,
  and `~/.codex/skills/`, but they've **drifted** (per-tool edits). Treated as intentional;
  cruft (`__pycache__`, `.DS_Store`, packaged `dist/`) cleaned out. Collapse to a canonical
  copy + symlinks only after deciding which version wins per skill.
- **Python:** consolidated onto uv (3.12 default) — see `docs/python.md`. One step left:
  uninstall the python.org Framework once its old tools are fully migrated (needs `sudo`).
- **Node:** consolidated onto Homebrew node (nvm removed, ~2.1 GB freed); globals reinstalled.
- **Git identity:** `git/config` uses `mehulsrivastava090801@gmail.com`. Use a per-dir
  `includeIf` if you want a separate work identity (`hello@biome.in`).

## Roadmap: Nix

Moving to **nix-darwin + home-manager**, which will replace `install.sh`'s symlinking
with declarative `home.file` / `xdg.configFile` entries pointing at these same files.
The old experimental flake was removed; the flake will be rebuilt from scratch. The flat
layout here is deliberately home-manager-friendly.
