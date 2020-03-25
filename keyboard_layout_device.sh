#!/bin/bash

deviceName="AKKO 3068BT-1 Keyboard"
deviceInputId=$(xinput -list | grep -oP "(?<=$deviceName\s{$[41 - ${#deviceName}]}id=)[0-9]{1,2}")

setxkbmap -device $deviceInputId -layout us_intl
