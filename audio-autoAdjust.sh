#!/usr/bin/bash

renice -n 19 $$

# sys-def vars
# DO NOT TOUCH
VOL=0
STATE=1

# usr-def vars
OTHERPLAYER_MUSIC_PERCENTAGE=35
NORMAL_MUSIC_PLAYER_PERCENTAGE=50

function getMusicId() {
    pulsemixer --list-sink | grep 'Name: spotify' | awk '{print $4}' | sed 's/,$//'
}

function getVideoId() {
    pulsemixer --list-sink | grep 'Name: Chromium' | awk '{print $4}' | sed 's/,$//'
}

function lower_music() {
    pulsemixer --id "$(getMusicId)" --set-volume $OTHERPLAYER_MUSIC_PERCENTAGE
}

function normal_music() {
    pulsemixer --id "$(getMusicId)" --set-volume $NORMAL_MUSIC_PLAYER_PERCENTAGE
}

if [ "$1" ]; then
    if [[ "$1" == '--help' || "$1" == '-h' ]]; then
        /sbin/echo -e "Usage: $0 [OPTION]\n\nOptions:\n\t-l|--lower\tTo lower music volume\n\t-n|--normal\tTo set music volume to normal"
        exit 0
    elif [[ "$1" == '--daemon' || "$1" == '-d' ]]; then
        while true; do
            if [[ "$(systemctl is-system-running)" == "running" || "$(systemctl is-system-running)" == "degraded" ]]; then
                if [ $(getVideoId) ]; then
                    if [ $STATE -eq 0 ]; then
                        STATE=1
                        echo VideoDetected
                        lower_music
                    fi
                elif [ $(getMusicId) ] && [ $STATE -eq 1 ]; then
                    STATE=0
                    echo VideoGone
                    normal_music
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
