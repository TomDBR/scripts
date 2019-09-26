#!/bin/bash
="$(bspc query -T -n)"

# origID (id of original node), origWidth (either same as parent or smaller), origHeight ( idem )
origValues=( $(bspc query -T -n | jq '.id,.rectangle.width,.rectangle.height') )
bspc node -f @parent
# parentID, parentWidth, parentHeight, childWidth, childHeight
parentValues=( $(bspc query -T -n | jq '.id,.rectangle.width,.rectangle.height,.firstChild.rectangle.width,.firstChild.rectangle.height') )
if ! [[ "${origValues[0]}" == "${parentValues[0]}" ]]; then # if origId = parentId
	parentWidth="$(echo $parentJson | jq .rectangle.width)" # eg. 1920
	parentHeight="$(echo $parentJson | jq .rectangle.height)" # eg. 1080
	firstChildWidth="$(echo $parentJson | jq .firstChild.rectangle.width)" # eg. 1920
	firstChildHeight="$(echo $parentJson | jq .firstChild.rectangle.height)" # eg. 1080
	dir="" 
	if (( ${parentValues[2]} == ${origValues[2]} )) # origHeight = parentHeight
	then 
		if (( ${parentValues[3]} == ${origValues[1]} )); then # childWidth = origWidth
			dir="south"; else dir="north"
		fi
	else 
		if (( ${parentValues[4]} == ${origValues[2]} )); then # childHeight = origHeight
			dir="east"; else dir="west"
		fi
	fi
	bspc config presel_feedback false
	bspc node -f "${origValues[0]}"
	bspc node -p "$dir"
	bspc node -f @brother
	bspc node -g marked
	bspc node newest.marked.local -n newest.!automatic.local 
	bspc config presel_feedback true
	bspc node -f "${origValues[0]}"
fi
