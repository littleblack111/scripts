#!/usr/bin/bash

mutev=true # stop volume/sound(mute) - comment or un-comment
pmusic=true # stop/start music from playing - command or un-comment


while true; do
    if [[ "$(systemctl is-system-running)" == "running" || "$(systemctl is-system-running)" == "degraded" ]]; then
        if [[ "$(xprintidle)" -gt 600000 && ! -f /var/lock/idle.lock ]]; then  # Changed from 600000 (10 minutes) to 3600000 (1 hour)
            printf "User is afk in %s\n", "$(date)"
            sudo touch /var/lock/idle.lock
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
            script -c "$HOME/scripts/update.sh" $HOME/scripts/logs/auto-updater.log -a --force
            if [ $pmusic ] && [[ $(NekoMC --status) == "Playing" ]]; then
                m=true
            fi
            if [ $pmusic ] && [ $m ]; then
                NekoMC --pause &
            fi
            # killall picom; bspcomp & # paused in freezeapp and unfreezeapp
            freezeapp &
            continue
        elif [[ "$(xprintidle)" -le 100 && -f /var/lock/idle.lock ]]; then
            printf "User is back from afk in %s\n", "$(date)"
            #if [ $mutev ] && [ $soundlevel ]; then
            #    amixer set Master $soundlevel
            #    unset $soundlevel
            #elif [ $mutev ] && [ ! $soundlevel ]; then
            #    notify-send "ERROR: \$soundlevel is not set, unknown sound level..."
            #fi
            if [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
                amixer set Master unmute
            elif [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]]; then
                notify-send -u critical "ERROR: Volume(sound) is not muted"
            elif [ $mutev ] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
                notify-send -u critical "Unable to get volume(sound) status: $(pactl get-sink-mute @DEFAULT_SINK@)"
            fi
            killall update.sh yay
            unfreezeapp &
            if [ $pmusic ] && [ $m ]; then
                NekoMC --play &
                unset m
            fi
            sudo rm -f /var/lock/idle.lock
            continue
        else
            sleep 1
            continue
        fi
    fi
done
