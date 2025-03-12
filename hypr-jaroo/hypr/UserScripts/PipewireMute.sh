#!/bin/bash

sources=$(wpctl status | grep -Pzo "Audio(\n.*)*(?=Video)" | grep -Pzo "(?<=Sources:)(\n.*)*(?=Filters)")
sources_ids=$(echo $sources | grep -Po '\d{2}(?=\.)')

for id in $sources_ids
do
  wpctl set-mute $id toggle
done
