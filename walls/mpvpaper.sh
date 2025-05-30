#!/bin/bash

renice -n 19 $$
ionice -c 3 -p $$

XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
WALLPAPERS="$XDG_VIDEOS_DIR/wallpapers/"
# swwwarg="--transition-type random --transition-duration 0.85 --transition-fps 160 --transition-bezier 1,0.33,0.3,1"

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

DELAY=1800

while true; do
  # (while ! swww query; do swww-daemon; done) &
  current_bg="$(cat $XDG_CACHE_HOME/current.bg)"
  if ! [ "$current_bg" ]; then
      echo -e "${RED}current.bg not set, regenerating it${NC}"
      current_bg="$(find "$WALLPAPERS" | shuf -n 1)"
      echo "$current_bg" > $XDG_CACHE_HOME/current.bg
      echo -e "${GREEN}Regenerating wallpappath${NC}"
  fi
  wallpappath=$(find "$WALLPAPERS" | shuf -n 1)

  if [ ! -f "$XDG_CACHE_HOME/$(basename "$current_bg").png" ]; then ffmpeg -hwaccel cuda -i "$current_bg" -y "$XDG_CACHE_HOME/$(basename $current_bg).png"; fi

  # wallust run --skip-sequences $current_bg
  # wallust run --backend kmeans --skip-sequences $current_bg & # using cache now
  # swww img "$XDG_CACHE_HOME/$(basename "$current_bg").png" $swwwarg
  # for output in $(hyprctl monitors | grep "Monitor" | awk '{print $2}'); do
      # mpvpaper --auto-pause --mpv-options="hwdec=auto --no-audio --loop" --fork "$output" "$current_bg"

  OLD_MPVPAPER_PIDS=$(pidof mpvpaper)
  mpvpaper --auto-pause --mpv-options="hwdec=auto --no-audio --loop --mute" --fork "*" "$current_bg"

  # Wait a brief moment to ensure new instance is running
  sleep 0.1

  # Kill old instances if they exist
  if [ -n "$OLD_MPVPAPER_PIDS" ]; then
      for pid in $OLD_MPVPAPER_PIDS; do
          kill $pid 2>/dev/null
      done
  fi

  # done

  # Update theme and configurations for current wallpaper
  nice -n 20 bash "$(dirname "$0")/update.sh" "$current_bg"

  # Store next wallpaper path
  echo "$wallpappath" > "$XDG_CACHE_HOME/current.bg"

  # Generate cache for next wallpaper in background
  ( nice -n 20 bash "$(dirname "$0")/update.sh" "$wallpappath" ) &

  nice -n 20 sleep $DELAY
done
