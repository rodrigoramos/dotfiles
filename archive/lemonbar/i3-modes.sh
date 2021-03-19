#!/bin/bash

handleMode () {
  mode=$(jshon -e change -u -d)

  if [ "$mode" == "default" ]; then
    echo ""
  else
    echo "%{B#fff}%{F#000} $mode %{F-}%{B-}"
  fi
}

(i3-msg -t subscribe -m '[ "mode" ]' | while read line ; do echo "$line" | handleMode; done)

