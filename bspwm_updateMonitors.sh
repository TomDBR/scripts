#!/bin/bash
# TODO: allow choice of primary monitor
# TODO: custom monitor position
workspaceNames="I II III IV V VI VII VIII IX X" # needs to be separated by spaces!
wspaceNameArr=( $(echo $workspaceNames | tr " " "\n") )
cmd="xrandr"
declare -A monitor_status
declare -A monitor_settings
monitor_settings['LVDS-1']="--output LVDS-1 --mode 1920x1080 --pos 2560x0 --rotate normal" #main monitor, settings can be hardcoded

function querySettings() {
	xD="$1"
	mode="$(xrandr --query | awk "/$xD/{p=1;next;print} p&&/^[^ ]/{p=0};p" | sed 's/ *//' | cut -d" " -f1 | rofi -dmenu)"
	monitor_settings["$xD"]="--output "$xD" --primary --mode "$mode" --pos 0x0 --rotate normal"
}

while read status; do
	monitor_status[$(echo $status | cut -d" " -f1)]=$(echo $status | cut -d" " -f2)
done < <(xrandr | grep connected | cut -d" " -f1,2)

opt_monitor=""
opt_settings=""
while getopts "m:s:" opt; do
	case "$opt" in
		m)
			for i in "${!monitor_status[@]}"; do
    			if [ "$i" == "$OPTARG" ] ; then
					if [[ -n "$opt_settings" ]]; then
						monitor_settings[$OPTARG]="--output $OPTARG $opt_settings"
						opt_settings=""
					else
        				opt_monitor="$OPTARG"
					fi
    			fi
			done ;;
		s)
			if [[ -n "$opt_monitor" ]]; then
				monitor_settings[$opt_monitor]="--output $opt_monitor $OPTARG"
				opt_monitor=""; 
			else
				opt_settings="$OPTARG"
			fi
			;;
		*)
			echo "Invalid option!" ;;
	esac
done

[[ -n $opt_monitor || -n $opt_settings ]] && echo "Invalid combination of arguments!" && exit

for monitor in "${!monitor_status[@]}"; do
	case ${monitor_status["$monitor"]} in
		"connected")
			[[ -n ${monitor_settings["$monitor"]} ]] || querySettings "$monitor" 
			;;
		"disconnected")
			monitor_settings["$monitor"]="--output $monitor --off"
			[[ $(bspc query -M --names | grep -q "$monitor") ]] && bspc monitor "$monitor" -r
			;;
	esac
done

for xrandr_setting in "${monitor_settings[@]}"; do
	cmd="$cmd $xrandr_setting"
done

echo "xrandr cmd is: $cmd"
$cmd
wspacePerMon=$(( ${#wspaceNameArr[@]} / ${#monitor_status[@]} )) # no idea what happens if this is a floating point ;3

let iter=0
for monitor in "${!monitor_status[@]}"; do
	[[ ${monitor_status["$monitor"]} == "disconnected" ]] && continue
	if (( iter == 0 )); then
		wspaces="$(echo $workspaceNames | cut -d" " -f$(seq -s , $(( (iter+1) * $wspacePerMon)) ))"
	else
		wspaces="$(echo $workspaceNames | cut -d" " -f$(seq -s , $((iter * $wspacePerMon )) $(( (iter+1) * $wspacePerMon)) ))"
	fi
	bspc monitor "$monitor" -d $wspaces # quoting wspaces will make one workspace with a long name instead of separate ones
	(( iter++ ))
done

pkill bar;  nohup bar &>/home/Tom/bar &
