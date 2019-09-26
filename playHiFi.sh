#!/bin/bash
arecord -D "front:CARD=Generic,DEV=0" -f S16_LE -r 48000 -c2 >(aplay -D "pulse" -f s16_LE -r 48000 -c2)
