#!/bin/bash

XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
WALLPAPERS="$XDG_PICTURES_DIR/wallpapers/"

DELAY=1800

while ! hyprctl hyprpaper; do
    sleep 0.05
done

while true; do
    wallpappath=$(find "$WALLPAPERS" | shuf -n 1)
    # make it wallpaper the already preloaded one and preload for next time
    # hyprctl hyprpaper wallpaper ", $(hyprctl hyprpaper listloaded)"
    # hyprctl hyprpaper unload $(hyprctl hyprpaper listloaded)

    # hyprctl hyprpaper preload $wallpappath

    hyprctl hyprpaper unload $(hyprctl hyprpaper listloaded) || hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $wallpappath
    hyprctl hyprpaper wallpaper ", $wallpappath"
    # for hyprlock sake
    if [[ $wallpappath == *.jpg ]]; then
        convert $wallpappath $XDG_CACHE_HOME/cwall.png
    else
        cp $wallpappath $XDG_CACHE_HOME/cwall.png
    fi
    sleep $DELAY
done
