#!/bin/bash
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
WALLPAPERS="$XDG_PICTURES_DIR/live-wallpapers/"
current_bg="$(cat $XDG_CACHE_HOME/current.bg)"

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

DELAY=1800

while true; do
    wallpappath=$(find "$WALLPAPERS" | shuf -n 1)
    if ! [ "$current_bg" ]; then
        echo -e "${RED}current.bg not set, setting it to $wallpappath${NC}"
        echo "$wallpappath" > $XDG_CACHE_HOME/current.bg
        current_bg="$wallpappath"
        echo -e "${GREEN}Regenerating wallpappath${NC}"
        wallpappath=$(find "$WALLPAPERS" | shuf -n 1)
    fi

    # wallust run --skip-sequences $current_bg
    # wallust run --backend kmeans --skip-sequences $current_bg & # using cache now
    killall mpvpaper
    for output in $(hyprctl monitors | grep "Monitor" | awk '{print $2}'); do
        mpvpaper --auto-pause --mpv-options="hwdec=auto --no-audio --loop" --fork "$output" "$current_bg"
    done

    wallust run --backend full --skip-sequences "$XDG_CACHE_HOME/$(basename $current_bg).png" &

    swaync-client --reload-css

    prime-run ffmpeg -i "$current_bg" -y -ss 00:00:01 -vframes 1 "$XDG_CACHE_HOME/bg.png" &
    echo $current_bg
    current_bg=$(cat "$XDG_CACHE_HOME/current.bg")
    echo "$wallpappath" > "$XDG_CACHE_HOME/current.bg"
    
    # update hyprlock
    killall -SIGUSR2 hyprlock

    ( prime-run ffmpeg -i "$current_bg" -y -ss 00:00:01 -vframes 1 "$XDG_CACHE_HOME/$(basename $wallpappath).png" && nice -n 20 wallust run --backend full --skip-templates --skip-sequences "$XDG_CACHE_HOME/$(basename $wallpappath).png" ) &

    sleep $DELAY
done
