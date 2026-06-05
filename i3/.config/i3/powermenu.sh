#!/bin/bash

option=$(echo -e "   Poweroff\n   Reboot\n   Standby\n   Exit" | rofi -dmenu -p "Energy" -i)

case "$option" in
    *"Poweroff")   loginctl poweroff ;;
    *"Reboot")  loginctl reboot ;;
    *"Standby")  zzz ;;
    *"Exit")       i3-msg exit ;;
esac

