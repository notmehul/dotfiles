#!/bin/bash

VOLUME=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
VOLUME="${VOLUME:-0}"

case "$VOLUME" in
  [6-9][0-9] | 100) ICON="􀊩" ;;
  [3-5][0-9]) ICON="􀊥" ;;
  [1-9] | [1-2][0-9]) ICON="􀊡" ;;
  *) ICON="􀊣" ;;
esac

sketchybar --add item volume right \
  --set volume \
  icon="$ICON" \
  label="${VOLUME}%" \
  script="$PLUGIN_DIR/volume.sh" \
  --subscribe volume volume_change
