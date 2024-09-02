#!/bin/bash
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
pw-play $XDG_DATA_HOME/sounds/win11startup.mp3 || paplay $XDG_DATA_HOME/sounds/win11startup.mp3
