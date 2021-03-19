#!/bin/bash
id=$(pacmd list-sinks | grep -oP "(?<=[^\*] index:) \d")

pacmd set-default-sink $id

# Switch streams already opened
for s in $(pacmd list-sink-inputs | grep -oP "(?<=index: )\d*")
do
  pacmd move-sink-input $s $id
done

