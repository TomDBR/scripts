#!/bin/bash

direction="$1"

jsonVals=( $(bspc query -T -n '@parent' | jq -r .splitType,.firstChild.id,.secondChild.id) )
splitType="${jsonVals[0]}"
childOne="${jsonVals[1]}"
childTwo="${jsonVals[2]}"
focusedChild="$(bspc query -N -n)"

case "$splitType" in 
	"vertical")
		if [[ "$direction" == "down" || "$direction" == "up" ]]; then exit 1; fi
		case "$direction" in
			"left")
				# move splitLine to left
				if [[ "$(bspc query -N -n $childOne)" == "$focusedChild" ]]
				then
					bspc node -z right -20 0
				else
					bspc node -z left -20 0
				fi
				;;
			"right")
				# move splitLine to right
				if [[ "$(bspc query -N -n $childOne)" == "$focusedChild" ]]; then
					bspc node -z right 20 0
				else
					bspc node -z left 20 0
				fi
				;;
		esac
		;;
	"horizontal")
		if [[ "$direction" == "left" || "$direction" == "right" ]]; then exit 1; fi
		case "$direction" in
			"down")
				# move splitLine down
				if [[ "$(bspc query -N -n $childOne)" == "$focusedChild" ]]
				then
					bspc node -z bottom 0 20 
				else
					bspc node -z top 0 20 
				fi
				;;
			"up")
				# move splitLine up
				if [[ "$(bspc query -N -n $childOne)" == "$focusedChild" ]]
				then
					bspc node -z bottom 0 -20 
				else
					bspc node -z top 0 -20 
				fi
				;;
		esac
		;;
esac
