if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set $NAME label="$ICON" icon.background.image="app.$ICON"
fi

case $INFO in
  "Brave Browser")
    ICON=󰊯
    ;;
  "Code")
    ICON=󰨞
    ;;
  "Calendar")
    ICON=󰃭
    ;;
  "Safari")
    ICON=􀎬
    ;;
  "Spotify")
    ICON=󰓇
    ;;
  "Finder")
    ICON=󰀶
    ;;
  "Firefox")
    ICON=󰈹
    ;;
  "IINA")
    ICON=󰕼
    ;;
  "kitty")
    ICON=󰄛
    ;;
  "Messages")
    ICON=󰍦
    ;;
  "Notion")
    ICON=󰴓
    ;;
  "Notes")
    ICON=󰴓
    ;;
  "Preview")
    ICON=󰋲
    ;;
  "TextEdit")
    ICON=󰅨
    ;;
  "Transmission")
    ICON=󰶘
    ;;
  "Slack")
    ICON=󰒱
    ;;
  "Weather")
    ICON=󰖕
    ;;
  "Photo Booth")
    ICON=󰄀
    ;;
  "Facetime")
    ICON=󰍫
    ;;
  *)
    ICON=󰧱
    ;;
esac

sketchybar --set $NAME \
icon=$ICON
