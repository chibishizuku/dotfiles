#!/usr/bin/env bash
# Waybar module: firmware power profile (F8 key).
# Updates the bar and shows a Hyprland notification on change.

PROFILE=/sys/firmware/acpi/platform_profile
last=""
first=1

while true; do
  cur=$(cat "$PROFILE" 2>/dev/null)
  if [[ "$cur" != "$last" ]]; then
    case "$cur" in
    low-power) label="Power saver" ;;
    balanced) label="Balanced" ;;
    performance) label="Performance" ;;
    *) label="$cur" ;;
    esac
    printf '{"text":"󱐋","tooltip":"Power profile: %s","class":"%s"}\n' "$label" "$cur"
    if ((!first)); then
      hyprctl eval "hl.notification.create({ text = \"$label mode\", timeout = 1500, icon = \"ok\" })" >/dev/null
    fi
    first=0
    last="$cur"
  fi
  sleep 1
done
