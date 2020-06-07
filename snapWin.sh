#!/bin/env bash

if [ -z "$2" ]; then                                                                                              
  window_id=$(xdotool getactivewindow)
else
  window_id="$2"
fi

echo "window_id=$window_id"


# Check if window is floating
# TODO

snap_position=$1

# Get display and window dimensions
DISPLAY_GEOMETRY=$(xdotool getdisplaygeometry)
display_width=$(echo "$DISPLAY_GEOMETRY" | cut -d ' ' -f 1)
display_height=$(echo "$DISPLAY_GEOMETRY" | cut -d ' ' -f 2)

WINDOW_GEOMETRY=$(xdotool getwindowgeometry --shell $window_id)
echo "window_geometry=$window_geometry"
window_width=$(echo "$WINDOW_GEOMETRY" | grep WIDTH | cut -d = -f 2)
window_height=$(echo "$WINDOW_GEOMETRY" | grep HEIGHT | cut -d = -f 2)

top_padding=$(bspc config top_padding)
border_width=$(bspc config border_width)
window_gap=$(bspc config window_gap)

echo "DISPLAY: $display_width x $display_height    WINDOW: $window_width x $window_height  BORDER_WIDTH: $border_width TOP_PADDING: $top_padding"

# Compute the appropriate window coordinates according to desired snap position
min_x=$((window_gap))
max_x=$((display_width - window_width - border_width * 2 - window_gap))
med_x=$(( (max_x + min_x) / 2 ))
min_y=$((top_padding + window_gap))
max_y=$((display_height - window_height - border_width * 2 - window_gap))
med_y=$(( (max_y + min_y) / 2 ))
# echo "med_x = $med_x, med_y = $med_y"

case $snap_position in
  tl | lt | nw | wn)
    _x=$min_x
    _y=$min_y
    ;;
  t | n)
    _x=$med_x
    _y=$min_y
    ;;
  tr | rt | ne | en)
    _x=$max_x
    _y=$min_y
    ;;
  l | w)
    _x=$min_x
    _y=$med_y
    ;;
  c)
    _x=$med_x
    _y=$med_y
    ;;
  r | e)
    _x=$max_x
    _y=$med_y
    ;;
  bl | lb | sw | ws)
    _x=$min_x
    _y=$max_y
    ;;
  b | s)
    _x=$med_x
    _y=$max_y
    ;;
  br | rb | se | es)
    _x=$max_x
    _y=$max_y
    ;;
  *)
    echo -e "Unknown snap position \`$snap_position\`. Valid values: \n nw, n, ne, e, c, w, sw, s, se \n tl, t, tr, l, c, r, bl, b, br\nand its permutations (e.g., nw equals wn)."
    exit 1
esac

# Move window
xdotool windowmove $window_id $_x $_y
