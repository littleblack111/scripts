#!/usr/bin/zsh

while true; do
    #wallpaper="$(find /home/system/Pictures/wallpapers -type f -name '*.jpg' -o -name '*.png' | shuf -n 1)"
    #cp $wallpaper $HOME/.wallpaper/old.jpg
    script -c "$HOME/scripts/wallpapertrans.sh" $HOME/scripts/logs/wallpapertrans.log -a --force
    #feh --bg-fill $wallpaper
    # restart
    sleep 1800
done
