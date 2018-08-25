#!/usr/bin/env bash

if [ -d ~/.bash_it ] 
  then
    echo "~/.bash_it directory already exists. Maybe it's already installed. If it's not, remove that folder."
    exit 0
fi

if ! [ -x "$(which git)" ]
  then
    echo "Git is not installed. Please install it before run this script."
    exit 2
fi

git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it

sh /.bash_it/install.sh --silent
