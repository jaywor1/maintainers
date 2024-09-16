#!/bin/bash

source functions.sh

# Example of DISK=/dev/sda1
DISK="/dev/yourdev1"

DISK_CLEANUP_BEFORE=$(df -Th | grep "$DISK" | awk '{ print $4 }')

log "Disk size before: $DISK_CLEANUP_BEFORE"

# Pacman stuff
sudo pacman -Scc > /dev/null && ok "pacman -Scc" || err "pacman -Scc"
sudo pacman -Rns $(sudo pacman -Qtdq) && ok "Removed unused packages" || err "Error removing unused packages"

# Save rofi and keepassxc cache
mv -v ~/.cache/rofi-3.runcache /tmp/disk-cleanup-rofi.runcache && ok "Saved rofi cache" || err "Error saving rofi cache"
mv -v ~/.cache/keepassxc /tmp/disk-cleanup-keepassxc && ok "Saved keepassxc cache" || err "Error saving keepassxc cache"

# Remove all cache
rm -rfv ~/.cache/* && ok "Removed cache files"

# Restore rofi and keepassxc cache
mv -v /tmp/disk-cleanup-rofi.runcache /home/bia/.cache/rofi-3.runcache && ok "Restore rofi cache" || err "Error restoring rofi cache"
mv -v /tmp/disk-cleanup-keepassxc /home/bia/.cache/keepassxc && ok "Restore keepassxc cache" || err "Error restoring keepassxc cache"

# Cleanup journalctl
sudo journalctl --vacuum-time=7d > /dev/null 2> /dev/null && ok "Cleaned up journalctl" || err "Error cleaning up journalctl"

# Cleanup docker images
sudo docker rm -f $(docker ps -qa) && ok "Removed docker images" || err "Error removing docker images"

# Use baobab for deeper cleaning
echo "Do you want do open cleanup program (baobab)? [y/n]"
read input
if [ "$input" = "y" ] || [ "$input" = "yes" ] || [ "$input" = "" ]
then
  # needs extra repository
  pacman -S baobab
  baobab
fi

DISK_CLEANUP_AFTER=$(df -Th | grep "$DISK" | awk '{ print $4 }')

log "Disk size before: $DISK_CLEANUP_BEFORE"
log "Disk size after:  $DISK_CLEANUP_AFTER"
