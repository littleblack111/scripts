#!/bin/bash

XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

function prepsound() {
    tDIR=$XDG_CACHE_HOME/stoggle

    if [ ! -d $tDIR ]; then
        mkdir -p $tDIR || exit 1
    fi
    sDIR=/usr/share/sounds/freedesktop/stereo
}

function playSound() {
    if [ ! $sDIR ]; then
        echo Warning: Sound directory not set, setting to default
        prepsound
    fi
    pw-play $sDIR/$1 || paplay $sDIR/$1
}

function getSound() {
    prepsound
    if [ -f $tDIR/$1 ]; then
        return 1
    else
        return 0
    fi
}

function setSound() {
    prepsound

    if [ ! -d $sDIR ]; then
        mkdir -p $sDIR || exit 1
    fi
    if [ -f $sDIR/$1 ]; then
        rm $sDIR/$1
    else
        touch $sDIR/$1
    fi
}

# if $(getSound screenshot); then
    # echo "Screenshot sound is enabled"
# else
    # echo "Screenshot sound is disabled"
# fi

function screenshot() {
    $HOME/scripts/hyprshot $@
}

function volume() {
    $HOME/scripts/hyprvol $@
}

if [ "$1" ]; then
    $@
fi
