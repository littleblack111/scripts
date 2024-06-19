#!/usr/bin/bash
if [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon5 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "fixing hwmon4 to hwmon5\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input#g' /home/system/.config/polybar/modules.ini
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon4 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "fixing hwmon5 to hwmon4\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input#g' /home/system/.config/polybar/modules.ini
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon3 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "fixing hwmon4 to hwmon3\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input#g' /home/system/.config/polybar/modules.ini
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon3 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "fixing hwmon5 to hwmon3\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input#g' /home/system/.config/polybar/modules.ini
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon3 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "fixing hwmon6 to hwmon3\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input#g' /home/system/.config/polybar/modules.ini
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon3 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon7/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "fixing hwmon7 to hwmon3\n"
    sed -i 's#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon7/temp1_input#hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input#g' /home/system/.config/polybar/modules.ini
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon5 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "hwmon5 is already set\n"
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon4 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "hwmon4 is already set\n"
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon3 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "hwmon3 is already set\n"
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon6 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "hwmon6 is already set\n"
    exit 0
elif [[ -e /sys/devices/platform/coretemp.0/hwmon/hwmon7 && $(grep -i "hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon7/temp1_input" /home/system/.config/polybar/modules.ini) ]]; then
    printf "hwmon7 is already set\n"
    exit 0
else
    printf "ERROR had occured\n"
    exit 1
fi
