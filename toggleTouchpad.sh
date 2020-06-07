#!/bin/bash
devID="$(xinput | grep -i touchpad | grep -oE 'id=[0-9]+' | cut -d"=" -f2)"
mapfile -t < <(xinput list-props "$devID" | grep -i 'device enabled' | sed -E 's/^.*\(([0-9]+)\):\t([0-9])/\1\n\2/') id_map
if [ "${id_map[1]}" -eq 0 ]; then
	xinput set-prop "$devID" "${id_map[0]}" 1
else
	xinput set-prop "$devID" "${id_map[0]}" 0
fi
