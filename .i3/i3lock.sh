#!/usr/bin/env bash

tmpbg='/tmp/screen.png'
scrot "$tmpbg"
convert "$tmpbg" -blur 0x5 "$tmpbg"
i3lock -u -i "$tmpbg"
