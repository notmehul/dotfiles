#!/bin/bash

SPACE_CACHE="$HOME/.cache/sketchybar/space_ids"
mkdir -p "$(dirname "$SPACE_CACHE")"

sketchybar --add event space_change
sketchybar --add event window_change

sketchybar --add item yabai_dummy left \
  --set yabai_dummy display=0 \
  script="$PLUGIN_DIR/spaces.sh" \
  --subscribe yabai_dummy space_change window_change

# Single query for all spaces at init (skip if yabai is unavailable)
spaces_info=$(yabai -m query --spaces 2>/dev/null) || exit 0
if [ -z "$spaces_info" ] || [ "$spaces_info" = "null" ]; then exit 0; fi

for sid in $(echo "$spaces_info" | jq -r 'sort_by(.index) | .[].index'); do
  display=$(echo "$spaces_info" | jq -r ".[] | select(.index == $sid) | .display")

  sketchybar --add space space.$sid left \
    --set space.$sid space=$sid \
    icon=$sid \
    background.color=$PILL_BG \
    background.drawing=off \
    background.corner_radius=10 \
    background.height=20 \
    label.color=$FG_DIM \
    icon.color=$FG_TEXT \
    display=$display \
    label.font="sketchybar-app-font:Regular:12.0" \
    icon.font="SF Pro:Semibold:12.0" \
    label.padding_right=10 \
    label.y_offset=-1 \
    click_script="$PLUGIN_DIR/space_click.sh $sid"
done

# Icon strips and category colors are populated by the plugin via the
# space_change trigger at the end of this file, so we don't compute them here.

# Reorder bar items to match yabai's current space order
prev="yabai_dummy"
for sid in $(echo "$spaces_info" | jq -r 'sort_by(.index) | .[].index'); do
  sketchybar --move space.$sid after $prev
  prev="space.$sid"
done

# Save initial space IDs so the plugin can diff on space_change
echo "$spaces_info" | jq -r '.[].index' | sort -n > "$SPACE_CACHE"

# Trigger the plugin immediately so category colors are applied at startup,
# not only after the first space/window change event
sketchybar --trigger space_change
