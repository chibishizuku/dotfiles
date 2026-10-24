#!/usr/bin/env bash
# Standalone wallpaper service using awww. No HyDE dependency.
# Usage:
#   wallpaper.sh set /path/to/image     -- set wallpaper immediately
#   wallpaper.sh                        -- daemon; reads wallpaper from a state file
#
# The wallpaper path is stored in $WALLPAPER_STATE so a restart (or loginctl
# reexec / relogin) restores the same image. On first run it falls back to
# the first file found in $WALLPAPER_DIR.

set -euo pipefail

WALLPAPER_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/wallpaper/current"
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
WALLPAPER_LINK="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper/current"
WALLPAPER_BLUR="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper/blur.png"

die() { printf 'wallpaper: %s\n' "$1" >&2; exit 1; }

ensure_daemon() {
    if ! awww query >/dev/null 2>&1; then
        awww-daemon --format xrgb &
        disown
        sleep 0.3
    fi
}

set_wallpaper() {
    local img="$1"
    [[ -f "$img" ]] || die "image not found: $img"
    ensure_daemon
    awww img "$img"
    mkdir -p "$(dirname "$WALLPAPER_STATE")" "$(dirname "$WALLPAPER_LINK")"
    printf '%s\n' "$img" > "$WALLPAPER_STATE"
    ln -sf "$(readlink -f "$img")" "$WALLPAPER_LINK"
    make_blur "$img"
}

# Generate a blurred, darkened copy used by rofi (style_3 / clipboard backgrounds).
make_blur() {
    local img="$1"
    if command -v magick >/dev/null 2>&1; then
        magick "$img" -resize 1920x1080^ -gravity center -extent 1920x1080 \
            -blur 0x24 -fill black -colorize 40% "$WALLPAPER_BLUR" 2>/dev/null \
            || magick "$img" -blur 0x24 -fill black -colorize 40% "$WALLPAPER_BLUR"
    elif command -v convert >/dev/null 2>&1; then
        convert "$img" -blur 0x24 -fill black -colorize 40% "$WALLPAPER_BLUR"
    fi
    # rofi's url() does not expand ~, so write the absolute path into the themes.
    for theme in "$HOME/.config/rofi/style_3.rasi" "$HOME/.config/rofi/clipboard.rasi"; do
        if [[ -f "$theme" ]]; then
            sed -i -E "s|url\([^)]*blur\.png[^)]*\)|url(\"$WALLPAPER_BLUR\")|" "$theme"
        fi
    done
}

restore_wallpaper() {
    local img
    if [[ -f "$WALLPAPER_STATE" ]]; then
        img="$(cat "$WALLPAPER_STATE")"
        [[ -f "$img" ]] || img="$(ls -1 "$WALLPAPER_DIR"/* 2>/dev/null | head -1)"
    else
        img="$(ls -1 "$WALLPAPER_DIR"/* 2>/dev/null | head -1)"
    fi
    [[ -n "${img:-}" ]] || die "no wallpaper found in $WALLPAPER_DIR (set WALLPAPER_DIR or place an image there)"
    set_wallpaper "$img"
}

cmd="${1:-}"

case "$cmd" in
    set)
        [[ -n "${2:-}" ]] || die "usage: wallpaper.sh set /path/to/image"
        set_wallpaper "$2"
        ;;
    "")
        restore_wallpaper
        ;;
    *)
        die "unknown command: $cmd"
        ;;
esac
