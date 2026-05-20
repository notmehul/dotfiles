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
    background.color=$TRANSPARENT \
    label.color=$ACCENT_COLOR \
    icon.color=$ACCENT_COLOR \
    display=$display \
    label.font="sketchybar-app-font:Regular:12.0" \
    icon.font="SF Pro:Semibold:12.0" \
    label.padding_right=10 \
    label.y_offset=-1 \
    click_script="$PLUGIN_DIR/space_click.sh $sid"

  icon_strip=$(yabai -m query --windows --space $sid | jq -r '.[] | select(.["is-minimized"] == false and .["is-hidden"] == false) | .app' | awk '!seen[$0]++' | while read -r app; do
    printf " %s" "$($PLUGIN_DIR/icons.sh "$app")"
  done)

  sketchybar --set space.$sid label="${icon_strip:-}"
done

# Reorder bar items to match yabai's current space order
prev="yabai_dummy"
for sid in $(echo "$spaces_info" | jq -r 'sort_by(.index) | .[].index'); do
  sketchybar --move space.$sid after $prev
  prev="space.$sid"
done

# Highlight focused space
focused_space=$(echo "$spaces_info" | jq -r '.[] | select(.["has-focus"] == true) | .index')
if [ -n "$focused_space" ]; then
  sketchybar --set space.$focused_space background.drawing=on \
    background.color=$ACCENT_COLOR \
    label.color=$ITEM_COLOR \
    icon.color=$ITEM_COLOR
fi

# Save initial space IDs so the plugin can diff on space_change
echo "$spaces_info" | jq -r '.[].index' | sort -n > "$SPACE_CACHE"
