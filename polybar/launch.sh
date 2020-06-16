#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Extract Wallpaper main color
export WALLPAPER_MAIN_COLOR=$(convert /tmp/wallpaper-remoto.jpg +dither -colors 3 -define histogram:unique-colors=true -format "%c" histogram:info: \
 | grep -o -E -m 2 "#[^\s]*" \
 | tail -n 1)                                                                                   

echo "Wallpaper main color is $WALLPAPER_MAIN_COLOR"

echo "---" | tee -a /tmp/polybar-botttom.log 

outputs=($(xrandr --listactivemonitors | awk ' { print $4" "$3 } '))

export output=""
for (( i=0; i<${#outputs[@]}; i += 2))
do
  output=${outputs[i]} # Output name
  polybar bottom --reload >>/tmp/polybar-bottom.log 2>&1 &
  sleep 1s
done

echo "Bars launched..."
