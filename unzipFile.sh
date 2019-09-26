#!/bin/bash
file="$@"
unzip "$@" -d "$(echo "$@" | sed "s/.zip$//")"
