#!/bin/bash
source "$CONFIG_DIR/colors.sh"; source "$CONFIG_DIR/icons.sh"
ncpu=$(sysctl -n hw.logicalcpu)
pct=$(ps -A -o %cpu | awk -v n="$ncpu" 'NR>1 {s+=$1} END {printf "%d", s/n}')
[ "$pct" -gt 100 ] && pct=100
color=$FG; [ "$pct" -ge 90 ] && color=$ORANGE
sketchybar --set "$NAME" icon="$ICON_CPU" icon.color=$color label="${pct}%" label.color=$color
