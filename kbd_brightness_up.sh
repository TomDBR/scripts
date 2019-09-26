#!/bin/bash

CURRENT_BRIGHTNESS=`cat /sys/class/leds/asus::kbd_backlight/brightness`
MAX_BRIGHTNESS=`cat /sys/class/leds/asus::kbd_backlight/max_brightness`
let CURRENT_BRIGHTNESS+=1

if [ $CURRENT_BRIGHTNESS -gt $MAX_BRIGHTNESS ]; then
	echo $MAX_BRIGHTNESS > /sys/class/leds/asus::kbd_backlight/brightness
else
	echo $CURRENT_BRIGHTNESS > /sys/class/leds/asus::kbd_backlight/brightness
fi

