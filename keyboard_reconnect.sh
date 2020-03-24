# Change <YOUR_MAC_ADDRESS> and add or remove the commands in the deepest "if" block as you like.

while read line; do
  if echo $line | grep -q 'Connect Complete'; then
    read line
    if echo $line | grep -q 'Status: Success'; then
      read line
      read line
      if echo $line | grep -q '50:E6:66:9C:BE:CE'; then # MAC ID AKKO 3068BT-1
       while :; do
          if $HOME/git/dotfiles/keyboard_layout_device.sh; then
            echo "Layout set" 
            break
          else
            echo "Layout set failed"
          fi
          sleep 1s
        done

        while :; do
          if xmodmap $HOME/.Xmodmap; then
            echo "Remapping Loaded"
            # xset r rate 170 130 # Remove this command if you don't need it.
            # And add any other commands as you like.
            break
          else
            echo "Remapping failed"
          fi
          sleep 2s
        done
      fi
    fi
  fi
done
