#!/bin/bash

CURRENT_BRIGHTNESS=`cat /sys/class/backlight/intel_backlight/brightness` 
MAX_BRIGHTNESS=`cat /sys/class/backlight/intel_backlight/max_brightness` 
let CURRENT_BRIGHTNESS-=200

if [ $CURRENT_BRIGHTNESS -le  0 ]; then
	echo '100' > /sys/class/backlight/intel_backlight/brightness
else
	echo $CURRENT_BRIGHTNESS > /sys/class/backlight/intel_backlight/brightness
fi

