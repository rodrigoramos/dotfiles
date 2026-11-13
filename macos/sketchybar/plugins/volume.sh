#!/bin/bash
source "$CONFIG_DIR/icons.sh"
eval "$(osascript -e 'set v to get volume settings' -e 'return "vol=" & (output volume of v) & "; muted=" & (output muted of v)' 2>/dev/null)"
vol=${vol:-0}
if [ "$muted" = "true" ] || [ "$vol" -eq 0 ]; then icon=$ICON_VOL_OFF
elif [ "$vol" -lt 34 ]; then icon=$ICON_VOL_LOW
elif [ "$vol" -lt 67 ]; then icon=$ICON_VOL_MED
else icon=$ICON_VOL_HIGH; fi
sketchybar --set "$NAME" icon="$icon" label="${vol}%"
