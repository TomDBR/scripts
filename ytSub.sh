#!/bin/bash
cd ~/Videos/Youtube/Subscriptions
echo -e "\n$(date) running command..\n"

youtube-dl --add-metadata --dateafter now-1week -i -o AccelJoe/%\(title\)s.%\(ext\)s https://www.youtube.com/channel/UC5o1EJ-fiuhWQlW0Z345SBw &>/home/xanadu/.config/cron/cronYT &
id=$!
while kill -0 $id 2>/dev/null
do 
	if grep -q "upload date is not in range" /home/xanadu/.config/cron/cronYT
	then
		kill $id
		echo > /home/xanadu/.config/cron/cronYT
	fi
done &>/dev/null
youtube-dl --add-metadata --dateafter now-1week -o Noka/%\(title\)s.%\(ext\)s https://www.youtube.com/channel/UCKfbbsRdWZJGQffxT9IF8qA &>/home/xanadu/.config/cron/cronYT &
id=$!
while kill -0 $id 2>/dev/null
do 
	if grep -q "upload date is not in range" /home/xanadu/.config/cron/cronYT
	then
		kill $id
		echo > /home/xanadu/.config/cron/cronYT
	fi
done &>/dev/null
youtube-dl --add-metadata --dateafter now-1week -o yoshitoshi\ ABe/%\(title\)s.%\(ext\)s https://www.youtube.com/channel/UCXNsoUix1kehZdBGwuM20pw &>/home/xanadu/.config/cron/cronYT &
id=$!
while kill -0 $id 2>/dev/null
do 
	if grep -q "upload date is not in range" /home/xanadu/.config/cron/cronYT
	then
		kill $id
		echo > /home/xanadu/.config/cron/cronYT
	fi
done &>/dev/null

for i in */
do
        cd "$i"
        for f in *.mkv
        do
                line="/home/xanadu/Videos/Youtube/Subscriptions/$i$f"
                #echo "$line"
                if grep -q "$line" /home/xanadu/.config/ranger/tagged
                then
                        rm "$f"
			sed -i "|$line|d" /home/xanadu/.config/ranger/tagged
                fi
        done
        cd ../
done
if [[ $PWD == "$HOME/Videos/Youtube/Subscriptions" ]]
then
	find . -type d -empty -delete
fi
