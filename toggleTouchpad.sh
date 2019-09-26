#!/bin/bash
status=$(xinput list-props 14 | grep "Device Enabled" | grep -oE "[0-9]$")
if [ "$status" = 0 ]; then
	xinput set-prop 14 142 1
else
	xinput set-prop 14 142 0
fi
