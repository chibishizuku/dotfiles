#!/usr/bin/env bash
# Caffeine: block sleep + lid-close suspend, keep locking.

PIDFILE="${XDG_RUNTIME_DIR}/caffeine.pid"

is_active() {
  [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null
}

case "$1" in
toggle)
  if is_active; then
    kill "$(cat "$PIDFILE")"
    rm -f "$PIDFILE"
    hyprctl eval 'hl.notification.create({ text = "Caffeine off", timeout = 1500, icon = "ok" })'
  else
    setsid systemd-inhibit \
      --what=sleep:handle-lid-switch \
      --who=Caffeine \
      --why="Caffeine mode: no sleep, still locks" \
      --mode=block \
      sleep infinity &
    echo $! >"$PIDFILE"
    hyprctl eval 'hl.notification.create({ text = "Caffeine on", timeout = 1500, icon = "ok" })'
  fi
  pkill -RTMIN+8 waybar
  ;;
*)
  if is_active; then
    echo '{"text":"󰅶","tooltip":"Caffeine ON: no sleep, still locks","class":"active"}'
  else
    echo '{"text":"󰛊","tooltip":"Caffeine OFF","class":"inactive"}'
  fi
  ;;
esac
