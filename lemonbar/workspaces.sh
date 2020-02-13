#!/bin/bash

workspaces() {
	wtext=('%{F#174652}' '%{F#174652}' '%{F#174652}' '%{F#174652}' '%{F#174652}' '%{F#174652}' '%{F#174652}' '%{F#174652}' '%{F#174652}' '%{F#174652}') 
	wjson=$(jshon -a -j)
	for w in $wjson; do
		vars=($(echo $w | jshon -e num -u -p -e urgent -u -p -e focused -u -p -e visible -u))
		num=$((${vars[0]} - 1))
		if [[ ${vars[1]} == 'true' ]]; then
			wtext[$num]='%{B#cb4b16}%{F#002b36}'
		elif [[ ${vars[2]} == 'true' ]]; then
			wtext[$num]='%{B#859900}%{F#002b36}'
		elif [[ ${vars[3]} == 'true' ]]; then
			wtext[$num]='%{B#268bd2}%{F#002b36}'
		else
			wtext[$num]='%{F-}'
		fi
	done

	num=1
	for w in ${wtext[@]}; do
		#echo -n "$w%{A:s$num:}%{A3:m$num:}  %{A}%{A}%{B-}"
		echo -n "$w 1 %{B-}"
		num=$(($num + 1))
	done
  #echo %{B#859900}%{F#002b36}Rodrigo %{B-}%{F-}
}

# read /tmp/i3mode-$DISPLAY
modedisplay() {
	m=$(cat /tmp/i3mode-$DISPLAY)
	[[ $m == default ]] && return
	echo -n "%{B#859900}%{F#002b36} $m mode %{B-}%{F-}"
}

(i3-msg -t get_workspaces | workspaces)
