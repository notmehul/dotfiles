#!/bin/bash

sketchybar --add item wifi right \
  --set wifi \
  icon="􀙥" \
  update_freq=120 \
  script="$PLUGIN_DIR/wifi.sh" \
  --subscribe wifi wifi_change system_woke
