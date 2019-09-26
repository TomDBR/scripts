#!/bin/bash
# Values in Order: xPos, yPos, Width, Height
coords=( $(xwininfo | grep -E "Absolute upper-left|Width|Height" | awk -F ':' '/[a-zA-Z\-]\:[ ]{1,}[0-9]{1,}/ { split($2, a, " "); print a[1] }') )
ffmpeg -video_size ${coords[2]}x${coords[3]} -framerate 30 -f x11grab -i :0.0+${coords[0]},${coords[1]} ~/Videos/"$(date +%s)".mp4
