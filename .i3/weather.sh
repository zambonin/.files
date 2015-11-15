#!/bin/sh

link=$(curl -s http://weather.noaa.gov/weather/current/SBFL.html)
src=$(echo "$link" | grep -E --context=2 -m 2 "Temperature|Sky conditions")
temp=$(awk 'FNR==11 {print substr($5,2,3)}' <<< "$src")
cond=$(awk 'FNR==5 {print $3,$4}' <<< "$src" | xargs)
[[ "$cond" && "$temp" ]] && echo "$cond" ["$temp"°C]

[[ "$BLOCK_BUTTON" -eq 1 ]] && chromium http://weather.noaa.gov/weather/current/SBFL.html &
