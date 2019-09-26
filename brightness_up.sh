#!/bin/bash

CURRENT_BRIGHTNESS=`cat /sys/class/backlight/intel_backlight/brightness` 
MAX_BRIGHTNESS=`cat /sys/class/backlight/intel_backlight/max_brightness` 
let CURRENT_BRIGHTNESS+=400

if [ $CURRENT_BRIGHTNESS -ge $MAX_BRIGHTNESS ]; then
	echo $MAX_BRIGHTNESS > /sys/class/backlight/intel_backlight/brightness
else
	echo $CURRENT_BRIGHTNESS > /sys/class/backlight/intel_backlight/brightness
fi

