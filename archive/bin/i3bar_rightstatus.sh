#!/bin/bash

outputsConnected=($(xrandr -q | awk '$2 == "connected" { print $1 }'))

if [ "${#outputsConnected[@]}" -eq "1" ]; then
  date +%T
fi 

