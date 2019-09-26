Music() {

	(( size=50 ))
	while true
	do
		pgrep mpd && var=$(mpc)
		status=""
		buffer="                                                                                   "

		if [ $(echo "$var" | wc -l) -gt 1 ]; then
			musicStatus=$(echo "$var" | sed -n '2p' | grep -oE '\[.*\]')
			status=''
			#musicTitle="$(echo "$var" | sed -n '1p')"
			artist="$(mpc -f %artist% | sed -n '1p')"
			title="$(mpc -f %title% | sed -n '1p')"
			if (( ( ${#artist} + ${#title} + 3 ) > $size )); then
				(( titleLen=${#title})) ## length of title on its own
				(( artistLen=${#artist})) ## length of artist on its own
				(( totalLen=${#title} + 3 + ${#artist} ))
				(( scrollingLen=$size - 3 - $artistLen))
				(( i = 0 ))
				(( delay = 0 )) # Used to prevent text from scrolling out of sight right away, improves readability
				while [[ "$(mpc | sed -n '2p' | grep -oE '\[.*\]')" = '[playing]' && "$artist - $title" = "$(mpc | sed -n '1p')" ]]
				do
					if (( $i > ( $totalLen - $size ) )); then
						musicTitlePart="${title:$i:(($titleLen - $i))}${buffer:1:(($i - ( $totalLen - $size) ))}"
						#echo "size of musicTitlePart = ${#musicTitlePart}"
						(( i++ ))
						if (( $i > ( $titleLen ) )); then
							(( i=0 ))
							(( delay=0 ))
						fi
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
					sleep 0.2
				done
			else
				#(( bufferLen=50 - ${#musicTitle} ))
				echo -e "M| $artist - $title"
			fi
		else
			echo 'M'
			sleep 1
		fi
	done
}

Music
