#!/bin/bash

STATE="$(echo "$INFO" | jq -r '.state // empty')"
if [ "$STATE" = "playing" ]; then
  TITLE="$(echo "$INFO" | jq -r '.title // ""')"
  ARTIST="$(echo "$INFO" | jq -r '.artist // ""')"
  if [ -n "$TITLE" ] && [ -n "$ARTIST" ]; then
    MEDIA="$TITLE - $ARTIST"
  elif [ -n "$TITLE" ]; then
    MEDIA="$TITLE"
  else
    MEDIA="Unknown"
  fi
  sketchybar --set $NAME label="$MEDIA" drawing=on
else
  sketchybar --set $NAME drawing=off
fi
