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

    # script -c "$HOME/scripts/update.sh" /var/log/sysupdate.log -a --force
    # script -c 'topgrade -y --no-retry' /var/log/sysupdate.log -a --force
    # topgrade -y --no-retry &
    checkupdates --download &
    # killall -STOP hyprpaper.sh
    # killall -STOP swww.sh
    brillo -O
    brillo -S 0
    # turn off debug overlay just in case we forget
    hyprctl keyword debug:overlay false
    killall -STOP mpvpaper.sh mpvpaper $(pgrep -P $(pgrep mpvpaper.sh))

    # sleep 30
    if [ $mutev ] && [[ "$(wpctl get-volume @DEFAULT_AUDIO_SINK@)" != *"[MUTED]" ]]; then
      wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
    elif [ $mutev ] && [[ "$(wpctl get-volume @DEFAULT_AUDIO_SINK@)" == *"[MUTED]" ]]; then
        notify-send "Warning: Volume is already muted"
    elif [ $mutev ]; then
        notify-send -u critical "Unable to get volume(sound) status: $(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
    fi

    if [ $pmusic ]; then
        PLAYERS_FILE="$XDG_CACHE_HOME/players"
        > "$PLAYERS_FILE"  # Clear/create the file
        for player in $(playerctl --list-all); do
            if [[ $(playerctl -p "$player" status 2>/dev/null) == "Playing" ]]; then
                echo "$player" >> "$PLAYERS_FILE"
            fi
        done
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
    # killall wallust mpvpaper.sh & $HOME/scripts/mpvpaper.sh &
    killall wallust &
    killall -CONT mpvpaper.sh mpvpaper $(pgrep -P $(pgrep mpvpaper.sh))
    if [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
      wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 &
    # elif [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]]; then
        # notify-send -e -u critical "ERROR: Volume is not muted" &
    # elif [ $mutev ] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
        # notify-send -e -u critical "Unable to get volume status: $(pactl get-sink-mute @DEFAULT_SINK@)" &
    fi
    /sbin/killall update.sh yay &
    if [ $pmusic ]; then
        PLAYERS_FILE="$XDG_CACHE_HOME/players"
        if [ -f "$PLAYERS_FILE" ]; then
            while IFS= read -r player; do
                playerctl -p "$player" play 2>/dev/null
            done < "$PLAYERS_FILE"
            rm -f "$PLAYERS_FILE"
        fi
    fi
    # killall -CONT hyprpaper.sh || $HOME/scripts/hyprpaper.sh &
    # killall -CONT swww.sh || $HOME/scripts/swww.sh &
    rm -f $XDG_CACHE_HOME/playing-music
    brillo -I
    if [[ "$(swaync-client --get-dnd)" == "true" ]]; then
        # notify-send -e 'Do not Disturb' 'Do not Disturb is still enabled'
        hyprctl notify 2 3000 0 "Do not Disturb is still enabled"
    fi
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
