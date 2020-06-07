#!/bin/bash
queryRemoteServer() {
	(( $# == 0 )) && echo "Illegal number of parameters" && return 1

	program="$1"; shift 
	args="$@"
	MAC="$(ip neigh | grep "$(ip route | grep default | cut -d" " -f3)" | cut -d" " -f5)"

	if grep -q "$ssid" ~/.local/share/trusted_MAC; then
		if ! pgrep mpd &>/dev/null; then
			if curl --http0.9 http://MJ12:6600 &>/dev/null; then
				export MPD_PORT=6600
			else
				export MPD_PORT=6605
			fi
			/usr/bin/$program -h MJ12 -p $MPD_PORT $args
		else
			/usr/bin/$program -h localhost $args
		fi
	else
		echo "not connected to home network, aborting..."
	fi
}

queryRemoteServer "$@"
