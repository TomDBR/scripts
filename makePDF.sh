#!/bin/bash

(( iter = 0 ))
for i in */
do
	echo "$i"
	cd "$i"
	(( firstPic = 0 ))
	for y in *
	do
		if [[ $firstPic -eq 0 ]]
		then
			echo "$y"
			noslash="$(echo "${i::-1}")"
			convert "$y" -pointsize 25 -fill blue -gravity center -draw "text 0,0 '$(echo "$noslash")'" "new$y"
			echo "${i::-1}"
			mv "new$y" "$y"
		fi
		echo "$y"
		(( iter++ ))
		(( firstPic++ ))
		num="$(printf %03d $iter)"
		cp "$y" ../../iter/"$num".png
	done
	cd ../
done
