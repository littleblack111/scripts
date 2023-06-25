#!/usr/bin/bash


while true; do
    if [[ "$(systemctl is-system-running)" == "running" || "$(systemctl is-system-running)" == "degraded" ]]; then
        if [[ "$(xprintidle)" -gt 600000 && ! -f /var/lock/idle.lock ]]; then  # Changed from 600000 (10 minutes) to 3600000 (1 hour)
            sudo touch /var/lock/idle.lock
            $HOME/scripts/update.sh &
            NekoMC --pause &
            killall picom; bspcomp &
            freezeapp &
            continue
        elif [[ "$(xprintidle)" -le 100 && -f /var/lock/idle.lock ]]; then
            sudo rm -f /var/lock/idle.lock
            killall update.sh yay
            unfreezeapp &
            #NekoMC --play &
            continue
        else
            sleep 1
        fi
    fi
done
