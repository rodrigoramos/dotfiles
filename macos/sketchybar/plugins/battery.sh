#!/bin/bash
source "$CONFIG_DIR/colors.sh"; source "$CONFIG_DIR/icons.sh"
batt=$(pmset -g batt)
pct=$(echo "$batt" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
[ -z "$pct" ] && { sketchybar --set "$NAME" drawing=off; exit 0; }
if echo "$batt" | grep -q "AC Power"; then
  icon=$ICON_BAT_CHARGING
else
  case $((pct / 10)) in
    10) icon=$ICON_BAT_100;; 9) icon=$ICON_BAT_90;; 8) icon=$ICON_BAT_80;; 7) icon=$ICON_BAT_70;;
    6) icon=$ICON_BAT_60;; 5) icon=$ICON_BAT_50;; 4) icon=$ICON_BAT_40;; 3) icon=$ICON_BAT_30;;
    2) icon=$ICON_BAT_20;; *) icon=$ICON_BAT_10;;
  esac
fi
color=$FG; [ "$pct" -le 15 ] && color=$ORANGE
sketchybar --set "$NAME" drawing=on icon="$icon" icon.color=$color label="${pct}%" label.color=$color
