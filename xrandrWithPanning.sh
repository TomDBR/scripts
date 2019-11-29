#!/bin/bash

xrandr --output LVDS-1 --rate 60.04 --mode 1920x1080 --panning 2560x1080* --output HDMI-1 --mode 2560x1080 --same-as LVDS-1

Seems to be a bug actually getting out of this mode-- 

	xrandr --output $external --primary 

followed by 

	xrandr --output $internal --primary 

solved this for me (suggested here) – blast_hardcheese Dec 2 '15 at 20:15

