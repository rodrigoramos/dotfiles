run() {
  wjson=$(jshon -a -j)

  for a in $wjson; do
    joutput=$(echo $a | jshon -e output -u)

    if [ "$output" != "$joutput" ]; then
      continue 
    fi

    parsed=($(echo $a | jshon -e name -u -p -e focused -u -p -e urgent -u -p -e visible -u))

    number=${parsed[0]:0:1}
    focused=${parsed[1]}
    urgent=${parsed[2]}
    visible=${parsed[3]}

    if $urgent; then
        echo -n "%{B#c00}%{F#fff}"
    elif $focused; then
        echo -n "%{B#eee}%{F#000}%{+u}"
    elif $visible; then
        echo -n "%{B#999}%{F#fff}%{+u}"
    else  
        echo -n %{B F}
    fi

    echo -n " $number %{B- F-}"

    if $focused || $visible; then
      echo -n %{-u}
    fi
  done
}

(i3-msg -t get_workspaces | run)

