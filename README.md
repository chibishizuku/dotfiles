## Manual steps (not in files)

### Boot security
- sbctl create-keys → BIOS "Reset to Setup Mode" → chattr -i KEK/db efivars
  → sbctl enroll-keys -m → sign BOOTX64.EFI, systemd-boot (+.signed source), UKIs → enable SB
- BIOS: supervisor password, F12 menu password, USB/PXE boot off,
  Kernel DMA Protection on, Secure Rollback Prevention on,
  "Windows UEFI Firmware Update" on (for fwupd capsules)
- fwupdmgr update (dbx)

### Storage
- pacman DB in root: copy /var/lib/pacman → /usr/lib/pacman-db, DBPath in pacman.conf, symlink back
- ~/.Genymobile as own subvolume with chattr +C (VM images out of snapshots)
- /tmp on tmpfs (no btrfs /tmp line in fstab), noatime on all btrfs mounts
- snapper: root timeline off, limits 10/5; home 5h/7d/2w/1m

### Network
- ufw default deny incoming, allow outgoing, enable; allow 8080 on vboxnet0 (Burp)
- dnscrypt-proxy.service + systemd-resolved, stub resolv.conf symlink
- NetworkManager: ipv4/ipv6.ignore-auto-dns yes on every Wi-Fi/Ethernet connection
- Firefox: DNS over HTTPS off
- libvirt: isolated network for analysis VMs

### Devices
- USBGuard: generate-policy on that machine, then
  append-rule 'allow with-interface equals { 08:*:* }', allow-device -p for mouse
- fprintd-enroll (2 fingers), pam_fprintd lines in sudo + polkit-1
- unmask systemd-rfkill after removing TLP

### Secrets
- remove gnome-keyring, KeePassXC as Secret Service, expose only Secret_Service group
- VPN password: "store for all users"
- KeePassXC database: copy separately, never in repo