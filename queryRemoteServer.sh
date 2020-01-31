#!/bin/bash
queryRemoteServer() {
	if (( $# == 0 )); then
    		echo "Illegal number of parameters"
		return 1
	fi
	program="$1"
	shift
	args="$@"
	#echo "program is $program, args is: $args"
	ssid="$(iw wlp3s0 info | grep ssid | cut -d" " -f2)"
	if [[   "$ssid" == "FRITZ!Box"    || 
		"$ssid" == "TP-Link_DOWN" ||
		"$ssid" == "TP-Link_UP" ]]; then
		if ! pgrep mpd &>/dev/null; then
			if curl --http0.9 http://MJ12:6600 &>/dev/null; then
				export MPD_PORT=6600
			else
				export MPD_PORT=6605
			fi
			/usr/bin/"$program" -h MJ12 -p "$MPD_PORT" $args
		else
			/usr/bin/$program -h localhost $args
		fi
	else
		echo "not connected to home network, aborting..."
	fi
}

queryRemoteServer "$@"
