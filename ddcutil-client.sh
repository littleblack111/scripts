#!/usr/bin/env bash
set -e
dir="${XDG_CACHE_HOME:-$HOME/.cache}"
file="$dir/brightness"
mkdir -p "$dir"
if [[ -f $file ]]; then
	val=$(<"$file")
else
	val=100
fi
case "$1" in
--inc) new=$((val + 5)) ;;
--dec) new=$((val - 5)) ;;
*) exit 1 ;;
esac
((new > 100)) && new=100
((new < 0)) && new=0
ddcutil-client setvcp 10 "$new" &
echo "$new" >"$file"
