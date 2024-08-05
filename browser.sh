#!/bin/bash

# Search for the visible Firefox window(s) and get its window ID
window_id=$(xdotool search --onlyvisible --class "firefox")

# Send the keyboard shortcut to open the URL bar, copy the URL to clipboard and then close the URL bar by sending the Escape key.
# The command is sent to the Firefox window with the specified ID using the --window option.
xdotool key --window $window_id --delay 20 --clearmodifiers ctrl+l ctrl+c Escape
url=$( xsel -ob )
echo "$url"