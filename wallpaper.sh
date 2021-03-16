#!/bin/bash

while [ : ] 
do
  
# https://unsplash.it/3840/2160/?random
  wget -O /tmp/wallpaper-remoto.jpg https://picsum.photos/3840/2160?random

  #file=$(ls ~/Imagens/wallpapers | sort -R | tail -1)
  #cp ~/Imagens/wallpapers/$file /tmp/wallpaper-local

  killall swaybg
  swaybg -m fit -i /tmp/wallpaper-remoto.jpg &
  
  sleep 10m
done
