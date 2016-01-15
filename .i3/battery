#!/bin/sh

data=$(awk '{print $5, "["substr($4, 0, length($4)-1)"]"}' <<< $(acpi))
echo "$data"
echo
(( $(awk '{print substr($2, 2, length($2)-3)}' <<< "$data") < 10 )) && echo \#FF0000 || exit 0
