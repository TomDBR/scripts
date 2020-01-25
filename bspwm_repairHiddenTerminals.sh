#!/bin/bash
declare -a missingWindows=( "files" "scratch" "desktop" "trackma" )
declare -a xArgSizes=( 700 900 700 400 )
declare -a yArgSizes=( 500 500 400 500 )

# determine which windows are missing
for identifier in $(xdo id -N URxvt -d | xargs -n1 bspc query -T -n | jq '.client.instanceName' | tr -d "\"")
do
	for i in "${!missingWindows[@]}"; do
		[[ "${missingWindows[i]}" == "$identifier" ]] && unset 'missingWindows[i]' && unset 'xArgSizes[i]' && unset 'yArgSizes[i]'
	done
done
declare -p missingWindows xArgSizes yArgSizes

#recreate missing windows
let width=(1920 / 2)
let height=(1080 / 2)

for i in "${!missingWindows[@]}"
do
	window="${missingWindows[i]}"
	x="${xArgSizes[i]}"
	y="${yArgSizes[i]}"
	diffX=$(( $width - ($x / 2) ))
	diffY=$(( $height - ($y / 2) ))
	if ! $(bspc rule -l | grep "URxvt:$window" &>/dev/null); then
		bspc rule -a URxvt:$window state=floating sticky=on rectangle=${x}x${y}+${diffX}+${diffY}
	fi
	urxvtc -name "$window" -e bash -c "scratch $window"
	xdo hide -N URxvt -n $window -m 
done
