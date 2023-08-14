#!/bin/bash

# Set the directory path
directory="$XDG_CONFIG_HOME/clipmenu.6.system"

# Calculate the current timestamp
current_timestamp=$(date +%s)

# Iterate over each file in the directory
for file in "$directory"/*; do
    # Check if the file exists and isn't lock*
    if [ -f "$file" ] && [[ "$file" != "lock" ]] && [[ "$file" != "session_lock" ]]; then
        # Get the file's last modification timestamp
        timestamp=$(stat -c %Y "$file")

        # Calculate the difference in seconds between the current timestamp and the file's timestamp
        time_diff=$((current_timestamp - timestamp))

        # Calculate the number of seconds in a month (30 days)
        month_in_seconds=$((30 * 24 * 60 * 60))

        # Check if the file exists longer than a month
        if [ "$time_diff" -gt "$month_in_seconds" ]; then
            # Delete the file
            rm -v "$file"
            echo "Deleted file: '$file'"
        fi
    fi
done
