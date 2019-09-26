#!/bin/bash 
arecord -D "front:CARD=CODEC,DEV=0" -f S16_LE -r 48000 -c2 >(aplay -D "pulse" -f S16_LE -r 48000 -c2)
