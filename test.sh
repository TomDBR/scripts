#!/bin/bash

Music() {
	pgrep mpd &>/dev/null && mpdport="$(ss -tulpn | grep mpd | cut -d":" -f2 | cut -d" " -f1 | grep -v 8000)" && var="$(mpc -p $mpdport -f "%artist%;%title%" current)" 
	curSong="/tmp/curSong.bar"
	size=50
	buffer="                                                                                   "
	while true
	do
		until pgrep mpd &>/dev/null; do sleep 1; done
		artist="$(echo "$var" | sed -E 's/(.*)\;.*/\1/g')"
		title="$(echo "$var" | sed -E 's/.*\;(.*)/\1/g')"
		total="$artist - $title"
		if [ $(echo "$var" | wc -l) -gt 0 ]; then
			if (( ${#total} > $size )); then
				(( titleLen=${#title})) ## length of title on its own
				(( artistLen=${#artist})) ## length of artist on its own
				(( totalLen=${#title} + ${#artist} )) ## length of artist and title with ' - ' separator inbetween
				## scrollingLen is the amount of characters that are out of view and have to be scrolled in
				if (( totalLen > size )); then (( scrollingLen = totalLen - size ))
				else (( scrollingLen = size - totalLen )); fi
				(( i = 0 ))
				(( delay = 0 )) # Used to prevent text from scrolling out of sight right away, improves readability
				mpc -p $mpdport -f "%artist%;%title%" current --wait > $curSong 2>&1 & 
				pidmpc=$!
				while kill -0 $pidmpc 2> /dev/null
				do
					# if the artistlenght is greater than the title, scroll the whole thing
					if (( artistLen > titleLen )); then
						# if true, end of songtitle reached, whitespace is being added.
						if (( i > ( totalLen - size ) )); then
							musicTitlePart="${total:$i:(($totalLen - $i))}${buffer:1:(($i - ( $totalLen - $size) ))}"
							(( i++ ))
							if (( $i > ( $totalLen ) )); then
								(( i=0 ))
								(( delay=0 ))
							fi
						# else, end of songtitle not yet reached, text is scrolling
						else
							musicTitlePart="${total:$i:$scrollingLen}"
							if (( ${#musicTitlePart} > size )); then
								musicTitlePart="${musicTitlePart:0:50}"
							fi
							if  (( $delay > 8 ))
							then
								(( i++ ))
							else
								((  delay++ ))
							fi
						fi
						echo -e "M| $musicTitlePart"
					# else, scroll just the title
					else
						# if true, end of songtitle reached, whitespace is being added.
						if (( i > ( totalLen - size ) )); then
							musicTitlePart="${title:$i:(($titleLen - $i))}${buffer:1:(($i - ( $totalLen - $size) ))}"
							(( i++ ))
							if (( $i > ( $titleLen ) )); then
								(( i=0 ))
								(( delay=0 ))
							fi
						# else, end of songtitle not yet reached, text is scrolling
						else
							musicTitlePart="${title:$i:$scrollingLen}"
							#echo "size of musicTitlePart = ${#musicTitlePart}"
							if  (( $delay > 8 ))
							then
								(( i++ ))
							else
								((  delay++ ))
							fi
						fi
						echo -e "M| $artist - $musicTitlePart"
					fi
					sleep 0.4
				done
				var="$(cat $curSong)"
			else
				mpc -p $mpdport -f "%artist%;%title%" current --wait > $curSong 2>&1 &
				pidmpc=$!
				echo -e "M| $artist - $title"
				while kill -0 $pidmpc 2> /dev/null
				do
					wait
				done
				var="$(cat $curSong)"
			fi
		else
			pgrep mpd && var="$(mpc -p $mpdport -f "%artist%;%title%" current --wait)"
			echo "M"
		fi
	case "$var" in
		"mpd error"*)
			mpdport="$(ss -tulpn | grep mpd | cut -d":" -f2 | cut -d" " -f1 | grep -v 8000)" 
			while [[ "$mpdport" == "" ]]; do
				mpdport="$(ss -tulpn | grep mpd | cut -d":" -f2 | cut -d" " -f1 | grep -v 8000)" 
				sleep 0.5
			done
			var="$(mpc -p $mpdport -f "%artist%;%title%" current)" 
			;;
		*)
			artist="$(echo "$var" | sed -E 's/(.*)\;.*/\1/g')"
			title="$(echo "$var" | sed -E 's/.*\;(.*)/\1/g')"
			;;
	esac
	done
	#set +x
}
Music
