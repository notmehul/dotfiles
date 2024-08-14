#!/bin/sh
## SCRIPT NOT FUNCTIONAL

source "$HOME/.config/icons.sh"

case "$1" in
  "Terminal" | "kitty")
    RESULT="󰆍"
    if grep -q "btop" <<< "$2"; then
      RESULT=$ICON_CHART
    elif grep -q "brew" <<< "$2"; then
      RESULT=$ICON_PACKAGE
    elif grep -q "nvim" <<< "$2"; then
      RESULT=$ICON_DEV
    elif grep -q "ranger" <<< "$2"; then
      RESULT=$ICON_FILE
    elif grep -q "lazygit" <<< "$2"; then
      RESULT=$ICON_GIT
    elif grep -q "taskwarrior-tui" <<< "$2"; then
      RESULT=$ICON_LIST
    elif grep -q "unimatrix\|pipes.sh" <<< "$2"; then
      RESULT=$ICON_SCREENSAVOR
    elif grep -q "bat" <<< "$2"; then
      RESULT=$ICON_NOTE
    elif grep -q "tty-clock" <<< "$2"; then
      RESULT=$ICON_CLOCK
    fi
    ;;
  "Finder")
    RESULT=$ICON_FILE
    ;;
  "Weather")
    RESULT=$ICON_WEATHER
    ;;
  "Clock")
    RESULT=$ICON_CLOCK
    ;;
  "Mail" | "Microsoft Outlook")
    RESULT=$ICON_MAIL
    ;;
  "Calendar")
    RESULT=$ICON_CALENDAR
    ;;
  "Calculator" | "Numi")
    RESULT=$ICON_CALC
    ;;
  "Maps" | "Find My")
    RESULT=$ICON_MAP
    ;;
  "Voice Memos")
    RESULT=$ICON_MICROPHONE
    ;;
  "Messages" | "Slack" | "Microsoft Teams" | "Discord" | "Telegram")
    RESULT=$ICON_CHAT
    ;;
  "FaceTime" | "zoom.us" | "Webex")
    RESULT=$ICON_VIDEOCHAT
    ;;
  "Notes" | "TextEdit" | "Stickies" | "Microsoft Word")
    RESULT=$ICON_NOTE
    ;;
  "Reminders" | "Microsoft OneNote")
    RESULT=$ICON_LIST
    ;;
  "Photo Booth")
    RESULT=$ICON_CAMERA
    ;;
  "Safari" | "Brave Browser" | "DuckDuckGo" | "Arc" | "Microsoft Edge" | "Google Chrome" | "Firefox")
    RESULT=$ICON_WEB
    ;;
  "System Settings" | "System Information" | "TinkerTool")
    RESULT=$ICON_COG
    ;;
  "HOME")
    RESULT=$ICON_HOMEAUTOMATION
    ;;
  "Music" | "Spotify")
    RESULT=$ICON_MUSIC
    ;;
  "Podcasts")
    RESULT=$ICON_PODCAST
    ;;
  "TV" | "QuickTime Player" | "VLC")
    RESULT=$ICON_PLAY
    ;;
  "Books")
    RESULT=$ICON_BOOK
    ;;
  "Xcode" | "Code" | "Neovide" | "IntelliJ IDEA")
    RESULT=$ICON_DEV
    ;;
  "Font Book" | "Dictionary")
    RESULT=$ICON_BOOKINFO
    ;;
  "Activity Monitor")
    RESULT=$ICON_CHART
    ;;
  "Disk Utility")
    RESULT=$ICON_DISK
    ;;
  "Screenshot" | "Preview")
    RESULT=$ICON_PREVIEW
    ;;
  "1Password")
    RESULT=$ICON_PASSKEY
    ;;
  "NordVPN")
    RESULT=$ICON_VPN
    ;;
  "Progressive Downloaded" | "Transmission")
    RESULT=$ICON_DOWNLOAD
    ;;
  "Airflow")
    RESULT=$ICON_CAST
    ;;
  "Microsoft Excel")
    RESULT=$ICON_TABLE
    ;;
  "Microsoft PowerPoint")
    RESULT=$ICON_PRESENT
    ;;
  "OneDrive")
    RESULT=$ICON_CLOUD
    ;;
  "Curve")
    RESULT=$ICON_PEN
    ;;
  "Microsoft Remote Desktop" | "VMware Fusion" | "UTM")
    RESULT=$ICON_REMOTEDESKTOP
    ;;
  *)
    RESULT="󰆍"
    ;;
esac

echo "$RESULT"
