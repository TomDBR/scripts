#!/bin/bash
[[ $# -ne 0 ]] || exit
former=""
firstTimestamp="$(echo $1 | sed -E "s/(.*[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]\.[0-9][0-9][0-9]).jpg/\1/")" # prints the whole filename too so it can be used in the final output file
lastTimestamp="$(echo "${@: -1}" | sed -E "s/.*([0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]\.[0-9][0-9][0-9]).jpg/\1/")"
(( iter=0 ))
while (( $# >= 1 ))
do
	if [[ -e /tmp/form.tmp ]]; then
		convert -append /tmp/form.tmp "$1" "/tmp/latter.tmp"
		mv /tmp/latter.tmp /tmp/form.tmp
		former='/tmp/form.tp'
	else
		cp "$1" /tmp/form.tmp
	fi
	shift
	(( iter++ ))
done
output="$firstTimestamp-$lastTimestamp.jpg"
echo "output is $output"
mv /tmp/form.tmp ./"$output"
