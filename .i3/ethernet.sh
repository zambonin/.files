#!/bin/sh

interface="enp0s20u3"

ip=$(ip addr | awk 'FNR==15 {print $2}')
[[ "$(cat /sys/class/net/$interface/operstate)" ]] && echo "$interface: $ip"

