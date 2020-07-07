#!/bin/bash
queryRemoteServer() {
	(( $# == 0 )) && echo "Illegal number of parameters" && return 1

	program="$1"; shift 
	args="$*"
	# TODO multiple tun devices? probably unlikely
	tun="$(ip tuntap list 2>/dev/null | cut -d':' -f1 | head -n 1)"
	gw="$(ip route show default | grep -v $tun | cut -d " " -f3)"
	MAC="$(ip neigh | grep "$gw" | cut -d" " -f5)"
	HOST_NAME='localhost'
	MPD_PORT=6600

	if ! command -v "$program" &>/dev/null; then
		echo "Program $program not found!" && return 1
	fi
	if ! grep -q "$MAC" ~/.local/share/trusted_MAC; then
		echo "not connected to home network, aborting..." && return 1
	fi
	pgrep mpd &>/dev/null || HOST_NAME="MJ12"
	curl -s http://"$HOST_NAME":"$MPD_PORT" &>/dev/null || MPD_PORT=6605
		
	/usr/bin/"$program" -h "$HOST_NAME" -p "$MPD_PORT" $args
}

queryRemoteServer "$@"
