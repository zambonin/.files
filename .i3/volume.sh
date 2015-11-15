#!/bin/sh

[[ "$BLOCK_BUTTON" -eq 2 ]] && amixer -q -c 1 set Master toggle
[[ "$BLOCK_BUTTON" -eq 4 ]] && amixer -q -c 1 sset Master 1%+
[[ "$BLOCK_BUTTON" -eq 5 ]] && amixer -q -c 1 sset Master 1%-

echo $(amixer -c 1 get Master | awk 'FNR==5 {print substr($6,2,length($6)-2), $4}')