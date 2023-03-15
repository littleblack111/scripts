#!/bin/bash

# Maximum CPU temperature in degrees Celsius
MAX_TEMP=180

# Maximum time in seconds that the system can be frozen
MAX_FROZEN_TIME=300

# Check the CPU temperature
TEMP=$(sensors | grep 'Core 0:' | awk '{print $3}' | cut -c2-3)
if [ $TEMP -ge $MAX_TEMP ]; then
    echo "CPU temperature is too high. Rebooting..."
    /sbin/reboot
fi

# Check if the system is frozen
LAST_LOAD=$(uptime | awk '{print $NF}')
if [ $LAST_LOAD -gt $MAX_FROZEN_TIME ]; then
    echo "System is frozen. Rebooting..."
    /sbin/reboot
fi
