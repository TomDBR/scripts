#!/bin/bash

file="$@"

curl -F"file=@$@" http://0x0.st | tee <(xclip -sel c)
