#!/usr/bin/env bash

get_brightness() {
  brightnessctl -m | grep -o '[0-9]\+%' | head -c -2
}

send_notification() {
  local brightness
  brightness=$(get_brightness)

  notify-send \
    -a "Brightness" \
    -r 7 \
    -t 1000 \
    -h "int:value:$brightness" \
    "Brightness" \
    "$brightness%"
}

step="${2:-5}"

case "$1" in
i | -i)
  current=$(get_brightness)

  if [ "$current" -lt 10 ]; then
    step=1
  fi

  brightnessctl set "+${step}%"
  send_notification
  ;;

d | -d)
  current=$(get_brightness)

  if [ "$current" -le 10 ]; then
    step=1
  fi

  brightnessctl set "${step}%-"
  send_notification
  ;;

*)
  echo "Usage: $0 {i|d} [step]"
  ;;
esac
