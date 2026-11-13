#!/bin/bash
source "$CONFIG_DIR/colors.sh"; source "$CONFIG_DIR/icons.sh"
if [ -n "$(ipconfig getifaddr en0 2>/dev/null)" ]; then
  sketchybar --set "$NAME" icon="$ICON_WIFI" icon.color=$FG
else
  sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" icon.color=$FG_DIM
fi
