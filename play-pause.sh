#!/bin/bash

WORKSPACE=$(hyprctl activeworkspace -j | jq '.id')
WWORKSPACE=$(hyprctl clients -j | jq -r '.[] | select(.class == "zen-beta") | .workspace.name')

while IFS= read -r line; do
    if [[ "$line" == "$WORKSPACE" ]]; then
        ACTIVE=true
        break
    fi
done < <(echo "$WWORKSPACE")

if [ $ACTIVE ]; then
    playerctl -p spotify play-pause
elif [[ "$(playerctl status firefox)" == "Playing" ]]; then
    playerctl --all-players pause
else
    playerctl -p spotify play-pause
fi

