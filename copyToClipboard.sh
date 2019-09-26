#!/bin/bash

file="$@"
ext="$(echo "$file" | grep -oE "\.[a-Z]*$")"

if [ "$ext" == ".jpg" ]
then
	xclip -selection c -t image/jpeg -d :0 "$file"
elif [ "$ext" == ".png" ]
then
	xclip -selection c -t image/png -d :0 "$file"
else
	xclip -selection c -d :0 "$file"
fi
