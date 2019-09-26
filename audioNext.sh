#!/bin/bash

port=`ss -tulpn | grep mpd | cut -d":" -f2 | cut -d" " -f1 | grep -v 8000`
mpc -p $port next
