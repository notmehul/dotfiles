#!/bin/bash

sketchybar --add item media e \
  --set media label.color=$CAT_MEDIA \
  label.max_chars=20 \
  icon.padding_left=0 \
  scroll_texts=on \
  icon=􀑪 \
  icon.color=$CAT_MEDIA \
  background.drawing=off \
  script="$PLUGIN_DIR/media.sh" \
  --subscribe media media_change
