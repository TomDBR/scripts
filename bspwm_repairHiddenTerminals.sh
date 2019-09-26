#!/bin/bash
declare -a missingWindows=( "files" "scratch" "desktop" "trackma" )
declare -a xArgSizes=( -100 -240 -100 -10 )
declare -a yArgSizes=( 30 100 30 10 )

# determine which windows are missing
for identifier in $(bspc query -N -n '.leaf.sticky' | xargs -n1 bspc query -T -n | jq '.client.instanceName' | tr -d "\"")
do
	for i in "${!missingWindows[@]}"; do
		[[ "${missingWindows[i]}" == "$identifier" ]] && unset 'missingWindows[i]' && unset 'xArgSizes[i]' && unset 'yArgSizes[i]'
	done
done
declare -p missingWindows xArgSizes yArgSizes

#recreate missing windows
for i in "${!missingWindows[@]}"
do
	window="${missingWindows[i]}"
	x="${xArgSizes[i]}"
	y="${yArgSizes[i]}"
	urxvtc -name "$window" -e bash -c "scratch $window"
	until [[ $(sed -n '2p' /tmp/$window.scratchid) == 'Done' ]]; do sleep 0.1; done; 
	sed -i '2d' /tmp/"$window".scratchid
	bspc node "$(cat /tmp/$window.scratchid)" --flag sticky --flag hidden --state floating 
	bspc node "$(cat /tmp/$window.scratchid)" -z bottom_left $x $y
done
