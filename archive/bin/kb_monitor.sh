#!/bin/bash

notify-send "Bluetooth Keyboard Monitor Enabled"
echo "sotero@2020" | sudo -S echo Running
sudo btmon | bash $HOME/git/dotfiles/keyboard_reconnect.sh &> /tmp/log_keyboard_reconnect
