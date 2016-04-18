#!/bin/bash

xbacklight -dec 1000
feh --bg-fill $HOME/.wallpaper.{jpg,png}
urxvtd -q -o -f
redshift &
exec i3 -c $HOME/dotfiles/.i3/config
