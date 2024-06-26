#!/bin/bash

if [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon4 ]]; then
    printf "fixing hwmon* to hwmon4\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon.*/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input#g' $HOME/.config/polybar/modules.ini
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon3 ]]; then
    printf "fixing hwmon* to hwmon3\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon.*/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input#g' $HOME/.config/polybar/modules.ini
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon5 ]]; then
    printf "fixing hwmon* to hwmon5\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon.*/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input#g' $HOME/.config/polybar/modules.ini
    exit 0
else
    printf "ERROR had occurred\n"
    exit 1
fi
