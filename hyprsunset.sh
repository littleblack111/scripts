#!/bin/bash

renice -n 19 $$
ionice -c 3 -p $$

# NIGHT_GAMMA=95
NIGHT_TEMP=5500
NORMAL_TEMP=6000
SUNRISE_HOUR=6
SUNSET_HOUR=20

apply_settings() {
  current_hour=$(date +%H | sed 's/^0//')
  
  if [ $current_hour -ge $SUNRISE_HOUR -a $current_hour -lt $SUNSET_HOUR ]; then
    echo "Applying day settings"
    # hyprctl hyprsunset identity
    hyprctl hyprsunset temperature $NORMAL_TEMP
  else
    echo "Applying night settings"
    # hyprctl hyprsunset gamma $NIGHT_GAMMA
    hyprctl hyprsunset temperature $NIGHT_TEMP
  fi
}

calculate_sleep_time() {
  current_hour=$(date +%H | sed 's/^0//')
  current_min=$(date +%M | sed 's/^0//')
  
  if [ $current_hour -ge $SUNRISE_HOUR -a $current_hour -lt $SUNSET_HOUR ]; then
    hours_until_sunset=$((SUNSET_HOUR - current_hour - 1))
    mins_until_sunset=$((60 - current_min))
    sleep_seconds=$(( (hours_until_sunset * 3600) + (mins_until_sunset * 60) ))
  else
    if [ $current_hour -lt $SUNRISE_HOUR ]; then
      hours_until_sunrise=$(($SUNRISE_HOUR - $current_hour - 1))
      mins_until_sunrise=$((60 - $current_min))
    else
      hours_until_sunrise=$(($SUNRISE_HOUR + 24 - $current_hour - 1))
      mins_until_sunrise=$((60 - $current_min))
    fi
    sleep_seconds=$(( (hours_until_sunrise * 3600) + (mins_until_sunrise * 60) ))
  fi
  
  echo $sleep_seconds
}

while true; do
  if [ ! -d /run/user/$UID/hypr/hyprsunset ]; then
    echo "Hyprsunset not running, running it via hyprctl dispatch"
    hyprctl dispatch execr hyprsunset
  fi
  apply_settings
  sleep_time=$(calculate_sleep_time)
  
  printf "Sleeping for %d hours and %d minutes (%d seconds)\n" $((sleep_time / 3600)) $(((sleep_time % 3600) / 60)) $sleep_time
  
  sleep $sleep_time
done
