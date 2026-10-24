#!/usr/bin/env bash
# Copy system configs (reference copies) and service lists into the repo.
set -euo pipefail

DEST="$HOME/dotfiles/etc"
META="$HOME/dotfiles/meta"
mkdir -p "$DEST" "$META"

FILES=(
  /etc/kernel/cmdline
  /etc/mkinitcpio.conf
  /etc/mkinitcpio.d
  /etc/pacman.conf
  /etc/fstab
  /etc/snapper/configs/root
  /etc/snapper/configs/home
  /etc/systemd/resolved.conf.d/dnscrypt.conf
  /etc/dnscrypt-proxy/dnscrypt-proxy.toml
  /etc/sddm.conf.d/autologin.conf
  /etc/systemd/system/powertop.service
  /etc/udev/rules.d/90-battery-threshold.rules
  /etc/pam.d/sudo
  /etc/pam.d/polkit-1
  /etc/auto-cpufreq.conf
)

for f in "${FILES[@]}"; do
  [[ -e "$f" ]] || {
    echo "skip (missing): $f"
    continue
  }
  sudo cp -a --parents "$f" "$DEST"
  echo "synced $f"
done
sudo chown -R "$USER:$USER" "$DEST"

pacman -Qqen >"$META/pkglist.txt"
systemctl list-unit-files --state=enabled --no-pager >"$META/enabled-system.txt"
systemctl --user list-unit-files --state=enabled --no-pager >"$META/enabled-user.txt"
echo "service and package lists saved"
