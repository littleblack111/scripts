#!/bin/bash
XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
WALLPAPERS="$XDG_VIDEOS_DIR/wallpapers/"

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

DELAY=1800

while true; do
    current_bg="$(cat $XDG_CACHE_HOME/current.bg)"
    if ! [ "$current_bg" ]; then
        echo -e "${RED}current.bg not set, regenerating it${NC}"
        current_bg="$(find "$WALLPAPERS" | shuf -n 1)"
        echo "$current_bg" > $XDG_CACHE_HOME/current.bg
        echo -e "${GREEN}Regenerating wallpappath${NC}"
    fi
    wallpappath=$(find "$WALLPAPERS" | shuf -n 1)

    # wallust run --skip-sequences $current_bg
    # wallust run --backend kmeans --skip-sequences $current_bg & # using cache now
    killall mpvpaper
    # for output in $(hyprctl monitors | grep "Monitor" | awk '{print $2}'); do
        # mpvpaper --auto-pause --mpv-options="hwdec=auto --no-audio --loop" --fork "$output" "$current_bg"
    mpvpaper --auto-pause --mpv-options="hwdec=auto --no-audio --loop" --fork "*" "$current_bg"
    # done

    wallust run --backend full --skip-sequences "$XDG_CACHE_HOME/$(basename $current_bg).png" &
    echo "$XDG_CACHE_HOME/$(basename $current_bg).png"

    swaync-client --reload-css

    prime-run ffmpeg -hwaccel cuda -i "$current_bg" -y "$XDG_CACHE_HOME/bg.png" &
    current_bg=$(cat "$XDG_CACHE_HOME/current.bg")
    echo "$wallpappath" > "$XDG_CACHE_HOME/current.bg"
    
    # update hyprlock
    killall -USR2 hyprlock

    # generates cache for next wallpaper
    ( prime-run ffmpeg -hwaccel cuda -i "$wallpappath" -y "$XDG_CACHE_HOME/$(basename $wallpappath).png"; nice -n 20 wallust run --backend full --skip-templates --skip-sequences "$XDG_CACHE_HOME/$(basename $wallpappath).png" ) &

    nice -n 20 sleep $DELAY
done
