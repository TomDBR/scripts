#!/bin/bash
file="$@"
# check if zip file already has a root directory
if $(unzip -qql $file | head -n 1 | grep -qE '.*/$')
then
      unzip "$@"
else
      unzip "$@" -d "$(echo "$@" | sed "s/.zip$//")"
fi
