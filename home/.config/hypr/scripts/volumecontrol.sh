#!/usr/bin/env bash
# Volume control with notification. Hard cap: 125%.

SINK="@DEFAULT_AUDIO_SINK@"
MAX="1.25"
step="${2:-5}"

get_volume() { wpctl get-volume "$SINK" | awk '{print int($2 * 100 + 0.5)}'; }
is_muted() { wpctl get-volume "$SINK" | grep -q MUTED; }

notify() {
  local vol icon
  if is_muted; then
    notify-send -a Volume -r 8 -t 1000 -h int:value:0 "󰖁  Volume" "Muted"
    return
  fi
  vol=$(get_volume)
  if ((vol == 0)); then
    icon="󰕿"
  elif ((vol < 50)); then
    icon="󰖀"
  else
    icon="󰕾"
  fi
  notify-send -a Volume -r 8 -t 1000 -h "int:value:$vol" "$icon  Volume" "${vol}%"
}

case "$1" in
i)
  wpctl set-mute "$SINK" 0
  wpctl set-volume -l "$MAX" "$SINK" "${step}%+"
  ;;
d) wpctl set-volume "$SINK" "${step}%-" ;;
m) wpctl set-mute "$SINK" toggle ;;
*)
  echo "Usage: $0 {i|d|m} [step]"
  exit 1
  ;;
esac

notify
