#!/usr/bin/bash

renice -n 19 $$

# arguments with signal trap
#trap idle SIGQUIT
#trap stopidle SIGILL
#trap "kill $$" SIGINT

# usr-def vars
mutev=true # stop volume/sound(mute) - comment or un-comment
pmusic=true # stop/start music from playing - command or un-comment

function idle() {
    /sbin/echo "User is idle(afk) in $(date)"
    #if [ $mutev ]; then
    #    soundlevel=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master))
    #    amixer set Master 0%
    #fi
    if [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]]; then
        amixer set Master mute
    elif [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
        notify-send "Warning: Volume is already muted"
    elif [ $mutev ] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
        notify-send -u critical "Unable to get volume(sound) status: $(pactl get-sink-mute @DEFAULT_SINK@)"
    fi
    # script -c "$HOME/scripts/update.sh" /var/log/sysupdate.log -a --force
    script -c 'topgrade -y --no-retry' /var/log/sysupdate.log -a --force

    if [ $pmusic ]; then
        if [[ $(playerctl status -p spotify) == "Playing" ]]; then
            m=true
        fi
    fi
    if [ $pmusic ]; then
        playerctl --all-players pause
    fi
}

function stopidle() {
    /sbin/echo "User is back from idle(afk) in $(date)"
    #if [ $mutev ] && [ $soundlevel ]; then
    #    amixer set Master $soundlevel
    #    unset $soundlevel
    #elif [ $mutev ] && [ ! $soundlevel ]; then
    #    notify-send "ERROR: \$soundlevel is not set, unknown sound level..."
    #fi
    # Re-enable mouse
    xinput --enable 12 &
    if [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
        amixer set Master unmute &
    elif [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]]; then
        notify-send -u critical "ERROR: Volume(sound) is not muted" &
    elif [ $mutev ] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
        notify-send -u critical "Unable to get volume(sound) status: $(pactl get-sink-mute @DEFAULT_SINK@)" &
    fi
    /sbin/killall update.sh yay &
    if [ $pmusic ] && [ "$m" ]; then
        playerctl play -p spotify
        unset m
    fi
}

if [ "$1" ]; then
    if [[ "$1" == '--pause' || "$1" == '--idle' ]]; then
        idle
        exit 0
    elif [[ "$1" == '--continue' || "$1" == '--stopidle' ]]; then
        exit 0
    fi
fi

/sbin/echo -e "Un-recornized option: '$@', Please use options:\n\t-d|--daemon\tTo start daemon(auto idle actions)\n\t--idle|--pause\tTo call \`idle\` function\n\t--continue|--stopidle\tTo call \`stopidle\` function"
exit 1
