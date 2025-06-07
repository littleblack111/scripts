#!/bin/bash

# ARG1 = wallpaper path

XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Error: No wallpaper path provided${NC}"
    exit 1
fi

WALLPAPER="$1"

if [ ! -f "$XDG_CACHE_HOME/$(basename "$WALLPAPER").png" ]; then
    echo -e "${GREEN}Generating PNG cache for $WALLPAPER${NC}"
    ffmpeg -hwaccel cuda -i "$WALLPAPER" -y "$XDG_CACHE_HOME/$(basename "$WALLPAPER").png"
fi

wallust run --backend full --skip-sequences "$XDG_CACHE_HOME/$(basename "$WALLPAPER").png"

echo "\$bg = $XDG_CACHE_HOME/$(basename "$WALLPAPER").png" > "$XDG_CONFIG_HOME/hypr/bg.conf"

ffmpeg -hwaccel cuda -i "$WALLPAPER" -y "$XDG_CACHE_HOME/bg.png"

(
    hyprctl reload config-only &

    swaync-client --reload-css &

    # gdbus call --session --dest com.mitchellh.ghostty --object-path /com/mitchellh/ghostty --method org.gtk.Actions.Activate reload-config [] [] &
	# kitten @ action load_config_file
	killall -SIGUSR1 kitty

    killall -USR2 hyprlock &
) &

echo "$WALLPAPER" > "$XDG_CACHE_HOME/current.bg"
