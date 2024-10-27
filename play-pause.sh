#!/bin/bash

if hyprctl activewindow | grep 'class: zen-alpha' > /dev/null; then
    playerctl -p spotify play-pause
elif [[ "$(playerctl status firefox)" == "Playing" ]]; then
    playerctl --all-players pause
else
    playerctl -p spotify play-pause
fi

