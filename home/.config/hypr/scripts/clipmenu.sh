#!/usr/bin/env bash
CLEAR="Clear clipboard history"
sel=$({
  echo "$CLEAR"
  cliphist list
} | rofi -theme ~/.config/rofi/clipboard.rasi -dmenu) || exit 0

if [ "$sel" = "$CLEAR" ]; then
  cliphist wipe
  wl-copy --clear
  notify-send -a Clipboard "Clipboard" "History cleared"
else
  printf '%s\n' "$sel" | cliphist decode | wl-copy
fi
