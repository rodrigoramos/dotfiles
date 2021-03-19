#!/bin/bash

default_sink_audio=$(pacmd list-sinks | grep -oP "(?<=\* index: )\d*")

if [ $1 -eq 0 ]; then
  pactl set-sink-mute $default_sink_audio toggle
else
  pactl set-sink-volume "$default_sink_audio" "$1%"
fi
