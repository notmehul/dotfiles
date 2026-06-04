#!/bin/bash

export TRANSPARENT=0x00000000

# === The Dark Side — unified system palette ===

# Base
export FG=0xffffffff          # primary text/icon
export FG_DIM=0xff7f848e      # dimmed text (comment gray from The Dark Side)

# Accent colors extracted from The Dark Side syntax theme
export C_PURPLE=0xff7725EE    # keywords / operators
export C_ORANGE=0xffff6700    # conditionals
export C_AMBER=0xffe1ab32     # strings
export C_CRIMSON=0xffDC143C   # errors / constants
export C_PINK=0xffEA76CB      # escapes / special
export C_LAVENDER=0xff9a77cf  # types
export C_BLUE=0xff1e66f5      # ansi blue
export C_GREEN=0xff40a02b     # ansi green

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
export BATTERY_OK=$FG             # >50% or charging
export BATTERY_WARN=$C_ORANGE     # 30–50%
export BATTERY_LOW=$C_AMBER       # 10–29%
export BATTERY_CRITICAL=$C_CRIMSON  # <10%

# Resource graph
export GRAPH_COLOR=$C_BLUE
export GRAPH_FILL_COLOR=0x331e66f5

# Item pill background (subtle white on dark bar)
export PILL_BG=0x20ffffff

# Legacy variable names — kept for compatibility with existing item configs
export ITEM_COLOR=$FG
export ACCENT_COLOR=$PILL_BG
