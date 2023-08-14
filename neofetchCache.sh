#!/usr/bin/bash

cachefile=$XDG_CACHE_HOME/neofetch.save

exec neofetch > "$cachefile"
