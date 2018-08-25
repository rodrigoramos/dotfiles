#!/usr/bin/env bash

if [ -d ~/.powerline-fonts ] 
  then
    echo "~/.powerline-fonts directory already exists. Maybe it's already installed. If it's not, remove that folder."
    exit 
fi

if ! [ -x "$(which git)" ]
  then
    echo "Git is not installed. Please install it before run this script."
    exit 2
fi

# clone
git clone --depth=1 https://github.com/powerline/fonts.git ~/.powerline-fonts 

# install
sh ~/.powerline-fonts/install.sh
