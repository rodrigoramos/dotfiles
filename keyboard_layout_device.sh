#!/bin/bash

getDeviceInput () {
  deviceName=$1
  deviceInputId=$(xinput -list | grep -oP "(?<=$deviceName\s{$[41 - ${#deviceName}]}id=)[0-9]{1,2}")
}

echo "Configurando device bluetooth"
getDeviceInput "AKKO 3068BT-1 Keyboard"

if [ -z $deviceInputId ]; then
  echo Não encontrado
  echo Obter conexão USB

  getDeviceInput "AKKO AKKO 3068BT"
fi

if [ -n $deviceInputId ]; then
  echo Device Encontrado Id=$deviceInputId
  echo Definindo Layout
  setxkbmap -device $deviceInputId -layout us_intl
else
  echo Não foi possível obter o device id
fi

if [ -a $HOME/.Xmodmap ]; then
  echo "ModMap"
  xmodmap $HOME/.Xmodmap
fi

notify-send "AKKO 3068BT ($deviceInputId) Configured"

