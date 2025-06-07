#!/usr/bin/bash

# check if db.lck exist(other instant exist) and deal with it
if [ -f /var/lib/pacman/db.lck ]; then
    notify-send "db.lck exist, waiting 1 min until rm -f"
    sleep 60
    if [ -f /var/lib/pacman/db.lck ]; then
        notify-send "db.lck still exist, forcfully removing..."
        sudo -n rm -f /var/lib/pacman/db.lck
    fi
fi

tldr --update & sudo -n npm update -g & nix-env -u & /usr/local/linuxbrew/bin/brew update & blck=$! & yay -Sl > /tmp/yaySl & yay -Ss > /tmp/yaySs & yay --noconfirm --disable-download-timeout & wait $blck && /opt/homebrew/bin/brew upgrade & flatpak update -y  & tldr -u|| sudo -n /sbin/touch /tmp/lock/updatefail.lock # notify-send -u critical "Auto-Updater" "Update Faild!" # pipx upgrade-all
#notify-send "Auto-Updater" "Update in progress, please don't poweroff the computer" && sudo npm update -g & nix-env -u & /usr/local/linuxbrew/bin/brew update & /usr/local/linuxbrew/bin/brew upgrade & yay -Sl > /tmp/yaySl & yay -Ss > /tmp/yaySs & yay -Syu --noconfirm --disable-download-timeout && notify-send -u low "Auto-Updater" "Update Successfully!" || notify-send -u critical "Auto-Updater" "Update Faild!" # pipx upgrade-all
