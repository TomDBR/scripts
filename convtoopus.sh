#!/bin/bash
#file="/home/xanadu/flacsongs.txt"
#while IFS=$'\n' read -r offset
#do 
#	newdir="$(echo "$offset" | sed -e 's/\/[^\/]*$//')"
#	echo "source dir is: $newdir"
#	if ! [ -d "/media/InternalHDD/6TB_WD_HDD/phonemus/$newdir" ]; then
#		echo "creating directory: /media/InternalHDD/6TB_WD_HDD/phonemus/$newdir"
#		mkdir -p /media/InternalHDD/6TB_WD_HDD/phonemus/"$newdir"
#	fi
#	destin="/media/InternalHDD/6TB_WD_HDD/phonemus/${offset::-5}.opus"
#	if ! [ -f "$destin" ]; then
#		echo "destination file is: $destin"
#		cp -f "$offset" ~/.temp.flac
#		#ffmpeg -y -nostdin -i ~/.temp.flac -ar 48000 -ac 2 -acodec libopus -ab 128k -vbr on ~/.temp.opus
#		ffmpeg -i ~/.temp.flac -ar 48000 -ac 2 -acodec libopus -ab 128k -vbr on ~/.temp.opus
#		[ -f ~/.temp.opus ] && mv ~/.temp.opus "$destin"
#	fi
#done < "$file"

coverfile="/home/xanadu/covers.txt"
while IFS=$'\n' read -r cover
do 
	newdir="$(echo "$cover" | sed -e 's/\/[^\/]*$//')"
	extension="${cover: -3}"
	destinationDirectory="/media/InternalHDD/6TB_WD_HDD/phonemus/$newdir"
	destinationFile="$destinationDirectory/cover.$extension"
	while ! [ -d "$destinationDirectory" ]
	do
		destinationDirectory="$(echo "$destinationDirectory" | sed -e 's/\/[^\/]*$//')"
		destinationFile="$destinationDirectory/cover.$extension"
	done
	if [ -f "${destinationFile: -3}"* ]; then
		echo "skipping since $destinationFile already exists" 
	else
		cp "$cover" "$destinationFile"
	fi
done < "$coverfile"
