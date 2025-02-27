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

  if [ ! -f "$XDG_CACHE_HOME/$(basename "$current_bg").png" ]; then ffmpeg -hwaccel cuda -i "$current_bg" -y "$XDG_CACHE_HOME/$(basename $current_bg).png" > /dev/null || echo -e "${RED}Generation of static background image failed${NC}"; fi

  # wallust run --skip-sequences $current_bg
  # wallust run --backend kmeans --skip-sequences $current_bg & # using cache now
  # swww img "$XDG_CACHE_HOME/$(basename "$current_bg").png" $swwwarg
  # for output in $(hyprctl monitors | grep "Monitor" | awk '{print $2}'); do
      # mpvpaper --auto-pause --mpv-options="hwdec=auto --no-audio --loop" --fork "$output" "$current_bg"

  OLD_MPVPAPER_PIDS=$(pgrep mpvpaper)
  ( while ! ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "/tmp/wall.mp4" > /dev/null 2>&1; do ffmpeg -hwaccel cuda -i "$wallpappath" -filter_complex "[0]trim=end=1,setpts=PTS-STARTPTS[begin];[0]trim=start=1,setpts=PTS-STARTPTS[end];[end][begin]xfade=fade:duration=0.5:offset=8.5" -c:v libx264 -profile:v main -pix_fmt yuv420p -y /tmp/wall.mp4 > /dev/null; done )
  mpvpaper --auto-pause --mpv-options="hwdec=auto --no-audio --loop --mute" --fork "*" "/tmp/wall.mp4"

  # Wait a brief moment to ensure new instance is running
  sleep 0.1

  # Kill old instances if they exist
  if [ -n "$OLD_MPVPAPER_PIDS" ]; then
      for pid in $OLD_MPVPAPER_PIDS; do
        if [[ $pid != $$ ]]; then
          ( kill $pid 2>/dev/null & sleep 2 && kill -9 $pid 2>/dev/null ) &
        fi
      done
  fi

  # done

  wallust run --backend full --skip-sequences "$XDG_CACHE_HOME/$(basename "$current_bg").png"

  # tell hypr* where is bg
  echo "\$bg = $XDG_CACHE_HOME/$(basename "$current_bg").png" > "$XDG_CONFIG_HOME/hypr/bg.conf"

  # reload hyprland
  hyprctl reload config-only &

  swaync-client --reload-css & # & pywalfox update

  gdbus call --session --dest com.mitchellh.ghostty --object-path /com/mitchellh/ghostty --method org.gtk.Actions.Activate reload-config [] [] &

  # update hyprlock
  killall -USR2 hyprlock &

  # next wallpaper
  # ffmpeg -hwaccel cuda -i "$current_bg" -y "$XDG_CACHE_HOME/bg.png"
  current_bg=$(cat "$XDG_CACHE_HOME/current.bg")
  echo "$wallpappath" > "$XDG_CACHE_HOME/current.bg"

  # generates cache for next wallpaper
  ( ffmpeg -hwaccel cuda -i "$wallpappath" -y "$XDG_CACHE_HOME/$(basename $wallpappath).png"; nice -n 20 wallust run --backend full --skip-templates --skip-sequences "$XDG_CACHE_HOME/$(basename $wallpappath).png" > /dev/null ) &
  # sleep 10 to ensure mpvpaper already get the wall
  ( sleep 3; rm -f /tmp/wall.mp4 && while ! ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "/tmp/wall.mp4" > /dev/null 2>&1; do ffmpeg -hwaccel cuda -i "$wallpappath" -filter_complex "[0]trim=end=1,setpts=PTS-STARTPTS[begin];[0]trim=start=1,setpts=PTS-STARTPTS[end];[end][begin]xfade=fade:duration=0.5:offset=8.5" -c:v libx264 -profile:v main -pix_fmt yuv420p /tmp/wall.mp4; done ) &
  nice -n 20 sleep $DELAY
done
