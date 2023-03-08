# Select a random file name from the list
random_file=$(shuf -n 1 -e $(find /home/system/Pictures/wallpapers) | head -n 1)
echo $random_file
