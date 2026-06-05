#!/bin/bash

source "$CONFIG_DIR/colors.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ -z "$PERCENTAGE" ]; then
  exit 0
fi

case ${PERCENTAGE} in
9[0-9] | 100)
  ICON="􀛨"
  COLOR=$BATTERY_OK
  ;;
[6-8][0-9])
  ICON="􀺸"
  COLOR=$BATTERY_OK
  ;;
[3-5][0-9])
  ICON="􀺶"
  COLOR=$BATTERY_WARN
  ;;
[1-2][0-9])
  ICON="􀛩"
  COLOR=$BATTERY_LOW
  ;;
*)
  ICON="􀛪"
  COLOR=$BATTERY_CRITICAL
  ;;
esac

if [[ $CHARGING != "" ]]; then
  ICON="􀢋"
  COLOR=$BATTERY_CHARGING
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%" icon.color="$COLOR"
