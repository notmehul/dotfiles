#!/bin/bash

USAGE_PCT=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf("%02.0f", 100-$5) }')
USAGE_FRAC=$(echo "$USAGE_PCT" | awk '{ printf("%.2f", $1/100) }')

sketchybar --add graph memory right 50 \
  --set memory \
  graph.color=$GRAPH_COLOR \
  graph.fill_color=$GRAPH_FILL_COLOR \
  graph.line_width=1.5 \
  update_freq=30 \
  icon=􀧖 \
  label="${USAGE_PCT}%" \
  label.font="SF Pro Display:Semibold:9.0" \
  script="$PLUGIN_DIR/memory.sh"

sketchybar --push memory $USAGE_FRAC
