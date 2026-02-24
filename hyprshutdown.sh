#!/usr/bin/env sh

WAIT=10 # in seconds
self=$$
cancel="Cancel"
confirm="Confirm"

function dialog {
	ans=$(timeout 1.2 hyprland-dialog --apptitle hyprshutdown --title "Shutting down in $1" --buttons "$cancel;$confirm")
	if [[ $ans == $confirm ]]; then
		hyprshutdown
		kill $self
	elif [[ $ans == $cancel ]]; then
		kill $self
	fi
}

for ((i=WAIT; i>=0; i--)); do
	dialog $i &
	sleep 1
done
