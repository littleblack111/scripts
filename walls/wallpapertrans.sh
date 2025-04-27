#!/bin/bash
# Animated wallpaper changer
feh --bg-fill $XDG_CACHE_HOME/wallpaper/old.jpg

DISPLAY=:0
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
WALLPAPERS="$XDG_PICTURES_DIR/wallpapers/"
wallpappath=$(find "$WALLPAPERS" | shuf -n 1)
cp "$wallpappath" $XDG_CACHE_HOME/wallpaper/old.jpg
hyprctl hyprpaper preload "$wallpappath"
echo "$wallpappath" > "$XDG_CACHE_HOME/current.bg"

DELAY=0.005
QUALITY=0.000001
RESIZE=30%


if [ $# -ne 1 ]; then
    for i in {7..11}; do
        convert "$wallpappath" -resize $RESIZE -fill black -blur $((75 - ($i - 7) * 15))% -fill black -colorize $((75 - ($i - 7) * 15))% -quality $QUALITY /tmp/transition${i}.jpg &
        hyprctl hyprpaper preload "/tmp/transition${i}.jpg"
    done
    for i in {1..11}; do
        # feh --bg-fill /tmp/transition${i}.jpg
        hyprctl hyprpaper wallpaper ", /tmp/transition${i}.jpg"
        sleep $DELAY
    done
    rm /tmp/transition*.jpg
fi

feh --bg-fill "$wallpappath"

# cp "$wallpappath" $HOME/.cache/wallpaper/old.jpg

hyprctl hyprpaper unload all

for i in {1..6}; do
    convert $HOME/.cache/wallpaper/old.jpg -resize $RESIZE -fill black -blur $(($i * 10))% -fill black -colorize $(($i * 10))% -quality $QUALITY /tmp/transition${i}.jpg &
    hyprctl hyprpaper preload "/tmp/transition${i}.jpg"
done
