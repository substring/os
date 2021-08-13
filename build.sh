#!/bin/bash
#set -x
source settings

ARCHISO_PROFILE=groovyarcade
AI_DIR=/work/"$ARCHISO_PROFILE"
ISO_NAME="GA_$(date +%Y.%m)"


apply_overlay() {
# Read the kernel default command line from globals
dflt_cmdline="$(grep KERNEL_DEFAULT_CMDLINE globals | cut -d '=' -f2-)"

# BIOS syslinux only hack
syslinuxcfg="$(LABEL=$ISO_NAME KRNL_CMDLINE="$dflt_cmdline" envsubst '${LABEL} ${KRNL_CMDLINE}' < /work/groovyarcade/syslinux/syslinux.cfg)"
#LABEL=$ISO_NAME envsubst '${LABEL}' < /work/overlay/syslinux/syslinux.cfg > "$AI_DIR"/syslinux/syslinux.cfg
echo "$syslinuxcfg" > "$AI_DIR"/syslinux/syslinux.cfg

# UEFI syslinux only hack
for f in "$AI_DIR"/efiboot/loader/entries/*.conf ; do
  entry="$(KRNL_CMDLINE="$dflt_cmdline" envsubst '${KRNL_CMDLINE}' < "$f")"
  echo "$entry" > "$f"
done
}

customize_archiso() {
  mkdir -p "$AI_DIR"/airootfs/etc/pacman.d/
  cp groovy-ux-repo.conf "$AI_DIR"/airootfs/etc/pacman.d/
  cp groovy-ux-repo.conf /etc/pacman.d/
}


start_iso_build() {
  mkarchiso -v \
    -o /work/output \
    -L "$ISO_NAME" \
    -A "GroovyArcade Install DVD" \
    -w /work/fakeroot \
    -D groovyarcade \
    "$AI_DIR"
}


enable_testing_repo() {
  sed -Ei '1,3s/^#(.*)/\1/g' groovy-ux-repo.conf
}


use_git_pkg() {
  pkg_to_rename="gatools gasetup galauncher"
  for pkg in $pkg_to_rename ; do
    sed -i "s/^${pkg}$/${pkg}-git/g" "$AI_DIR"/packages.x86_64
  done
}


main() {
# Enable the testing repo for non stable versions
if [[ $GA_VERSION != master && ! $GA_VERSION =~ [0-9]{4}\.[0-9]{2} ]] ; then
  echo "Enabling the testing repo and packages"
  use_git_pkg
  enable_testing_repo
fi

# Sync overlay
apply_overlay

# patch archiso build.sh for custom pacman.conf
customize_archiso

# Banzai!
start_iso_build

# Get the packages list
cp /work/fakeroot/iso/groovyarcade/pkglist.x86_64.txt /work/output
}

main
