#!/bin/bash

xbacklight -dec 1000
/opt/urserver/urserver --daemon
start-pulseaudio-x11
setxkbmap br
feh --bg-scale ~/makepkg_not_war_by_galantyshow-d4g9n98.png
exec i3
