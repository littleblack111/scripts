#!/bin/bash

workspace=$(hyprctl clients -j | jq -r '.[] | select(.class == "Spotify") | .workspace.name')

if [ -z $workspace ]; then
    hyprctl dispatch exec [workspace +0, noinitialfocus] LD_PRELOAD=/usr/lib/spotify-adblock.so spotify
    workspace=7
fi


if [ $workspace -eq 7 ]; then
    hyprctl --batch 'dispatch setfloating class:Spotify; dispatch movetoworkspace +0, class:Spotify'
else
    hyprctl --batch 'dispatch settiled class:Spotify; dispatch movetoworkspacesilent 7, class:Spotify'
fi
