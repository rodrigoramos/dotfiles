#!/bin/bash

while [ : ] 
do
  wget -O /tmp/wallpaper-remoto.jpg https://unsplash.it/2560/1440/?random
  gsettings set org.gnome.desktop.background picture-uri file:///tmp/wallpaper-remoto.jpg

  file=$(ls ~/Imagens/wallpapers | sort -R | tail -1)
  cp ~/Imagens/wallpapers/$file /tmp/wallpaper-local

  /usr/bin/feh --no-fehbg --bg-scale /tmp/wallpaper-remoto.jpg /tmp/wallpaper-local
  
  sleep 10m
done
