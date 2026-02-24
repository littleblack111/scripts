#!/usr/bin/bash

renice -n 19 $$
ionice -c 3 -p $$

# arguments with signal trap
#trap idle SIGQUIT
#trap stopidle SIGILL
#trap "kill $$" SIGINT

# sys vars
lockpath="/var/lock"
lockname="idle"
lockpath="$lockpath/$lockname"
lockfile="idle.lck"
pidfile="idle.pid"

# usr-def vars
mutev=true  # stop volume/sound(mute) - comment or un-comment
pmusic=true # stop/start music from playing - command or un-comment
IDLETIME=1800000
IDLEBACKTIME=100

if [ ! -d $lockpath ]; then
	/sbin/echo "Lock path does not exist, creating it"
	sudo -n /sbin/mkdir -vp $lockpath || /sbin/echo "Failed to create lock path at $lockpath"
fi

function cleanup() {
	/sbin/echo "Cleaning up..."
	sudo -n /sbin/rm -rf $lockpath || /sbin/echo "Failed removing locks at $lockpath"
	/sbin/echo "Exiting..."
	exit 0
}

trap cleanup SIGINT SIGTERM

function idle() {
	if [[ -f $lockpath/$disablelockfile ]]; then
		/sbin/echo "idle: Idle is disabled"
	fi
	/sbin/echo "User is idle(afk) in $(date)"
	/sbin/echo "Creating lock file"
	sudo -n /sbin/touch $lockpath/$lockfile || /sbin/echo "Failed to create lock file at $lockpath/$lockfile"
	#if [ $mutev ]; then
	#    soundlevel=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master))
	#    amixer set Master 0%
	#fi
	if [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]]; then
		amixer set Master mute
	elif [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
		notify-send "Warning: Volume is already muted"
	elif [ $mutev ] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
		notify-send -u critical "Unable to get volume(sound) status: $(pactl get-sink-mute @DEFAULT_SINK@)"
	fi
	# script -c "$HOME/scripts/update.sh" /var/log/sysupdate.log -a --force
	script -c 'topgrade -y --no-retry' /var/log/sysupdate.log -a --force

	if [ $pmusic ]; then
		if [[ $(playerctl status -p spotify) == "Playing" ]]; then
			m=true
		fi
	fi
	if [ $pmusic ]; then
		playerctl --all-players pause
	fi
	# re-cache neofetch
	# script -c "$HOME/scripts/neofetchCache.sh" "$HOME"/scripts/logs/neofetchCache.log -a --force
	# clean clipboard history
	# script -c "$HOME/scripts/clearcliphis.sh" "$HOME"/scripts/logs/clearcliphis.log -a --force
	#/sbin/killall picom; bspcomp & # paused in freezeapp and unfreezeapp
	# Disable mouse just in case accidental awake for high DPI rate mouse
	# xinput --disable 12
	freezeapp &
}

function stopidle() {
	if [[ -f $lockpath/$disablelockfile ]]; then
		/sbin/echo "stopidle: Idle is disabled"
	fi
	/sbin/echo "User is back from idle(afk) in $(date)"
	#if [ $mutev ] && [ $soundlevel ]; then
	#    amixer set Master $soundlevel
	#    unset $soundlevel
	#elif [ $mutev ] && [ ! $soundlevel ]; then
	#    notify-send "ERROR: \$soundlevel is not set, unknown sound level..."
	#fi
	# Re-enable mouse
	$HOME/scripts/flipper-ac.py on &
	xinput --enable 12 &
	if [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
		amixer set Master unmute &
	elif [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]]; then
		notify-send -u critical "ERROR: Volume(sound) is not muted" &
	elif [ $mutev ] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
		notify-send -u critical "Unable to get volume(sound) status: $(pactl get-sink-mute @DEFAULT_SINK@)" &
	fi
	/sbin/killall update.sh yay &
	unfreezeapp &
	if [ $pmusic ] && [ "$m" ]; then
		playerctl play -p spotify
		unset m
	fi
	/sbin/echo "Removing lock file"
	sudo -n /sbin/rm -f $lockpath/$lockfile || /sbin/echo "Failed removing lock file at $lockpath/$lockfile"
}

if [ "$1" ]; then
	if [[ "$1" == '-d' || "$1" == '--daemon' ]]; then
		if ! pgrep "$0"; then
			/sbin/echo -n "PID: "
			/sbin/echo $$ | sudo -n /sbin/tee $lockpath/$pidfile || echo "PID Grab failed"
		else
			/sbin/echo "An instance of this program is dectected, please close that instance in order to launch another"
		fi
		while true; do
			if [[ "$(systemctl is-system-running)" == "running" || "$(systemctl is-system-running)" == "degraded" ]]; then
				if [[ "$(xprintidle)" -gt $IDLETIME && ! -f $lockpath/$lockfile && $1 ]]; then # Changed from 600000 (10 minutes) to 3600000 (1 hour)
					idle
					continue
				elif [[ ! -f $lockpath/$lockfile && $1 ]]; then
					sleep 10
					continue
				fi
				if [[ "$(xprintidle)" -le $IDLEBACKTIME && -f $lockpath/$lockfile ]]; then
					stopidle
					continue
				else
					continue
				fi
			fi
		done
	elif [[ "$1" == '--pause' || "$1" == '--idle' ]]; then
		#/sbin/kill -s 3 $(/sbin/cat $lockpath/$pidfile)
		idle
		exit 0
	elif [[ "$1" == '--continue' || "$1" == '--stopidle' ]]; then
		#/sbin/kill -s 4 $(/sbin/cat $lockpath/$pidfile)
		sudo -n /sbin/touch $lockpath/$lockfile
		exit 0
	elif [[ "$1" == '--disable' || "$1" == '-dis' ]]; then
		sudo -n /sbin/touch $lockpath/$disablelockfile
		exit 0
	elif [[ "$1" == '--enable' || "$1" == '-en' ]]; then
		sudo -n /sbin/rm -f $lockpath/$disablelockfile
		exit 0
	fi
fi

/sbin/echo -e "Un-recornized option: '$@', Please use options:\n\t-d|--daemon\tTo start daemon(auto idle actions)\n\t--idle|--pause\tTo call \`idle\` function\n\t--continue|--stopidle\tTo call \`stopidle\` function"
exit 1
