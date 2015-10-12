#!/bin/sh

interface="wlp3s0"

[[ "$(cat /sys/class/net/$interface/operstate)" = 'down' ]] && echo "off"

quality=$(grep "$interface" /proc/net/wireless | awk '{ print int($3 * 100 / 70) }')%

# iwgetid needs wireless_tools
echo $(iwgetid -r) ["$quality"]
