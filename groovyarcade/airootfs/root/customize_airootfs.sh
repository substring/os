#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

# Warning: customize_airootfs.sh is deprecated! Support for it will be removed in a future archiso version.

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

# GroovyArcade specific
groupadd --gid 1000 arcade
usermod -a -G adm,audio,disk,games,input,log,network,nobody,optical,power,storage,tty,users,video,wheel arcade
sed -i "/^# .*wheel.*NOPASSWD.*/s/^# //" /etc/sudoers

# Add a arcade smaba user
(echo "arcade"; echo "arcade") | smbpasswd -s -a arcade

systemctl enable smb
systemctl enable nmb
systemctl enable sshd

# Only build the default initramfs
sed -i "s/^PRESETS=.*/PRESETS=('default')/" /etc/mkinitcpio.d/linux-15khz.preset

# Disable the lvm2 monitor as it considerably slows down the boot
systemctl disable lvm2-monitor.service

# Set GroovyArcade boot screen
plymouth-set-default-theme -R groovy

# Add the groovyarcade repo
grep -q groovy-ux-repo.conf /etc/pacman.conf || sed -i "/^\[core\]$/i Include = \/etc\/pacman.d\/groovy-ux-repo.conf\n" /etc/pacman.conf

# Basic configuration
basic_opts="-p base -u arcade"
/opt/gasetup/gasetup.sh $basic_opts -c groovyarcade
/opt/gasetup/gasetup.sh $basic_opts -c attract
/opt/gasetup/gasetup.sh $basic_opts -c groovymame

# Remove the fallback initramfs
rm /boot/*-fallback.img
