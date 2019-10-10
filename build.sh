#!/bin/bash

source settings

ARCHISO_PROFILE=releng
AI_DIR=/work/groovylive/"$ARCHISO_PROFILE"
ISO_NAME="GA_$(date +%Y.%m)"
mkdir -p "$AI_DIR"


get_archiso_profile() {
cp -r /usr/share/archiso/configs/"$ARCHISO_PROFILE"/ /work/groovylive/
}


prepare_pacman() {
cat << EOF >> /etc/pacman.conf

[groovyarcade]
SigLevel = PackageOptional
Server = $PACMAN_REPO
EOF

pacman -Sy
}


install_packages_from_groovyarcade_repo() {
# Make a list of groovyarcade packages
local tmpfile="/tmp/groovyarcade_repo.lst"
pacman -Sl groovyarcade | cut -d " " -f 2 > "$tmpfile"
pacman -Sy --noconfirm - < "$tmpfile"
}


append_packages_from_groovyarcade_repo() {
# Make a list of groovyarcade packages
pacman -Sl groovyarcade | cut -d " " -f 2 >> "$AI_DIR"/packages.x86_64
}


add_wanted_packages () {
# Remove the default broadcom-wl package
sed -i "/^broadcom-wl$/d" "$AI_DIR"/packages.x86_64
grep -v "^#" packages.x86_64 >> "$AI_DIR"/packages.x86_64
}


apply_overlay() {
cp -R /work/overlay/groovyarcade/* "$AI_DIR"/airootfs/
cp -R /work/overlay/isolinux/* "$AI_DIR"/isolinux/
cp -R /work/overlay/syslinux/* "$AI_DIR"/syslinux/

# syslinux only hack
syslinuxcfg="$(LABEL=$ISO_NAME envsubst '${LABEL}' < /work/overlay/syslinux/syslinux.cfg)"
#LABEL=$ISO_NAME envsubst '${LABEL}' < /work/overlay/syslinux/syslinux.cfg > "$AI_DIR"/syslinux/syslinux.cfg
echo "$syslinuxcfg" > "$AI_DIR"/syslinux/syslinux.cfg

# the initramfs is built before syncing the overlays, so circumvent this with a nasty hack
cp /work/overlay/groovyarcade/etc/mkinitcpio-dvd.conf "$AI_DIR"/mkinitcpio.conf
}

customize_archiso() {
# Set the pacman.conf the way we want it
# ignore the linux package
sed -iE "s/#IgnorePkg/IgnorePkg/" "$AI_DIR"/pacman.conf
sed -iE "/^IgnorePkg/ s/$/ linux/" "$AI_DIR"/pacman.conf
# Add the groovy repo before arch linux packages. In case, for later
sed -i "/^\[core\]$/i Include = \/etc\/pacman.d\/groovy-ux-repo.conf\n" "$AI_DIR"/pacman.conf
mkdir -p "$AI_DIR"/airootfs/etc/pacman.d/
cp groovy-ux-repo.conf "$AI_DIR"/airootfs/etc/pacman.d/

# Patch archiso's build.sh for custom kernel
patch -p3 -d "$AI_DIR" < archiso_build.sh.patch

# Patch mkarchiso to prevent deleting initramfs and kernel, leacving /boot untouched
# so gasetup will correctly mkinitcpio the 15khz kernel
patch -p2 -d /usr/sbin < mkarchiso.patch ||exit 1
}


start_iso_build() {
cd "$AI_DIR"
mkdir out
./build.sh -v \
  -o /work/output \
  -k linux-15khz \
  -N groovyarcade \
  -V "$(date +%Y.%m)" \
  -L "$ISO_NAME" \
  -A "GroovyArcade Install DVD" \
  -w /work/fakeroot \
  -D groovyarcade
}


main() {
# Basic ARCH stuff
get_archiso_profile
add_wanted_packages

# GroovyUX specific, will allow to list groovy packages to later add them to the iso
prepare_pacman
#append_packages_from_groovyarcade_repo

# Add groovy-ux own customize_airootfs_groovy.sh
cp /work/customize_airootfs_groovy.sh "$AI_DIR"/airootfs/root/
echo "/root/customize_airootfs_groovy.sh" >> "$AI_DIR"/airootfs/root/customize_airootfs.sh

# Sync overlay
apply_overlay

#patch archiso build.sh for custom pacman.conf
customize_archiso

#ls -lR "$AI_DIR"

# Banzai!
start_iso_build

# Get the packages list
cp /work/fakeroot/iso/groovyarcade/pkglist.x86_64.txt /work/output
}

main
