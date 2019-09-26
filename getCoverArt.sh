#!/bin/bash

file="$HOME/nc_image.png"
tmpFile="$HOME/.tmpCoverFile"
URI="$(mpc -f %file% current)"
MPDPORT="$(ss -tulpn | grep mpd | cut -d":" -f2 | cut -d" " -f1 | grep -v 8000)"
echo -e "URI is $URI"

# delete file if it exists, then create it again, in empty state.
[[ -e "$file" ]] && rm "$file"
touch "$file"

#get filesize of albumart
echo -e "albumart \"$URI\" 0\\nclose" | nc localhost $MPDPORT > "$tmpFile"
lines="$(wc -l < $tmpFile)"
if (( lines <= 1 )); then
	echo "This song has no cover art!"
	[[ -e "$tmpFile" ]] && rm "$tmpFile"
	exit 1
fi
totalSize="$(sed -E 's/size\: ([0-9]*)/\1/' "$tmpFile" | sed -n '2p')"
binarySize="$(sed -E 's/binary\: ([0-9]*)/\1/' "$tmpFile" | sed -n '3p')"

# get the albumart from mpd
(( bytePos=0 ))
while true
do
	echo -e "albumart \"$URI\" $bytePos\\nclose" | nc localhost $MPDPORT > "$tmpFile"
	if [ "$(tail -n 1 "$tmpFile")" == "OK" ]; then
		sed -i '1,3d;$d' "$tmpFile"
		truncate -s "$binarySize" "$tmpFile"
		size="$(stat --printf="%s" "$tmpFile")"
		(( bytePos = bytePos + size ))
		cat "$tmpFile" >> "$file"
		#echo -e "current size of file is $(stat --printf="%s" "$file") of $totalSize"
	fi
	if (( "$(stat --printf="%s" "$file")" >= totalSize )); then
		echo -e "removing junk data at end of file"
		truncate -s "$totalSize" "$file"
		echo -e "current size of file is $(stat --printf="%s" "$file") of $totalSize"
		break
	fi
done

[[ -e "$tmpFile" ]] && rm "$tmpFile"
