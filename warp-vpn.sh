#!/bin/sh

function status() {
    # warp-cli status | grep -q "Connected" && echo "󰔡" || echo "󰨙"
    tmp=$(warp-cli status)
    if [[ $tmp == *"Connected"* ]]; then
        echo "󰔡"
    elif [[ "$tmp" == *"Connecting"* ]]; then
        echo "󰨚"
        sleep 0.1
        pkill -RTMIN+4 waybar
    elif [[ "$tmp" == *"Disconnected"* ]]; then
        echo "󰨙"
    # else
        # echo "󰨙"
    fi
}

function connect() {
    warp-cli connect && pkill -RTMIN+4 waybar
}

function toggle() {
    warp-cli status | grep -q "Connected" && disconnect || connect
    pkill -RTMIN+4 waybar
}

function disconnect() {
    warp-cli disconnect && pkill -RTMIN+4 waybar
}

if [ "$1" ]; then
    $@
    exit
fi
