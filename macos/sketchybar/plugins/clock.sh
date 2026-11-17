#!/bin/bash
# Formato: "ter 17 nov 2026 10:33"
sketchybar --set "$NAME" label="$(LC_TIME=pt_BR.UTF-8 date '+%a %d %b %Y %H:%M')"
