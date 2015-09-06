#!/bin/sh

sleep 30
link="http://weather.noaa.gov/weather/current/SBFL.html"
temp=$(curl -s $link | grep --context=2 "Temperature" | sed '5q;d' | awk '{print $5}' | sed 's/(//')
cond=$(curl -s $link | grep --context=2 "Sky conditions" | sed '5q;d' | awk '{print $3 " " $4}')
echo $temp°C, $cond
