#!/usr/bin/env bash
# maintenance.sh — reclaim disk from regenerable caches. Safe to run anytime.
#   ./maintenance.sh            # safe tier: npm, uv, bun, brew, cocoapods
#   ./maintenance.sh --deep     # also re-downloadable: huggingface, playwright/puppeteer/selenium
#   ./maintenance.sh --dry-run  # show what would run, change nothing
set -uo pipefail

DEEP=0; DRY=0
for a in "$@"; do case "$a" in
  --deep) DEEP=1 ;;
  -n|--dry-run) DRY=1 ;;
  -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
  *) echo "unknown arg: $a"; exit 1 ;;
esac; done

free() { df -h / | awk 'NR==2{print $4}'; }
sz()   { [ -e "$1" ] && du -sh "$1" 2>/dev/null | cut -f1 || echo "0B"; }
step() { printf '▸ %s\n' "$1"; }
run()  { if [ "$DRY" = 1 ]; then printf '    [dry] %s\n' "$*"; else eval "$@" >/dev/null 2>&1 || true; fi; }

echo "Disk free before: $(free)"

# --- safe tier: caches that refill automatically at low cost ---
command -v npm  >/dev/null && { step "npm cache";       run "npm cache clean --force"; }
command -v uv   >/dev/null && { step "uv cache prune";  run "uv cache prune"; }
command -v bun  >/dev/null && { step "bun cache";       run "bun pm cache rm"; }
command -v brew >/dev/null && { step "brew cleanup";    run "brew cleanup -s"; run "brew autoremove"; }
command -v pod  >/dev/null && { step "cocoapods cache"; run "pod cache clean --all"; }

# brew cleanup prunes old versioned kegs; if a dependency was upgraded but its
# dependent wasn't rebuilt, that dependent now points at a deleted .dylib and will
# abort with a dyld error (e.g. node vs llhttp). Surface it instead of finding out later.
if command -v brew >/dev/null; then
  step "brew linkage check"
  broken=$(brew linkage --test $(brew leaves) 2>/dev/null | grep -iE "missing|broken" || true)
  [ -n "$broken" ] && printf '    ⚠ broken linkage — reinstall the affected formula(e):\n%s\n' "$broken"
fi

# --- deep tier: bigger caches that RE-DOWNLOAD on next use ---
if [ "$DEEP" = 1 ]; then
  echo "-- deep (re-downloads on next use) --"
  step "HuggingFace models ($(sz ~/.cache/huggingface))";          run "rm -rf ~/.cache/huggingface"
  step "Playwright browsers ($(sz ~/Library/Caches/ms-playwright))"; run "rm -rf ~/Library/Caches/ms-playwright"
  step "Puppeteer browsers ($(sz ~/.cache/puppeteer))";            run "rm -rf ~/.cache/puppeteer"
  step "Selenium browsers ($(sz ~/.cache/selenium))";              run "rm -rf ~/.cache/selenium"
fi

echo "Disk free after:  $(free)"
