#!/bin/sh
if [ -f /var/lock/autoclicker-left.lock ]; then
    killall autoclicker-left
    sudo rm -f /var/lock/autoclicker-left.lock
elif [ ! -f /var/lock/autoclicker-left.lock ]; then
    autoclicker-left &
    sudo touch /var/lock/autoclicker-left.lock
fi
