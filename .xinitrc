#!/bin/bash

xbacklight -dec 1000
setxkbmap br
feh --bg-scale .wallpaper.png
[[ -f ~/.Xresources ]] && xrdb -merge $HOME/.Xresources
exec i3
