#!/bin/bash

echo $(setxkbmap -query | grep us)
if [ "$(setxkbmap -query | grep us)" ]; then
  setxkbmap -layout br
else
  setxkbmap -layout us -variant intl
fi

xmodmap ~/.Xmodmap
