#!/bin/bash

# Microsoft Teams
count_teams_client_ref=$(hyprctl clients | grep -cP 'Microsoft Teams')

if [ $count_teams_client_ref -gt 0 ]; then
  hyprctl dispatch 'focuswindow title:^(Microsoft Teams.*)$'
  hyprctl dispatch sendshortcut CTRL_SHIFT,m, 'title:^(Microsoft Teams.*)$'
fi

# Slack
count_slack_client_ref=$(hyprctl clients | grep -cP 'Slack')


if [ $count_teams_client_ref -gt 0 ]; then
  hyprctl dispatch sendshortcut CTRL_SHIFT,SPACE, 'class:com.slack.Slack'
fi
