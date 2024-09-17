#!/bin/bash

XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
WALLPAPERS="$XDG_PICTURES_DIR/wallpapers/"
current_bg="$(cat $XDG_CACHE_HOME/current.bg)"

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

DELAY=1800

while true; do
    if ! hyprctl hyprpaper; then
        echo -e "${RED}hyprpaper not running, launching it... - BEGIN${NC}"
        hyprpaper &
    fi
    wallpappath=$(find "$WALLPAPERS" | shuf -n 1)
    if ! [ $current_bg ]; then
        echo -e "${RED}current.bg not set, setting it to $wallpappath${NC}"
        echo $wallpappath > $XDG_CACHE_HOME/current.bg
        echo -e "${GREEN}Regenerating wallpappath${NC}"
        wallpappath=$(find "$WALLPAPERS" | shuf -n 1)
    fi

    # make it wallpaper the already preloaded one and preload for next time
    # hyprctl hyprpaper wallpaper ", $(hyprctl hyprpaper listloaded)"
    # hyprctl hyprpaper unload $(hyprctl hyprpaper listloaded)

    # hyprctl hyprpaper preload $wallpappath
    while ! hyprctl hyprpaper wallpaper ", $(cat $XDG_CACHE_HOME/current.bg)"; do hyprctl hyprpaper preload $(cat $XDG_CACHE_HOME/current.bg); done
    # update hyprlock
    killall -SIGUSR2 hyprlock
    hyprctl hyprpaper unload $(cat $XDG_CACHE_HOME/current.bg) || hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $wallpappath
    current_bg=$(cat $XDG_CACHE_HOME/current.bg)
    if [[ $current_bg == *.jpg ]]; then
        magick convert $current_bg $XDG_CACHE_HOME/bg.png &
    else
        cp $current_bg $XDG_CACHE_HOME/bg.png
    fi
    echo $wallpappath > $XDG_CACHE_HOME/current.bg

    # hyprctl hyprpaper unload $(hyprctl hyprpaper listloaded) || hyprctl hyprpaper unload all
    # hyprctl hyprpaper preload $wallpappath
    # hyprctl hyprpaper wallpaper ", $wallpappath"
    # for hyprlock sake
    if hyprctl hyprpaper; then
        sleep $DELAY
    else
        echo -e "${RED}hyprpaper not running, skipping sleep - END${NC}"
    fi
done
