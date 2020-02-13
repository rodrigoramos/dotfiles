run() {
  wjson=$(jshon -a -j)

  for a in $wjson; do
    number=$(echo $a | jshon -e num)
    name=$(echo $a | jshon -e name -u)
    focused=$(echo $a | jshon -e focused)
    joutput=$(echo $a | jshon -e output -u)

    if $focused; then
      if [ "$output" == "$joutput" ]; then
        echo -n "%{B#eee}%{F#000}%{+u}"
      else
        echo -n "%{B#999}%{F#fff}%{+u}"
      fi
    else  
      echo -n %{B F}
    fi

    echo -n " $name %{B- F-}"

    if $focused; then
      echo -n %{-u}
    fi
  done
}

(i3-msg -t get_workspaces | run)

