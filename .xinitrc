#!/bin/bash

xbacklight -dec 1000
/opt/urserver/urserver --daemon
start-pulseaudio-x11
setxkbmap br
feh --bg-scale ~/wallhaven-84023.png
exec i3
