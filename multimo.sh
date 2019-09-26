#!/bin/bash

monitorNumber=`echo 0`
monitorCount=`xrandr --listmonitors | head -n 1 | cut -d" " -f2`
validInput=-1

while getopts ":m:" option
do
	case $option in
		m)
			monitorNumber=$OPTARG
			echo $monitorNumber
			shift
			;;
		:)
			echo "option -$OPTARG needs an argument"
			;;
		*)
			echo "[USAGE] ./multimo.sh -m {number of monitor} image.png"
			;;
	esac
done

function changePape {
	echo REACHED
	echo $1
}

function validateInput {
	if [ $monitorNumber -le $monitorCount ];
	then
		echo "changing wallpaper of monitor $monitorNumber..."
		validInput=0
	else
		echo "This monitor doesn't exist!"
	fi
}

case $monitorNumber in
    ''|*[!0-9]*) 
			
	    echo "[USAGE] ./multimo.sh -m {number of monitor} image.png"
	    ;;
    *) 
	    validateInput 
	    if [ $validInput -eq 0 ]
	    then
		    shift
		    echo $1
    	    fi
	    ;;
esac
