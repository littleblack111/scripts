#!/usr/bin/bash

renice -n 19 $$

# sys-def vars
# DO NOT TOUCH
VOL=0
STATE=1

# usr-def vars
OTHERPLAYER_MUSIC_PERCENTAGE=45
NORMAL_MUSIC_PLAYER_PERCENTAGE=60

function lower_music() {
    for ((i=$NORMAL_MUSIC_PLAYER_PERCENTAGE; i>=$OTHERPLAYER_MUSIC_PERCENTAGE; i--)); do
        playerctl -p spotify volume 0.$i
        sleep 0.01
    done
}

function normal_music() {
    for ((i=$OTHERPLAYER_MUSIC_PERCENTAGE; i<=$NORMAL_MUSIC_PLAYER_PERCENTAGE; i++)); do
        playerctl -p spotify volume 0.$i
        sleep 0.01
    done
}

if [ "$1" ]; then
    if [[ "$1" == '--help' || "$1" == '-h' ]]; then
        /sbin/echo -e "Usage: $0 [OPTION]\n\nOptions:\n\t-l|--lower\tTo lower music volume\n\t-n|--normal\tTo set music volume to normal"
        exit 0
    elif [[ "$1" == '--daemon' || "$1" == '-d' ]]; then
        while true; do
            if [[ "$(systemctl is-system-running)" == "running" || "$(systemctl is-system-running)" == "degraded" ]]; then
                if [[ $(playerctl status -p chromium) == "Playing" ]]; then
                    if [ $STATE -eq 0 ]; then
                        STATE=1
                        echo VideoDetected
                        lower_music
                    fi
                elif [[ $(playerctl status -p spotify) == "Playing" ]]; then
                    if [ $STATE -eq 1 ]; then
                        STATE=0
                        echo VideoGone
                        normal_music
                    fi
                else
                    sleep 5
                fi
                sleep 1
            fi
        done
        exit 0
    elif [[ "$1" == '--lower' || "$1" == '-l' ]]; then
        lower_music
        exit 0
    elif [[ "$1" == '--normal' || "$1" == '-n' ]]; then
        normal_music
        exit 0
    fi
fi

/sbin/echo -e "Un-recornized option: '$@', Please use options:\n\t-l|--lower\tTo lower music volume\n\t-n|--normal\tTo set music volume to normal"
exit 1
