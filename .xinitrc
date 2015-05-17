#!/bin/bash

xbacklight -dec 1000
/opt/urserver/urserver --daemon
setxkbmap br
feh --bg-scale wallpaper.png
exec i3