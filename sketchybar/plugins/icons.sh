#!/usr/bin/env bash

# Resolves an app name to its glyph. The icon map is 800+ lines, so we check the
# on-disk cache FIRST and only source/parse the map on a cache miss — most calls
# hit the cache, so they stay cheap.

CACHE_DIR="$HOME/.cache/sketchybar"
ICON_CACHE="$CACHE_DIR/icon_cache.txt"
APP_NAME="$1"

# Cache hit: return immediately, no map parsing.
CACHED_ICON=$(grep -F "$APP_NAME|" "$ICON_CACHE" 2>/dev/null | head -1 | cut -d '|' -f2)
if [ -n "$CACHED_ICON" ]; then
  echo "$CACHED_ICON"
  exit 0
fi

# Cache miss: load the map, resolve, and record for next time.
[ -f "$CONFIG_DIR/icon_map.sh" ] || { echo ""; exit 0; }
source "$CONFIG_DIR/icon_map.sh"
__icon_map "$APP_NAME"

if [ -n "$icon_result" ]; then
  mkdir -p "$CACHE_DIR"
  echo "$APP_NAME|$icon_result" >>"$ICON_CACHE"
fi

echo "$icon_result"
