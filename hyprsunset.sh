#!/bin/bash

time=$(date +%H)

if [ $time -ge 6 -a $time -lt 20 ]; then
    killall hyprsunset
else
    hyprsunset &
fi
