#!/bin/bash
# see `man 7 urxvt`
# https://emergent.unpythonic.net/01297173664 tmux related stuff

font="$(fc-list :lang=en family style | fzf)"
size="$(seq 6 2 30 | fzf)"
case "$TERM" in
	tmux*)  # this doesn't WORK, it does work in screen though
		sleep .1; 
		printf '\033P\33]50;%s\007' "xft:$font-$size"
		printf '\033P\33]711;%s\007' "xft:$font-$size"
		;;
	*)
		printf '\33]50;%s\007' "xft:$font-$size"
		printf '\33]711;%s\007' "xft:$font-$size"
		;;
esac
echo -e "URxvt.font:\txft:$font-$size\nURxvt.boldFont: xft:%$font-$size" | xrdb -override
