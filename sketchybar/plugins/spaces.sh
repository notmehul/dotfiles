#!/bin/sh

source "$CONFIG_DIR/colors.sh"

SPACE_CACHE="$HOME/.cache/sketchybar/space_ids"

add_space_item() {
  sid=$1
  display=$2

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
    click_script="$CONFIG_DIR/plugins/space_click.sh $sid"
}

# Updates a space's app icons and category color.
# The space NUMBER stays white in every state (it's a non-app status glyph); the app
# strip carries the category color. Focus is shown by the pill background toggling.
update_space() {
  sid=$1
  is_focused=$2

  windows=$(yabai -m query --windows --space $sid 2>/dev/null)
  # The Codex dictation overlay is sticky, so it lands in every space's window
  # query and would otherwise paint its icon on every space's strip. Exclude it
  # by title; the real Codex window (title "Codex") is unaffected.
  visible='select(.["is-minimized"] == false and .["is-hidden"] == false and (.app != "Codex" or .title != "Dictation"))'
  first_app=$(echo "$windows" | jq -r "[.[] | $visible] | .[0].app // \"\"")
  space_color=$([ -n "$first_app" ] && "$CONFIG_DIR/plugins/app_color.sh" "$first_app" || echo "$FG_DIM")

  icon_strip=$(echo "$windows" | jq -r ".[] | $visible | .app" | awk '!seen[$0]++' | head -5 | while read -r app; do
    printf " %s" "$($CONFIG_DIR/plugins/icons.sh "$app")"
  done)

  if [ "$is_focused" = "true" ]; then
    sketchybar --set space.$sid \
      background.drawing=on \
      label="${icon_strip:-}" \
      label.color="$space_color" \
      icon.color=$FG_TEXT
  else
    sketchybar --set space.$sid \
      background.drawing=off \
      label="${icon_strip:-}" \
      label.color="$space_color" \
      icon.color=$FG_TEXT
  fi
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

# Update each space's display, icons, and category color in one pass
focused_space=$(echo "$spaces_info" | jq -r '.[] | select(.["has-focus"] == true) | .index')
for sid in $current_ids; do
  display=$(echo "$spaces_info" | jq -r ".[] | select(.index == $sid) | .display")
  sketchybar --set space.$sid display=$display
  is_focused="false"
  [ "$sid" = "$focused_space" ] && is_focused="true"
  update_space "$sid" "$is_focused"
done
