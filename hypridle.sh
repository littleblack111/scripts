#!/usr/bin/bash

renice -n 19 $$
ionice -c 3 -p $$

XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

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
    # script -c 'topgrade -y --no-retry' /var/log/sysupdate.log -a --force
    topgrade -y --no-retry

    if [ $pmusic ]; then
        if [[ $(playerctl status -p spotify) == "Playing" ]]; then
            touch $XDG_CACHE_HOME/playing-music
        fi
        playerctl --all-players pause
    fi
    # killall -STOP hyprpaper.sh
    # killall -STOP swww.sh
    brillo -O
    brillo -S 0
    # turn off debug overlay just in case we forget
    hyprctl keyword debug:overlay false
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
    if [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
        amixer set Master unmute &
    elif [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]]; then
        notify-send -u critical "ERROR: Volume(sound) is not muted" &
    elif [ $mutev ] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
        notify-send -u critical "Unable to get volume(sound) status: $(pactl get-sink-mute @DEFAULT_SINK@)" &
    fi
    /sbin/killall update.sh yay &
    if [ $pmusic ] && [ -f $XDG_CACHE_HOME/playing-music ]; then
        playerctl play -p spotify
    fi
    # killall -CONT hyprpaper.sh || $HOME/scripts/hyprpaper.sh &
    # killall -CONT swww.sh || $HOME/scripts/swww.sh &
    rm -f $XDG_CACHE_HOME/playing-music
    brillo -I
}

if [ "$1" ]; then
    if [[ "$1" == '--pause' || "$1" == '--idle' ]]; then
        idle
        exit 0
    elif [[ "$1" == '--continue' || "$1" == '--stopidle' ]]; then
        stopidle
        exit 0
    fi
fi

/sbin/echo -e "Un-recornized option: '$@', Please use options:\n\t-d|--daemon\tTo start daemon(auto idle actions)\n\t--idle|--pause\tTo call \`idle\` function\n\t--continue|--stopidle\tTo call \`stopidle\` function"
exit 1
