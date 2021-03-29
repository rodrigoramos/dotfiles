#!/bin/bash

while [ : ] 
do
  # wget -O /tmp/wallpaper-remoto.jpg https://picsum.photos/3840/2160?random

  #file=$(ls ~/Imagens/wallpapers | sort -R | tail -1)
  #cp ~/Imagens/wallpapers/$file /tmp/wallpaper-local


  # Unsplash
  wallpaper_url=$(curl https://api.unsplash.com/photos/random?client_id=$UNSPLASH_CLIENT_ID\&orientation=landscape | jq '.urls.raw' | tr -d '"')
  wallpaper_url=$wallpaper_url\&w=3840\&h=2160\&fit=fill\&fill=blur

  wget -O /tmp/wallpaper-remoto.jpg $wallpaper_url

  killall swaybg
  swaybg -m fit -i /tmp/wallpaper-remoto.jpg &
  
  sleep 10m
 done
