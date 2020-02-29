#!/bin/sh
# script to generate bookmarks based file in ~/.cache/bm
# currently configures bindings in:
# - lfrc
# - gtk bookmarks

touch /tmp/gtkbm
touch /tmp/lfbm

while read bm
do
	declare keyPath=( $(echo $bm) )
	fullPath="$(echo "${keyPath[1]}" | sed "s|\~|$HOME|")"
	echo "file://$fullPath" >> /tmp/gtkbm
	echo -e "hotkey: ${keyPath[0]}   path: ${keyPath[1]}\t fullPath: $fullPath"
	if grep "map ${keyPath[0]}" ~/.config/lf/lfrc &>/dev/null; then
		sed -E -i "s|(map ${keyPath[0]} cd) (.*$)|\1 ${keyPath[1]}|" ~/.config/lf/lfrc
	else
		sed -i "/# bookmarks/a map ${keyPath[0]} cd ${keyPath[1]}" ~/.config/lf/lfrc
	fi
done < ~/.cache/bm

mv -f /tmp/gtkbm ~/.config/gtk-3.0/bookmarks
