#!/bin/bash

XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
WALLPAPERS="$XDG_PICTURES_DIR/wallpapers/"
current_bg="$(cat $XDG_CACHE_HOME/current.bg)"
swwwarg="--transition-type random --transition-duration 0.85 --transition-fps 160 --transition-bezier 1,0.33,0.3,1"

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

DELAY=1800

while true; do
    (while ! swww query; do swww-daemon; done) &
    wallpappath=$(find "$WALLPAPERS" | shuf -n 1)
    if ! [ $current_bg ]; then
        echo -e "${RED}current.bg not set, setting it to $wallpappath${NC}"
        echo $wallpappath > $XDG_CACHE_HOME/current.bg
        echo -e "${GREEN}Regenerating wallpappath${NC}"
        wallpappath=$(find "$WALLPAPERS" | shuf -n 1)
    fi

    # wallust run --skip-sequences $(cat $XDG_CACHE_HOME/current.bg)
    # wallust run --backend kmeans --skip-sequences $(cat $XDG_CACHE_HOME/current.bg) & # using cache now
    swww img $(cat $XDG_CACHE_HOME/current.bg) $swwwarg
    wallust run --backend full --skip-sequences $(cat $XDG_CACHE_HOME/current.bg)
    (sleep 0.1; pgrep -f wallust && wallust run --backend kmeans --skip-sequences $(cat $XDG_CACHE_HOME/current.bg)) &

    swaync-client --reload-css

    current_bg=$(cat $XDG_CACHE_HOME/current.bg)
    if [[ $current_bg == *.jpg ]]; then
        magick convert $current_bg $XDG_CACHE_HOME/bg.png &
    else
        cp $current_bg $XDG_CACHE_HOME/bg.png
    fi
    echo $wallpappath > $XDG_CACHE_HOME/current.bg
    # update hyprlock
    killall -SIGUSR2 hyprlock

    nice -n 20 wallust run --backend full --skip-templates --skip-sequences $wallpappath

    if swww query; then
        sleep $DELAY
    else
        echo -e "${RED}swww not running, skipping sleep - END${NC}"
        swww-daemon &
    fi
done
