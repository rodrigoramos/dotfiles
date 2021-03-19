#!/bin/bash

if [[ "$1" == "" ]]; then
  echo Informe o monitor
else
  xsetwacom set "Wacom One by Wacom S Pen stylus" MapToOutput $1
  xsetwacom set "Wacom One by Wacom S Pen eraser" MapToOutput $1
fi

