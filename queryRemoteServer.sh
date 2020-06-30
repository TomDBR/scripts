#!/bin/bash
queryRemoteServer() {
	(( $# == 0 )) && echo "Illegal number of parameters" && return 1

	program="$1"; shift 
	args="$*"
	MAC="$(ip neigh | grep "$(ip route | grep default | cut -d" " -f3)" | cut -d" " -f5)"
	HOST_NAME='localhost'
	export MPD_PORT=6600

	if ! command -v "$program" &>/dev/null; then
		echo "Program $program not found!" && return 1
	fi
	if ! grep -q "$MAC" ~/.local/share/trusted_MAC; then
		echo "not connected to home network, aborting..." && return 1
	fi
	pgrep mpd &>/dev/null || HOST_NAME="MJ12"
	curl -s http://"$HOST_NAME":"$MPD_PORT" &>/dev/null || export MPD_PORT=6605
		
	/usr/bin/"$program" -h "$HOST_NAME" -p "$MPD_PORT" "$args"
}

queryRemoteServer "$@"
