#!/bin/bash

USAGE_PCT=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf("%02.0f", 100-$5) }')
USAGE_FRAC=$(echo "$USAGE_PCT" | awk '{ printf("%.2f", $1/100) }')

sketchybar --push $NAME $USAGE_FRAC
sketchybar --set $NAME label="${USAGE_PCT}%"
