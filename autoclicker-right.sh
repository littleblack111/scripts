#!/bin/sh
if [ -f /var/lock/autoclicker-right.lock ]; then
    killall autoclicker-right
    sudo rm -f /var/lock/autoclicker-right.lock
elif [ ! -f /var/lock/autoclicker-right.lock ]; then
    autoclicker-right &
    sudo touch /var/lock/autoclicker-right.lock
fi
