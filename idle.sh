#!/usr/bin/env bash


while true; do
    if [[ "$(systemctl is-system-running)" == "running" || "$(systemctl is-system-running)" == "degraded" ]]; then
        if [[ "$(xprintidle)" -gt 600000 ]]; then  # Changed from 600000 (10 minutes) to 3600000 (1 hour)
            exec $HOME/scripts/auto-update.sh &
            killall picom; bspcomp &
        else
            sleep 60
        fi
    fi
done
