#!/usr/bin/bash
set -euo pipefail
card_link=/dev/dri/by-path/pci-0000:03:00.0-card
card=''
for ((attempt = 0; attempt < 100; attempt++)); do
  if card=$(readlink -e "$card_link"); then
    break
  fi
  sleep 0.1
done
if [[ -z "$card" ]]; then
  printf 'AMD graphics device did not appear: %s\n' "$card_link" >&2
  exit 1
fi
printf '%s\n' "${1:-on}" > "/sys/class/drm/${card##*/}-HDMI-A-1/status"
