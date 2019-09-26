#!/bin/bash

#for x in $(bspc query -N -n '.leaf.!window')
for x in $(bspc query -N -n '.leaf.sticky')
do
	bspc node "$x" -k
done
