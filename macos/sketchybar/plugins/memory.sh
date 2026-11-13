#!/bin/bash
source "$CONFIG_DIR/icons.sh"
free=$(memory_pressure | awk '/System-wide memory free percentage/ {gsub("%","",$5); print $5}')
used=$((100 - ${free:-0}))
sketchybar --set "$NAME" icon="$ICON_MEM" label="${used}%"
