#!/bin/bash
iter=0
dest="/home/Tom/Music/Albums/Compilations/111 Years of Deutsche Grammophon_ The Collectors’ Edition 2/"
for i in */;
do
	echo $i
	## Uncomment to test if it works properly
	#cp "$i"*.{jpg,png,cue,log,md5} /home/Tom/tmp

	let iter++
	dir=`ls "$dest" | sed -n "$iter"p`

	## Comment when testing if it works properly
	cp "$i"*{jpg,png,cue,log,md5} "$dest""$dir"
done

