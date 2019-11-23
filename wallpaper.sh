#!/bin/bash

while [ : ] 
do
  wget -O /tmp/wallpaper.jpg https://unsplash.it/2560/1440/?random
  gsettings set org.gnome.desktop.background picture-uri file:///tmp/wallpaper.jpg

  /usr/bin/feh --no-fehbg --bg-scale /tmp/wallpaper.jpg 
  
  sleep 10m
done
