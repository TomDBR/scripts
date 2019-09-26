#!/bin/bash

pwd=`pwd`
input=$(echo "$@" | sed -n -e "s|$(pwd)/||p")
nextFile=`ls -N | grep -FA1 "$input" | grep -Fv "$input"`
echo $nextFile
