#!/bin/sh

status=$(amixer -c 1 get Master | awk '{print $6}' | sed 's/\[//;s/\]//;5q;d')
percent=$(amixer -c 1 get Master | awk '{print $4}' | sed 's/.//;s/.$//;5q;d')

[[ "$BLOCK_BUTTON" -eq 2 ]] && amixer -q -c 1 set Master toggle
[[ "$BLOCK_BUTTON" -eq 4 ]] && amixer -q -c 1 sset Master 1%+
[[ "$BLOCK_BUTTON" -eq 5 ]] && amixer -q -c 1 sset Master 1%-

echo "$status" ["$percent"]
