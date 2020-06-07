#!/bin/bash
scrapeAll=( 0 )
directory="$PWD"
while getopts ":ad:" opt; do
    case "${opt}" in
        a)
			scrapeAll=( 1 )
            ;;
        d)
			directory="$OPTARG"
			;;
        *)
            echo -e "USAGE: ytSub.sh [-d directory] [-a]\n \
	-a:\t If set, scrape whole channel; if not set, scraping stops once we reach an already downloaded video.\n \
	-d:\t Specify the directory the videos should be stored in; if not given, current directory is used."
			exit
            ;;
    esac
done

cd "$directory" || (echo "Directory not found!" && exit)
echo -e "\n$(date):\t Begin scraping.\n"

while read -r line
do
	case "$line" in
		\#*)
			# ignore comments
			;;
		*)
			# list[0]: channel name
			# list[1]: URL
			# list[2]: format
			# list[3]: archival
			# list[4]: filter_string
			mapfile -t < <(echo $line | tr ',' '\n') list 
			[[ ${#list[@]} -ge 3 ]] || continue # ignore line if we didn't have at least 3 matches

			# build ytdl_filter
			unset ytdl_filter; set ytdl_filter
			if [[ -n ${list[4]} ]]; then
				mapfile -t < <(echo "${list[4]}" | tr ';' '\n') filters
				for filter in "${filters[@]}"; do
					case "${filter:0:1}" in
						+)
							ytdl_filter+=" --match-title \"${filter:1}\"";;
						-)
							ytdl_filter+=" --reject-title \"${filter:1}\"";;
						*)
							echo "Invalid filter!"
					esac
				done
			fi

			# make sure name has no weird shit in it
			name="$(echo ${list[0]} | tr ';' '_' | tr '/' '_' | tr '&' '_')"
			url="${list[1]}"

			# download based on given format
			ytdl_cmd="youtube-dl -w --add-metadata --cookies ~/cookies.txt --download-archive \"$name/.archive\" $ytdl_filter"
			if [[ ${list[2]^^} == "AUDIO" ]]; then
				# TODO encode image in opus file https://wiki.xiph.org/VorbisComment#Cover_art
				ytdl_cmd+=" -x --audio-format opus --audio-quality 0 --embed-thumbnail -i"
			elif [[ ${list[2]^^} == "VIDEO" ]]; then
				ytdl_cmd+=" --embed-subs --convert-subs ass -i"
			else
				continue
			fi

			ytdl_cmd+=" -o \"$name/%(title)s.%(ext)s\" $url"
			sh -c "$ytdl_cmd" &> >(tee /tmp/ytdl_tmp) &
			id=$!

			# kill youtube-dl when scrapeAll flag wasn't given or when no archival_status was set
			if [[ $scrapeAll -eq 0  || -z ${list[3]} ]]; then
				while kill -0 ${id} 2>/dev/null; do
					if grep -qE "upload date is not in range|already been recorded in archive" /tmp/ytdl_tmp; then
						kill $id
					fi
					sleep 2
				done
			else 
				wait $id
			fi
			;;
		esac
done < ~/.local/share/ytsubs

# was used to tag videos that could be removed, but nowadays this script is only used for archival purposes, so comment out the next part
# while read -r video
# do
#     if grep -q "$video" /home/xanadu/.config/ranger/tagged; then
# 		rm "$video" 
# 		sed -i "|$video|d" /home/xanadu/.config/ranger/tagged
# 	fi
# done < <(find ~/Videos/Youtube/Subscriptions -type f -iname "*.mkv")
	
# delete empty directories
find ~/Videos/Youtube/Subscriptions -type d -empty -delete
