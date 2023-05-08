#!/usr/bin/env bash


while true; do
    if [[ "$(systemctl is-system-running)" == "running" ]]; then
        if [[ "$(xprintidle)" -gt 600000 ]]; then  # Changed from 600000 (10 minutes) to 3600000 (1 hour)
            #sudo #exec sudo /usr/bin/reflector @/etc/xdg/reflector/reflector.conf &
            notify-send "Auto-Updater" "Update in progress, please don't poweroff the computer" && sudo npm update -g & nix-env -u & yay -Syu --noconfirm --disable-download-timeout && flatpak update -y && notify-send -u low "Auto-Updater" "Update Successfully!" && echo \#sleep 3600 || notify-send -u critical "Auto-Updater" "Update Faild!" # pipx upgrade-all
        else
            sleep 60
        fi
    fi
done
