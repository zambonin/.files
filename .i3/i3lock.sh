#!/usr/bin/env bash

tmpbg='/tmp/screen.png'
scrot "$tmpbg"
convert "$tmpbg" -blur 0x5 "$tmpbg"
xset dpms force off
i3lock -u -i "$tmpbg"
