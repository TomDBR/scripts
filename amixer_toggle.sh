#!/bin/bash

CURRENT_STATE=`amixer get Master | egrep 'Playback.*?\[o' | egrep -o '\[o.+\]'`
HEADPHONE_STATE=`amixer get Headphone | egrep 'Playback.*?\[o' | egrep -o '\[.+%\]' | egrep -o '[0-100]' | egrep -m 1 '[0-100]'`
SPEAKER_STATE=`amixer get Speaker | egrep 'Playback.*?\[o' | egrep -o '\[.+%\]' | egrep -o '[0-100]' | egrep -m 1 '[0-100]'`

if [[ $CURRENT_STATE == '[on]' ]]; then
    amixer set Master mute
else
    if [[ $HEADPHONE_STATE == 0 ]]; then
	amixer set Master unmute
	amixer set Speaker unmute
	amixer set 'Bass Speaker' unmute
    elif [[ $SPEAKER_STATE == 0 ]]; then
	amixer set Master unmute
	amixer set Headphone unmute
    else
        amixer set Master unmute
	amixer set Headphone unmute
	amixer set Speaker unmute
    fi	   
fi
