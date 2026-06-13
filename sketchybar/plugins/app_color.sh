#!/bin/bash

# Resolves an app name to its category color (The Dark Side palette, colors.sh).
# Source this once, then call `__app_color "<app>"` — the result is left in
# $color_result. This avoids spawning a subprocess per space on every refresh.

source "$CONFIG_DIR/colors.sh"

__app_color() {
  case "$1" in
    # Dev: terminals, editors, IDEs, dev tools
    "Alacritty"|"Android Studio"|"Arduino"|"Arduino IDE"|"Atom"|\
    "Cursor"|"DB"|"Emacs"|"Fleet"|"Ghostty"|"GoLand"|"IntelliJ IDEA"|\
    "JetBrains Toolbox"|"Jupyter"|"Kitty"|"Neovim"|"Nova"|"PhpStorm"|\
    "PyCharm"|"Rider"|"RubyMine"|"SF Symbols"|"Sublime Text"|"Terminal"|\
    "Trae"|"VSCode"|"Visual Studio Code"|"WebStorm"|"WezTerm"|"Xcode"|"Zed"|"cmux")
      color_result="$CAT_DEV" ;;
    # Browsers
    "Arc"|"Brave Browser"|"Chromium"|"Dia"|"Firefox"|"Google Chrome"|\
    "Microsoft Edge"|"Opera"|"Orion"|"Safari"|"Vivaldi"|"Zen")
      color_result="$CAT_BROWSER" ;;
    # AI tools
    "Antigravity"|"Claude"|"ChatGPT"|"Codex"|"GitHub Copilot"|"Perplexity")
      color_result="$CAT_AI" ;;
    # Productivity
    "Bear"|"Calendar"|"Craft"|"Day One"|"Fantastical"|"Keynote"|"Linear"|\
    "Notion"|"Notes"|"Numbers"|"Obsidian"|"Pages"|"Reminders"|\
    "Things 3"|"Todoist")
      color_result="$CAT_PRODUCTIVITY" ;;
    # WhatsApp — brand green. Bundle name has an invisible LTR unicode prefix,
    # so *WhatsApp matches both "WhatsApp" and "‎WhatsApp"
    *"WhatsApp")
      color_result="0xff25D366" ;;
    # Communication
    "Airmail"|"Discord"|"Mail"|"Messages"|"Mimestream"|"Proton Mail"|\
    "Signal"|"Slack"|"Spark"|"Telegram")
      color_result="$CAT_COMMS" ;;
    # Media
    "Audacity"|"Cap"|"FineTune"|"IINA"|"Infuse"|"Music"|"OBS"|"Photos"|\
    "Plex"|"Podcasts"|"Reeder"|"Spotify"|"VLC"|"Vinyls")
      color_result="$CAT_MEDIA" ;;
    # Design
    "Affinity Designer"|"Affinity Designer 2"|"Affinity Photo"|\
    "Affinity Photo 2"|"Affinity Publisher"|"Affinity Publisher 2"|\
    "Canva"|"Figma"|"Framer"|"Pixelmator Pro"|"Sketch")
      color_result="$CAT_DESIGN" ;;
    # System utilities
    "Activity Monitor"|"AlDente"|"App Store"|"BetterDisplay"|"Calculator"|\
    "Console"|"Disk Utility"|"Finder"|"Preview"|"Raycast"|"System Settings"|\
    "System Preferences"|"TextEdit")
      color_result="$CAT_SYSTEM" ;;
    *)
      color_result="$FG_DIM" ;;
  esac
}
