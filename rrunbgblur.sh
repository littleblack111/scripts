#!/usr/bin/zsh

while true; do
    exec $HOME/scripts/runbgblur.sh &
    sleep 1800
done
