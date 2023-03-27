#!/bin/bash

# Get the ID of the active window
active_window=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')

# Use xkill to kill only the active window
xkill -id $active_window
