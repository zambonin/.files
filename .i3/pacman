#!/bin/sh

[[ "$BLOCK_BUTTON" -eq 1 ]] && urxvtc -e sudo pacman -Syu
[[ $(checkupdates | wc -l) -ne 0 ]] && echo "[!]"
