#!/bin/sh

XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_VIDEOS_DIR=${XDG_VIDEOS_DIR:-$HOME/Videos}

function status() {
    pstatus=$(cat $XDG_CACHE_HOME/rec_paused)
    if [ "$pstatus" == "true" ]; then
        echo ""
        exit
    fi
    n=0
    while ! pgrep -f gpu-screen-recorder >/dev/null; do
        if [ $n -eq 3 ]; then
            echo ""
            exit
        fi
        (( n+=1 ))
    done
    echo ""
}

function recorder() {
    killall -SIGINT gpu-screen-recorder && filename=$(cat $XDG_CACHE_HOME/rec_filename) && (dragon --icon-only --thumb-size 512 --and-exit "$XDG_VIDEOS_DIR/$filename" & sleep 10 && kill $!) && exit 1
    filename=$(date +"%Y-%m-%d_%H:%M:%S").mp4
    echo '' > $XDG_CACHE_HOME/rec_filename
    echo 'false' > $XDG_CACHE_HOME/rec_paused
    gpu-screen-recorder -w screen -restore-portal-session yes -q ultra -oc yes -cr full -f 160 -o $XDG_VIDEOS_DIR/"$filename" && echo "$filename" > $XDG_CACHE_HOME/rec_filename
    # reload module
    pkill -RTMIN+3 waybar
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
