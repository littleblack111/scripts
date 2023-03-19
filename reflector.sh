#!/usr/bin/bash
while true; do
    #sudo #exec sudo /usr/bin/reflector @/etc/xdg/reflector/reflector.conf &
    sudo npm update -g & pipx upgrade-all & yay -Syu --noconfirm --disable-download-timeout && flatpak update -y
    sleep 1080
done
