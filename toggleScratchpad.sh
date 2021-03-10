#!/bin/bash

instance="$@"
id="$(xdo id -N URxvt -n $instance)"
coords="$(bspc query -T -n "$id" | jq -c .client.floatingRectangle)"
if [[ -n "$coords" ]]; then # if -n (empty string) this means window was hidden, and geom won't be changed, so no need to check
	geom="$(echo "$coords" | sed -E 's/\{"x":([0-9-]+),"y":([0-9-]+),"width":([0-9-]+),"height":([0-9-]+)\}/\3x\4+\1+\2/')"
	echo "$geom"
	bspc rule -r URxvt:"$instance"
	bspc rule -a URxvt:"$instance" state=floating sticky=on rectangle="$geom"
fi
xdo toggle "$id"


