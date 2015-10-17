#!/bin/sh

percent=$(acpi | awk '{print $4'} | sed 's/,//')
timeleft=$(acpi | awk '{print $5}')

echo "$timeleft" ["$percent"]
echo
(( $(sed 's/%//' <<< "$percent") < 10 )) && echo \#FF0000 || exit 0
