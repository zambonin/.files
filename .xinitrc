#!/bin/bash

xbacklight -dec 1000
[[ -f ~/.Xresources ]] && xrdb -merge $HOME/.Xresources
feh --bg-fill --randomize $HOME/.wallpaper/* &
urxvtd -q -o -f
redshift &
exec i3 -c $HOME/dotfiles/.i3/config
