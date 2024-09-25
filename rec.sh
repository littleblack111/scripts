#!/bin/sh

XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_VIDEOS_DIR=${XDG_VIDEOS_DIR:-$HOME/Videos}

function status() {
    pstatus=$(cat $XDG_CACHE_HOME/rec_paused)
    if [ "$pstatus" == "true" ]; then
        echo ""
        exit
    fi
    if pgrep -f gpu-screen-recorder >/dev/null; then
        echo ""
    else
        echo ""
    fi
}

function recorder() {
    if pgrep -f gpu-screen-recorder>/dev/null; then
        killall -SIGINT gpu-screen-recorder || exit 1
        # reload module
        pkill -RTMIN+3 waybar
    else
        gpu-screen-recorder -w screen -restore-portal-session yes -q ultra -oc yes -cr full -f 160 -o $XDG_VIDEOS_DIR/$(date +"%Y-%m-%d_%H:%M:%S").mp4
        # reload module
        pkill -RTMIN+3 waybar
    fi
}

function pause() {
    killall -SIGUSR2 gpu-screen-recorder || exit 1
    pstatus=$(cat $XDG_CACHE_HOME/rec_paused)
    if [ "$pstatus" == "true" ]; then
        echo "false" > $XDG_CACHE_HOME/rec_paused
    else
        echo "true" > $XDG_CACHE_HOME/rec_paused
    fi
    # reload module
    pkill -RTMIN+3 waybar
}

if [ "$1" ]; then
    $@
fi
