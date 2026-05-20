#!/bin/sh

# Check for wired connection with valid IP (excluding WiFi interfaces)
# Get WiFi interface name from networksetup
WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

WIRED_IP=$(for iface in $(ifconfig -l | tr ' ' '\n' | grep '^en[0-9]'); do
    # Skip if this is the WiFi interface
    if [ "$iface" = "$WIFI_INTERFACE" ]; then
        continue
    fi
    # Check for active connection with valid IP
    ifconfig "$iface" 2>/dev/null | grep 'inet ' | grep -v '127.0.0.1' | head -1 | awk '{print $2}'
done | head -1)

# Get the current Wi-Fi SSID. `ipconfig getsummary` returns in ~50ms, whereas
# `system_profiler SPAirPortDataType` takes several seconds and stalls the bar.
SSID=$(ipconfig getsummary "$WIFI_INTERFACE" 2>/dev/null | awk -F ' SSID : ' '/ SSID : / {print $2; exit}')

# Determine connection status and display
if [ "$WIRED_IP" != "" ]; then
  # Wired connection is active with valid IP
  sketchybar --set $NAME icon="􀌗"
elif [ "$SSID" != "" ]; then
  # WiFi connection is active
  sketchybar --set $NAME icon="􀙇"
else
  # No connection
  sketchybar --set $NAME icon="􀙈"
fi