#!/bin/bash
rofi -dmenu \
     -password \
     -p "$*" \
     -lines 0 \
     -font "JetBrainsMono Nerd Font 12" \
     -width 30

