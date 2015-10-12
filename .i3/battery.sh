#!/bin/sh

percent=$(acpi | awk '{print $4'} | cut -c 1-3)
timeleft=$(acpi | awk '{print $5}')

echo "$timeleft" ["$percent"]
echo
(( $(cut -c 1-2 <<< "$percent") < 10 )) && echo \#FF0000 || exit 0
