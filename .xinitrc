#!/bin/bash

[[ -f ~/.Xresources ]] && xrdb -merge $HOME/.Xresources
feh --bg-fill $HOME/.wallpaper.{jpg,png}
urxvtd -q -o -f
redshift &
xcape -e "Shift_L=parenleft;Shift_R=parenright"
exec i3 -c $HOME/dotfiles/.i3/config
