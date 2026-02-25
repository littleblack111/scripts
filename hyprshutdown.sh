#!/usr/bin/bash

WAIT=10 # in seconds
self=$$
cancel="Cancel"
confirm="Confirm"
DUP_ACTION=kill # or shutdown
DUP_AMOUNT=3 # this only matters if its shutdown
SHUTDOWN="hyprshutdown --post-cmd poweroff"

other_pids=$(pidof -x -o $$ "$(basename "$0")")
dup_count=$(echo "$other_pids" | wc -w)

if [[ $DUP_ACTION == "kill" ]]; then
	if [ $dup_count -gt 0 ]; then
		kill $other_pids
	fi
elif [[ $DUP_ACTION == "shutdown" ]]; then
	if [ $dup_count -ge DUP_AMOUNT ]; then
		$SHUTDOWN &!
		kill $other_pids
	fi
fi

function dialog {
	ans=$(timeout 1.2 hyprland-dialog --apptitle hyprshutdown --title "Shutting down in $1" --buttons "$cancel;$confirm")
	if [[ $ans == $confirm ]]; then
		$SHUTDOWN &!
		kill $self
	elif [[ $ans == $cancel ]]; then
		kill $self
	fi
}

for ((i=WAIT; i>=0; i--)); do
	dialog $i &
	sleep 1
done
