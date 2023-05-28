#!/usr/bin/env bash

notify-send "Auto-Updater" "Update in progress, please don't poweroff the computer" && sudo npm update -g & nix-env -u & brew update & yay -Sl > /tmp/yaySl & yay -Syu --noconfirm --disable-download-timeout && flatpak update -y && notify-send -u low "Auto-Updater" "Update Successfully!" && echo \#sleep 3600 || notify-send -u critical "Auto-Updater" "Update Faild!" # pipx upgrade-all
