#!/bin/bash

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  isMainSessionAttached=$(tmux list-sessions | grep -oP "main: .*[(attached)]$")
  if [ -z "$isMainSessionAttached" ]; then
    exec tmux new-session -A -s main
  else
    detachedSessionId=$(tmux list-sessions | grep -oPm 1 "([0-9]+?)(?=: .+[^(attached)]$)")
    if [ -n "$detachedSessionId" ]; then
      exec tmux new-session -A -s $detachedSessionId
    else
      exec tmux new-session
    fi
  fi
fi

