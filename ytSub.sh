#!/bin/bash
# TODO: flag to toggle whether scraping stops when we hit a video that was already downloaded
cd ~/Videos/Youtube/Subscriptions
echo -e "\n$(date) running command..\n"

while read -r line
do
	case "$line" in
		\#*)
			# ignore comments
			;;
		*)
			mapfile -t < <(echo $line | tr ' ' '\n') list 
			[[ ${#list[@]} -eq 2 ]] || continue # ignore line if we didn't have 2 matches
			youtube-dl --add-metadata --dateafter now-1week -i -o ${list[0]}/%\(title\)s.%\(ext\)s ${list[1]} &>/tmp/ytdl_tmp &
			id=$!
			while kill -0 $id 2>/dev/null
			do 
				grep -q "upload date is not in range" /tmp/ytdl_tmp || kill $id
				sleep 1
			done &>/dev/null
			;;
		esac
done < ~/.cache/ytsubs

# was used to tag videos that could be removed, but nowadays this script is only used for archival purposes, so comment out the next part
while read -r video
do
    grep -q "$video" /home/xanadu/.config/ranger/tagged && rm "$video"
	sed -i "|$line|d" /home/xanadu/.config/ranger/tagged
done < <(find ~/Videos/Youtube/Subscriptions -type -f -iname "*.mkv")
	
# delete empty directories
find ~/Videos/Youtube/Subscriptions -type d -empty -delete
