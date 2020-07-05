#!/bin/sh
# Toggle between the 2 MPD libraries, change port accordingly

pgrep mpd && pkill mpd
[ -f /tmp/mpd.fifo ] && rm /tmp/mpd.fifo

echo "Changing MPD_HOST variable"
if [[ $MPD_PORT -eq 6600 ]]; then
	export MPD_PORT='6605'
	/usr/bin/mpd "$HOME/.config/mpd2/mpd.conf"
	#sed -i "s|$HOME/Music/Albums|$HOME/Music/Soundtracks|" "$HOME/.config/ncmpcpp/config"
else
	export MPD_PORT='6600'
	/usr/bin/mpd "$HOME/.config/mpd/mpd.conf"
	#sed -i "s|$HOME/Music/Soundtracks|$HOME/Music/Albums|" "$HOME/.config/ncmpcpp/config"
fi
