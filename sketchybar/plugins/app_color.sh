#!/bin/bash

# Returns the category color for a given app name.
# Categories are based on The Dark Side palette from colors.sh.

source "$CONFIG_DIR/colors.sh"

case "$1" in
  # Dev: terminals, editors, IDEs, dev tools
  "Alacritty"|"Android Studio"|"Arduino"|"Arduino IDE"|"Atom"|\
  "Cursor"|"DB"|"Emacs"|"Fleet"|"Ghostty"|"GoLand"|"IntelliJ IDEA"|\
  "JetBrains Toolbox"|"Jupyter"|"Kitty"|"Neovim"|"Nova"|"PhpStorm"|\
  "PyCharm"|"Rider"|"RubyMine"|"SF Symbols"|"Sublime Text"|"Terminal"|\
  "Trae"|"VSCode"|"Visual Studio Code"|"WebStorm"|"WezTerm"|"Xcode"|"Zed"|"cmux")
    echo "$CAT_DEV" ;;
  # Browsers
  "Arc"|"Brave Browser"|"Chromium"|"Dia"|"Firefox"|"Google Chrome"|\
  "Microsoft Edge"|"Opera"|"Orion"|"Safari"|"Vivaldi"|"Zen")
    echo "$CAT_BROWSER" ;;
  # AI tools
  "Antigravity"|"Claude"|"ChatGPT"|"Codex"|"GitHub Copilot"|"Perplexity")
    echo "$CAT_AI" ;;
  # Productivity
  "Bear"|"Calendar"|"Craft"|"Day One"|"Fantastical"|"Keynote"|"Linear"|\
  "Notion"|"Notes"|"Numbers"|"Obsidian"|"Pages"|"Reminders"|\
  "Things 3"|"Todoist")
    echo "$CAT_PRODUCTIVITY" ;;
  # WhatsApp — brand green. Bundle name has an invisible LTR unicode prefix,
  # so *WhatsApp matches both "WhatsApp" and "‎WhatsApp"
  *"WhatsApp")
    echo "0xff25D366" ;;
  # Communication
  "Airmail"|"Discord"|"Mail"|"Messages"|"Mimestream"|"Proton Mail"|\
  "Signal"|"Slack"|"Spark"|"Telegram")
    echo "$CAT_COMMS" ;;
  # Media
  "Audacity"|"Cap"|"FineTune"|"IINA"|"Infuse"|"Music"|"OBS"|"Photos"|\
  "Plex"|"Podcasts"|"Reeder"|"Spotify"|"VLC"|"Vinyls")
    echo "$CAT_MEDIA" ;;
  # Design
  "Affinity Designer"|"Affinity Designer 2"|"Affinity Photo"|\
  "Affinity Photo 2"|"Affinity Publisher"|"Affinity Publisher 2"|\
  "Canva"|"Figma"|"Framer"|"Pixelmator Pro"|"Sketch")
    echo "$CAT_DESIGN" ;;
  # System utilities
  "Activity Monitor"|"AlDente"|"App Store"|"BetterDisplay"|"Calculator"|\
  "Console"|"Disk Utility"|"Finder"|"Preview"|"Raycast"|"System Settings"|\
  "System Preferences"|"TextEdit")
    echo "$CAT_SYSTEM" ;;
  *)
    echo "$FG_DIM" ;;
esac
