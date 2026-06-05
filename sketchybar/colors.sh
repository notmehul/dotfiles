#!/bin/bash

export TRANSPARENT=0x00000000

# === The Dark Side — unified system palette ===
# Accents are perceptually normalized to one OKLab lightness (vivid variant: each
# hue at the max chroma it holds at that L) so every glyph on the bar reads at one
# brightness instead of the raw syntax hues' 0.52–0.77 spread.
#
# NOTE: sketchybar runs HOTTER than the rest of the config — L≈0.77 here vs L≈0.70
# in zed/cmux/starship. The bar is very translucent (0x44000000 + blur), so the
# desktop bleeds through and mutes color; the higher L makes the bar *look* as
# vivid as the more-opaque editor/terminal. Don't blindly re-sync these to the
# others — they're deliberately brighter. FG_TEXT (white) paints all non-app icons
# AND labels (clock, %); FG (gray) now only backs the battery-OK icon + legacy chrome.
# The app-category strip and the media item keep their category colors; the battery
# icon keeps its charge-state colors.

# Base
export FG=0xffb4b4b4          # battery-OK icon + legacy chrome — gray @ OKLab L≈0.77
export FG_TEXT=0xffffffff     # all non-app icons + labels (clock, %) — regular white
export FG_DIM=0xff7f848e      # dimmed text (comment gray from The Dark Side)

# Accent colors — The Dark Side hues, normalized to OKLab L≈0.77 (sketchybar-hot)
export C_PURPLE=0xffb7a5fc    # keywords / operators
export C_ORANGE=0xfffc9569    # conditionals
export C_AMBER=0xffe3aa1e     # strings
export C_CRIMSON=0xfffc9191   # errors / constants
export C_PINK=0xfffc81db      # escapes / special
export C_LAVENDER=0xffc39ffc  # types
export C_BLUE=0xff8db4fc      # blue
export C_GREEN=0xff47d61f     # green

# App category colors — one color family per type of app,
# used for space indicators in sketchybar
export CAT_DEV=$C_PURPLE          # terminals, editors, IDEs
export CAT_BROWSER=$C_BLUE        # web browsers
export CAT_AI=$C_PINK             # AI tools
export CAT_PRODUCTIVITY=$C_ORANGE # notes, calendar, tasks
export CAT_COMMS=$C_CRIMSON       # slack, discord, messages
export CAT_MEDIA=$C_AMBER         # spotify, music, video
export CAT_DESIGN=$C_LAVENDER     # figma, affinity, sketch
export CAT_SYSTEM=$FG_DIM         # finder, settings, utilities

# Battery status thresholds
export BATTERY_OK=$FG             # >50%, not charging
export BATTERY_WARN=$C_ORANGE     # 30–50%
export BATTERY_LOW=$C_AMBER       # 10–29%
export BATTERY_CRITICAL=$C_CRIMSON  # <10%
export BATTERY_CHARGING=$C_GREEN  # plugged in — full+bolt glyph, green

# Resource graph
export GRAPH_COLOR=$C_BLUE
export GRAPH_FILL_COLOR=0x338db4fc  # C_BLUE @ 20% — keep in sync with C_BLUE

# Item pill background (subtle white on dark bar)
export PILL_BG=0x20ffffff

# Legacy variable names — kept for compatibility with existing item configs
export ITEM_COLOR=$FG
export ACCENT_COLOR=$PILL_BG
