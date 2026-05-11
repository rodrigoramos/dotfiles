#!/bin/bash

DISPLAY=:0
device_id=$(xinput list --id-only 'keyboard:Keychron K6')
setxkbmap -device $device_id -layout "us_custom" -option caps:escape_shifted_capslock
