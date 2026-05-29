#!/usr/bin/env bash
# install.sh — link this repo's configs into the locations each tool expects.
# Idempotent: safe to re-run. On first run it ADOPTS existing home files into
# the repo; on a fresh machine it just creates the symlinks.
#
#   Usage:  ~/.config/install.sh           # link everything
#           ~/.config/install.sh --dry-run # show what would happen
set -euo pipefail

CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP="$CFG/.install-backups/$(date +%Y%m%d-%H%M%S)"
DRY=0; [ "${1:-}" = "--dry-run" ] && DRY=1

say() { printf '%s\n' "$*"; }
run() { [ "$DRY" = 1 ] && say "  [dry] $*" || eval "$*"; }

# link <repo_path> <live_path>
#   repo missing + live present  -> move live into repo, then symlink
#   both present                 -> back up live, repo wins, symlink
#   already correct symlink      -> no-op
link() {
  local repo="$1" live="$2"
  run "mkdir -p \"$(dirname "$repo")\" \"$(dirname "$live")\""
  if [ -L "$live" ] && [ "$(readlink "$live")" = "$repo" ]; then
    say "✓ $live"; return
  fi
  if [ ! -e "$repo" ] && [ -e "$live" ]; then           # adopt
    run "mv \"$live\" \"$repo\""
  elif [ -e "$repo" ] && [ -e "$live" ]; then            # repo wins, back up live
    run "mkdir -p \"$BACKUP$(dirname "$live")\""
    run "mv \"$live\" \"$BACKUP$live\""
  fi
  run "ln -sfn \"$repo\" \"$live\""
  say "→ $live -> $repo"
}

CURSOR="$HOME/Library/Application Support/Cursor/User"

say "Linking dotfiles from $CFG ..."
# shell
link "$CFG/zsh/zshrc"           "$HOME/.zshrc"
link "$CFG/zsh/zprofile"        "$HOME/.zprofile"
link "$CFG/bash/bash_profile"   "$HOME/.bash_profile"
# git — repo file lives at the XDG path git already reads ($CFG/git/config),
# but we also link ~/.gitconfig for tools that look there explicitly.
link "$CFG/git/config"          "$HOME/.gitconfig"
# AI tools
link "$CFG/claude/CLAUDE.md"    "$HOME/.claude/CLAUDE.md"
link "$CFG/claude/settings.json" "$HOME/.claude/settings.json"
link "$CFG/codex/AGENTS.md"     "$HOME/.codex/AGENTS.md"
link "$CFG/cursor/settings.json"     "$CURSOR/settings.json"
link "$CFG/cursor/keybindings.json"  "$CURSOR/keybindings.json"

# Agent skills: the canonical pool is its own repo at ~/.agents/skills, read
# natively by Codex and OpenCode. Claude only reads ~/.claude/skills, so symlink
# each skill there. Idempotent; also covers skills the `skills` CLI installs
# globally without creating the Claude symlink (vercel-labs/skills#851).
AGENTS_SKILLS="$HOME/.agents/skills"
if [ -d "$AGENTS_SKILLS" ]; then
  say "Linking agent skills into ~/.claude/skills ..."
  run "mkdir -p \"$HOME/.claude/skills\""
  for s in "$AGENTS_SKILLS"/*/; do
    name="$(basename "$s")"; dest="$HOME/.claude/skills/$name"
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "../../.agents/skills/$name" ]; then
      say "✓ skill $name"; continue
    fi
    run "ln -sfn \"../../.agents/skills/$name\" \"$dest\""
    say "→ skill $name"
  done
else
  say "(skip skills: ~/.agents not cloned — git clone it for shared agent skills)"
fi

say ""
say "Done. Backups (if any) in: $BACKUP"
say "Next: install packages with  ->  brew bundle --file=$CFG/Brewfile"
say "Secrets are NOT managed here — see README.md to recreate them."
