#!/bin/sh

sleep 15
link=$(curl -s http://weather.noaa.gov/weather/current/SBFL.html)
temp=$(echo "$link" | grep --context=2 "Temperature" | sed '5q;d' | \
       awk '{print $5}' | sed 's/(//')
cond=$(echo "$link" | grep --context=2 "Sky conditions" | sed '5q;d' | \
       awk '{print $3 " " $4}')
echo "$cond" ["$temp"°C]

[[ "$BLOCK_BUTTON" -eq 1 ]] && chromium http://weather.noaa.gov/weather/current/SBFL.html &
