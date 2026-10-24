#!/usr/bin/env bash
# Copy configs from this machine into the repo. Nothing in ~ is changed.
set -euo pipefail

REPO="$HOME/dotfiles/home"
ITEMS=(
  .config/hypr
  .config/waybar
  .config/dunst
  .config/kitty
  .config/rofi
  .config/satty
  .config/systemd/user
  .zshrc
  .config/dolphinrc
  .config/kdeglobals
  .config/baloofilerc
  .config/mimeapps.list
  .config/user-dirs.dirs
  .config/gtk-3.0/settings.ini
  .config/gtk-4.0/settings.ini
  .config/qt5ct
  .config/qt6ct
  .config/Kvantum
  .gtkrc-2.0
  .local/share/fonts
  .local/share/color-schemes
  .local/share/icons
  .local/share/themes
)

for item in "${ITEMS[@]}"; do
  [[ -e "$HOME/$item" ]] || continue
  mkdir -p "$REPO/$(dirname "$item")"
  rm -rf "$REPO/$item"
  cp -a "$HOME/$item" "$REPO/$item"
  echo "synced $item"
done
