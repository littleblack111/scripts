#!/usr/bin/bash

# arguments with signal trap
#trap idle SIGQUIT
#trap stopidle SIGILL
#trap "kill $$" SIGINT

# sys vars
tmplockpath="/var/lock"
lockname="idle"
lockpath="$tmplockpath/$lockname"
lockfile="idle.lck"
pidfile="idle.pid"

# usr-def vars
mutev=true # stop volume/sound(mute) - comment or un-comment
pmusic=true # stop/start music from playing - command or un-comment
IDLETIME=1800000
IDLEBACKTIME=100

if [ ! -d $lockpath ]; then
    /sbin/echo "Lock path does not exist, creating it"
    sudo /sbin/mkdir -vp $lockpath || /sbin/echo "Failed to create lock path at $lockpath"
fi

function idle() {
    if [[ -f $lockpath/$disablelockfile ]]; then
        /sbin/echo "idle: Idle is disabled"
    fi
    printf "User is idle(afk) in %s\n" "$(date)"
    /sbin/echo "Creating lock file"
    sudo /sbin/touch $lockpath/$lockfile || /sbin/echo "Failed to create lock file at $lockpath/$lockfile"
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
    script -c "$HOME/scripts/update.sh" /var/log/sysupdate.log -a --force
    if [ $pmusic ] && [[ $(NekoMC --status) == "Playing" ]]; then
        m=true
    fi
    if [ $pmusic ] && [ "$m" ]; then
        NekoMC --pause &
    fi
    # re-cache neofetch
    # script -c "$HOME/scripts/neofetchCache.sh" "$HOME"/scripts/logs/neofetchCache.log -a --force
    # clean clipboard history
    # script -c "$HOME/scripts/clearcliphis.sh" "$HOME"/scripts/logs/clearcliphis.log -a --force
    #/sbin/killall picom; bspcomp & # paused in freezeapp and unfreezeapp
    # Disable mouse just in case accidental awake for high DPI rate mouse
    xinput --disable 12
    # freezeapp &
}

function stopidle() {
    if [[ -f $lockpath/$disablelockfile ]]; then
        /sbin/echo "stopidle: Idle is disabled"
    fi
    printf "User is back from idle(afk) in %s\n", "$(date)"
    #if [ $mutev ] && [ $soundlevel ]; then
    #    amixer set Master $soundlevel
    #    unset $soundlevel
    #elif [ $mutev ] && [ ! $soundlevel ]; then
    #    notify-send "ERROR: \$soundlevel is not set, unknown sound level..."
    #fi
    # Re-enable mouse
    xinput --enable 12 &
    if [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
        amixer set Master unmute &
    elif [ $mutev ] && [[ $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]]; then
        notify-send -u critical "ERROR: Volume(sound) is not muted" &
    elif [ $mutev ] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: no" ]] && [[ ! $(pactl get-sink-mute @DEFAULT_SINK@) == "Mute: yes" ]]; then
        notify-send -u critical "Unable to get volume(sound) status: $(pactl get-sink-mute @DEFAULT_SINK@)" &
    fi
    /sbin/killall update.sh yay &
    # unfreezeapp &
    if [ $pmusic ] && [ "$m" ]; then
        NekoMC --play &
        unset m
    fi
    /sbin/echo "Removing lock file"
    sudo /sbin/rm -f $lockpath/$lockfile || /sbin/echo "Failed removing lock file at $lockpath/$lockfile"
}

if [ "$1" ]; then
    if [[ "$1" == '-d' || "$1" == '--daemon' ]]; then
        if ! pgrep "$0"; then
            /sbin/printf "PID: "
            /sbin/echo $$ | sudo /sbin/tee $lockpath/$pidfile || echo "PID Grab failed"
        else
            /sbin/printf "An instance of this program is dectected, please close that instance in order to launch another\n"
        fi
        while true; do
            if [[ "$(systemctl is-system-running)" == "running" || "$(systemctl is-system-running)" == "degraded" ]]; then
                if [[ "$(xprintidle)" -gt $IDLETIME && ! -f $lockpath/$lockfile && $1 ]]; then  # Changed from 600000 (10 minutes) to 3600000 (1 hour)
                    idle
                    continue
                elif [[ "$(xprintidle)" -le $IDLEBACKTIME && -f $lockpath/$lockfile ]]; then
                    stopidle
                    continue
                else
                    sleep 1
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
        sudo /sbin/touch $lockpath/$lockfile
        exit 0
    elif [[ "$1" == '--disable' || "$1" == '-dis' ]]; then
        sudo /sbin/touch $lockpath/$disablelockfile
        exit 0
    elif [[ "$1" == '--enable' || "$1" == '-en' ]]; then
        sudo /sbin/rm -f $lockpath/$disablelockfile
        exit 0
    fi
fi

/sbin/printf "Un-recornized option: '$@', Please use options:\n\t-d|--daemon\tTo start daemon(auto idle actions)\n\t--idle|--pause\tTo call \`idle\` function\n\t--continue|--stopidle\tTo call \`stopidle\` function\n"
exit 1
