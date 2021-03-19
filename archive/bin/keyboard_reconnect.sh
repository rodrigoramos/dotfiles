!/bin/bash

while read line; do
 if echo $line | grep -q "Connect Complete"; then
   echo "[KEYMON] Connection Detected $line"

   read line
   if echo $line | grep -q 'Status: Success'; then
     echo "[KEYMON] With Status Success $line"

     read line
     read line

     if echo $line | grep -q '50:E6:66:9C:BE:CE'; then # MAC ID AKKO 3068BT-1
       echo "[KEYMON] Keyboard found $line"
       sleep 1s
       $HOME/git/dotfiles/keyboard_layout_device.sh
      else
        echo $line
      fi
    else
      echo $line
    fi
  else
    echo $line
  fi
done
