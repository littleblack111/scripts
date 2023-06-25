#!/usr/bin/bash
if [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon3 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "fixing hwmon4 to hwmon3\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input#g' /home/system/.config/polybar/modules.ini
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon4 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "fixing hwmon3 to hwmon4\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input#g' /home/system/.config/polybar/modules.ini
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon3 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input" /home/system/.config/polybar/modules.ini) || -e /sys/devices/platform/coretemp.0/hwmon/hwmon4 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "Nothing left to fix\n"
    exit 0
else
    printf "ERROR had occured\n"
    exit 1
fi
