#!/bin/bash
source ~/.bashrc
pkill bar 
pkill dunst 
dunst_custom_color &
nohup bar >/dev/null 2>&1 &
