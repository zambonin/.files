#!/bin/bash

[[ -f ~/.Xresources ]] && xrdb -merge $HOME/.Xresources
feh --bg-fill $HOME/.wallpaper.{jpg,png}
urxvtd -q -o -f
redshift &
exec i3 -c $HOME/.files/.i3/config
