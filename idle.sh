#!/usr/bin/bash


while true; do
    if [[ "$(systemctl is-system-running)" == "running" || "$(systemctl is-system-running)" == "degraded" ]]; then
        if [[ "$(xprintidle)" -gt 600000 ]]; then  # Changed from 600000 (10 minutes) to 3600000 (1 hour)
            if [ ! -f /var/lock/idle.lock ]; then
                sudo touch /var/lock/idle.lock
                $HOME/scripts/update.sh &
                killall picom; bspcomp &
                sleep 350
                killall update.sh
            elif [[ "$(xprintidle)" -le 100 ]]; then
                sudo rm -f /var/lock/idle.lock
                continue
            else
                sleep 5
            fi
        else
            sleep 60
        fi
    fi
done
