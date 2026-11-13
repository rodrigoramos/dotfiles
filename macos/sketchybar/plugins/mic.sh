#!/bin/bash
source "$CONFIG_DIR/colors.sh"; source "$CONFIG_DIR/icons.sh"
vol=$(osascript -e 'input volume of (get volume settings)' 2>/dev/null)
if [ "$vol" = "0" ]; then
  sketchybar --set "$NAME" icon="$ICON_MIC_OFF" icon.color=$RED
else
  sketchybar --set "$NAME" icon="$ICON_MIC" icon.color=$FG
fi
