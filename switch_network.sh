#!/bin/bash
nw="$(cat ~/.cache/ssids | rofi -dmenu)"
[[ -n "$nw" ]] && nmcli connection up "$nw"
