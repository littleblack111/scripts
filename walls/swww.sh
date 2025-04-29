#!/bin/bash

XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
WALLPAPERS="$XDG_PICTURES_DIR/wallpapers/"
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
	current_bg="$(cat $XDG_CACHE_HOME/current.bg)"

    # wallust run --skip-sequences $(cat $XDG_CACHE_HOME/current.bg)
    # wallust run --backend kmeans --skip-sequences $(cat $XDG_CACHE_HOME/current.bg) & # using cache now
    swww img $current_bg $swwwarg
    wallust run --backend full --skip-sequences $(cat $XDG_CACHE_HOME/current.bg) &
    # (sleep 0.1; pgrep -f wallust && wallust run --backend kmeans --skip-sequences $(cat $XDG_CACHE_HOME/current.bg)) &

	# tell hypr* where is bg
	echo "\$bg = $current_bg" > "$XDG_CONFIG_HOME/hypr/bg.conf"

	# reload hyprland
	hyprctl reload config-only &

    swaync-client --reload-css

	# gdbus call --session --dest com.mitchellh.ghostty --object-path /com/mitchellh/ghostty --method org.gtk.Actions.Activate reload-config [] [] &
	kitten @ action load_config_file
	kitty @ set-colors --all --configured ~/.config/kitty/colors.conf

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
