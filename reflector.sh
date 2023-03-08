#!/usr/bin/env sh
while true; do
    sudo /usr/bin/reflector @/etc/xdg/reflector/reflector.conf
    update
    sleep 1080
done
