#!/usr/bin/bash

WAIT=10 # in seconds
SELF=$$
CANCEL="Cancel"
CONFIRM="Confirm"
DUP_ACTION=reboot # or shutdown or reboot
DUP_AMOUNT=2 # this only matters if its shutdown or reboot
# maybe add hyprsession --save or whatever thats called to restore prev apps
SHUTDOWN="hyprshutdown --post-cmd poweroff"
REBOOT="hyprshutdown --post-cmd reboot"
# default
ACTION=Shutdown

other_pids=$(pidof -x -o $$ "$(basename "$0")")
dup_count=$(echo "$other_pids" | wc -w)

# kill dialog RAII
trap 'kill -- -$$' EXIT

function exec_action {
	if [[ $ACTION == "Shutdown" ]]; then
		$SHUTDOWN &!
	elif [[ $ACTION == "Reboot" ]]; then
		$REBOOT &!
	fi
	kill $SELF
}

function dialog {
	ans=$(timeout 1.2 hyprland-dialog --apptitle hyprshutdown --title "$ACTION in $1" --buttons "$CANCEL;$CONFIRM")
	if [[ $ans == $CONFIRM ]]; then
		exec_action
	elif [[ $ans == $CANCEL ]]; then
		kill $SELF
	fi
}

if [[ $DUP_ACTION == "kill" ]]; then
	if [ $dup_count -gt 0 ]; then
		kill $other_pids
	fi
elif [[ $DUP_ACTION == "shutdown" ]]; then
	if [ $dup_count -ge $DUP_AMOUNT ]; then
		kill $other_pids
		exec_action
	fi
elif [[ $DUP_ACTION == "reboot" ]]; then
	if [ $dup_count -ge $DUP_AMOUNT ]; then
		kill $other_pids
		ACTION=Reboot
	fi
fi

for ((i=WAIT; i>=0; i--)); do
	dialog $i &
	sleep 1
done
