#!/bin/zsh
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

kill $(cat $XDG_CACHE_HOME/autoclicker-left.lock) && rm -f $XDG_CACHE_HOME/autoclicker-left.lock && exit 0
( while true; do wlrctl pointer click; sleep $((0.$RANDOM/10)); done ) &
echo $! > $XDG_CACHE_HOME/autoclicker-left.lock
