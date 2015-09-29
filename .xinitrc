#!/bin/bash

xbacklight -dec 1000
feh --bg-scale .wallpaper.png
[[ -f ~/.Xresources ]] && xrdb -merge $HOME/.Xresources
urxvtd -q -o -f
redshift &
exec i3
