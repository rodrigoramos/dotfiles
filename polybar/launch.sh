#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Extract Wallpaper main color
export WALLPAPER_MAIN_COLOR=$(convert /tmp/wallpaper-remoto.jpg +dither -colors 3 -define histogram:unique-colors=true -format "%c" histogram:info: \
 | grep -o -E -m 2 "#[^\s]*" \
 | tail -n 1)                                                                                   

echo "Wallpaper main color is $WALLPAPER_MAIN_COLOR"

echo "---" | tee -a /tmp/polybar-botttom.log 

#if type "xrandr"; then
  #for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #echo Lauching for $m
    #MONITOR=$m polybar bottom --reload >>/tmp/polybar-bottom-$m.log 2>&1 &
    #sleep 1s
  #done
#else
  polybar bottom --reload >>/tmp/polybar-bottom.log 2>&1 &
#fi

echo "Bars launched..."
