#!/bin/sh

source "$CONFIG_DIR/colors.sh"

SPACE_CACHE="$HOME/.cache/sketchybar/space_ids"

add_space_item() {
  sid=$1
  display=$2

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
    click_script="$CONFIG_DIR/plugins/space_click.sh $sid"
}

update_workspace_appearance() {
  sid=$1
  is_focused=$2

  if [ "$is_focused" = "true" ]; then
    sketchybar --set space.$sid background.drawing=on \
      background.color=$ACCENT_COLOR \
      label.color=$ITEM_COLOR \
      icon.color=$ITEM_COLOR
  else
    sketchybar --set space.$sid background.drawing=off \
      label.color=$ACCENT_COLOR \
      icon.color=$ACCENT_COLOR
  fi
}

update_icons() {
  sid=$1

  icon_strip=$(yabai -m query --windows --space $sid | jq -r '.[] | select(.["is-minimized"] == false and .["is-hidden"] == false) | .app' | awk '!seen[$0]++' | head -5 | while read -r app; do
    printf " %s" "$($CONFIG_DIR/plugins/icons.sh "$app")"
  done)

  if [ -z "$icon_strip" ]; then
    icon_strip=""
  fi

  sketchybar --set space.$sid label="$icon_strip"
}

# Get all spaces info in one query (exit early if yabai is unavailable)
spaces_info=$(yabai -m query --spaces 2>/dev/null) || exit 0
if [ -z "$spaces_info" ] || [ "$spaces_info" = "null" ]; then exit 0; fi
current_ids=$(echo "$spaces_info" | jq -r '.[].index' | sort -n)
cached_ids=$(cat "$SPACE_CACHE" 2>/dev/null || echo "")

# Add items for newly created spaces
for sid in $current_ids; do
  if ! echo "$cached_ids" | grep -qx "$sid"; then
    display=$(echo "$spaces_info" | jq -r ".[] | select(.index == $sid) | .display")
    add_space_item "$sid" "$display"
  fi
done

# Remove items for destroyed spaces
if [ -n "$cached_ids" ]; then
  for sid in $cached_ids; do
    if ! echo "$current_ids" | grep -qx "$sid"; then
      sketchybar --remove space.$sid 2>/dev/null
    fi
  done
fi

# Save current state
echo "$current_ids" > "$SPACE_CACHE"

# Reorder bar items to match yabai's current space order
ordered_ids=$(echo "$spaces_info" | jq -r 'sort_by(.index) | .[].index')
prev="yabai_dummy"
for sid in $ordered_ids; do
  sketchybar --move space.$sid after $prev
  prev="space.$sid"
done

# Reset all space backgrounds
for sid in $current_ids; do
  update_workspace_appearance "$sid" "false"
done

# Update focused space
focused_space=$(echo "$spaces_info" | jq -r '.[] | select(.["has-focus"] == true) | .index')
if [ -n "$focused_space" ]; then
  update_workspace_appearance "$focused_space" "true"
fi

# Update icons for all spaces
for sid in $current_ids; do
  display=$(echo "$spaces_info" | jq -r ".[] | select(.index == $sid) | .display")
  sketchybar --set space.$sid display=$display
  update_icons "$sid"
done
