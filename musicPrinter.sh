#!/bin/bash
leftHand="$1"
rightHand="$2"
leftIter=1
rightIter=1
mult="$(( leftHand * rightHand ))"

smallest=""
biggest=""

if (( $leftHand <= $rightHand )); then 
	smallest=$leftHand; biggest=$rightHand
else 
	smallest=$rightHand; biggest=$leftHand
fi
(( x = 0 ))
(( y = 0 ))
echo -e "small: $smallest,\t  big: $biggest\n------------------------------"
while (( $x < $mult ))
do
	#echo "x: $x y:$y xI:$leftIter yI:$rightIter"
	if (( x < y )); then
		echo -e "x: $leftIter \t\t(x: $x)"
		(( x += smallest ))
		(( leftIter++ ))
	elif (( x == y )); then
		echo -e "x: $leftIter  \ty: $rightIter \t(x: $x, y: $y)"
		(( y += biggest ))
		(( rightIter++ ))
		(( x += smallest ))
		(( leftIter++ ))
	else
		echo -e "\ty: $rightIter \t(y: $y)"
		(( y += biggest ))
		(( rightIter++ ))
	fi
done
echo -e "------------------------------\nx: 1 \ty: 1 \t(x: $x, y: $y)"
