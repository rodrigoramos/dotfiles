#!/bin/bash

ms_teams_app_class=msedge-_nfecgfopkdiicnnmccikafaofaoffegm-Default
count_teams_client_ref=$(hyprctl clients | grep -cP 'Microsoft Teams')

if [ $count_teams_client_ref -gt 0 ]; then
  hyprctl dispatch focuswindow class:$ms_teams_app_class
  hyprctl dispatch sendshortcut CTRL_SHIFT,m, class:$ms_teams_app_class
fi

