#!/usr/bin/zsh

pkill -f backgroundblur
wallpaper="$(find /home/system/Pictures/wallpapers -type f -name '*.jpg' -o -name '*.png' | shuf -n 1)"
feh --bg-fill "$wallpaper" &
$HOME/.config/bspwm/scripts/backgroundblur -i "$wallpaper" &
kill -SIGTERM $(pgrep runbgblur.sh)
