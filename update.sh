#!/usr/bin/bash

if [ -f /var/lib/pacman/db.lck ]; then
    notify-send "db.lck exist, waiting 1 min until rm -f"
    sleep 60
    if [ -f /var/lib/pacman/db.lck ]; then
        sudo rm -f /var/lib/pacman/db.lck
    fi
fi
notify-send "Auto-Updater" "Update in progress, please don't poweroff the computer" && sudo npm update -g & nix-env -u & brew update & yay -Sl > /tmp/yaySl & yay -Syu --noconfirm --disable-download-timeout && flatpak update -y && notify-send -u low "Auto-Updater" "Update Successfully!" || notify-send -u critical "Auto-Updater" "Update Faild!" # pipx upgrade-all
