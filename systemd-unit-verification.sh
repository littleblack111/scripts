#!/usr/bin/bash

if [[ "$(systemctl is-system-running)" == "degraded" ]]; then
    notify-send -u critical "ALERT: SYSTEMD UNITS DID NOT INITILIZE CORRECTLY, PLEASE CHECK systemctl --failed --all and journalctl to see more"
fi
