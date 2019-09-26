#!/bin/bash
# switch keyboard layout between 'us' and 'be'

currentLayout=`setxkbmap -print -verbose 10 | grep layout | cut -d ":" -f 2 | tr -d " "`
if [ $currentLayout = "us" ] 
then
	`setxkbmap 'be'`
else
	`setxkbmap 'us'`
fi
