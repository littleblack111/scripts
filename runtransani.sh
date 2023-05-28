#!/usr/bin/zsh

while true; do
    #wallpaper="$(find /home/system/Pictures/wallpapers -type f -name '*.jpg' -o -name '*.png' | shuf -n 1)"
    #cp $wallpaper $HOME/.wallpaper/old.jpg
    $HOME/.config/bspwm/scripts/wallpapertrans.sh
    #feh --bg-fill $wallpaper
    # restart
    sleep 1800
done
