#!/bin/bash
declare -a monitors=( $(xrandr | grep 'connected' | cut -d" " -f1,2 | tr " " ":") )
declare -a connectedMonitors=( $(xrandr | grep 'connected' | cut -d" " -f1) )

workspaceNames="I II III IV V VI VII VIII IX X" # needs to be separated by spaces!
wspaceNameArr=( $(echo $workspaceNames | tr " " "\n") )
LVDS1="--output LVDS-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal" #main monitor, settings can be hardcoded
cmd="xrandr"

function querySettings() {
	xD="$1"
	mode="$(xrandr --query | awk "/$xD/{p=1;next;print} p&&/^[^ ]/{p=0};p" | sed 's/ *//' | cut -d" " -f1 | rofi -dmenu)"
	cmd="$cmd --output "$xD" --mode "$mode" --pos 1920x0 --rotate normal"
}

for monitor in "${monitors[@]}"; do
	output="$(echo $monitor | cut -d":" -f1)"
	status="$(echo $monitor | cut -d":" -f2)"
	case "$status" in
		"connected")
			echo "$output monitor is connected!"
			case "$output" in
				"LVDS-1") 
					cmd="$cmd $LVDS1"
					;;
				*)
					querySettings "$output"
					;;
			esac
			;;
		"disconnected")
			cmd="$cmd --output $output --off"
			for i in "${!connectedMonitors[@]}"; do
				[[ "${connectedMonitors[i]}" == "$output" ]] && unset 'connectedMonitors[i]'
			done
			[[ $(bspc query -M --names | grep "$output") ]] && bspc monitor "$output" -r
			;;
	esac
done

$cmd
wspacePerMon=$(( ${#wspaceNameArr[@]} / ${#connectedMonitors[@]} )) # no idea what happens if this is a floating point ;3

let iter=0
for conMon in "${connectedMonitors[@]}"; do
	if (( iter == 0 )); then
		wspaces="$(echo $workspaceNames | cut -d" " -f$(seq -s , $(( (iter+1) * $wspacePerMon)) ))"
	else
		wspaces="$(echo $workspaceNames | cut -d" " -f$(seq -s , $((iter * $wspacePerMon )) $(( (iter+1) * $wspacePerMon)) ))"
	fi
	bspc monitor "$conMon" -d $wspaces # quoting wspaces will make one workspace with a long name instead of separate ones
	(( iter++ ))
done

