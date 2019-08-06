#!/bin/bash

TMP_MKINITCPIO_LOG=$LOG_DIR/mkinitcpio.log
TMP_PACMAN_LOG=$LOG_DIR/pacman.log

# runs mkinitcpio on the target system, displays output
target_run_mkinitcpio()
{
	target_special_fs on

	run_controlled mkinitcpio "chroot $var_TARGET_DIR /sbin/mkinitcpio -p kernel26" $TMP_MKINITCPIO_LOG "Rebuilding initcpio images ..."

	target_special_fs off

	# alert the user to fatal errors
	[ $CONTROLLED_EXIT -ne 0 ] && show_warning "MKINITCPIO FAILED - SYSTEM MAY NOT BOOT" "$TMP_MKINITCPIO_LOG" text
	return $CONTROLLED_EXIT
}


# installpkg(). taken from setup. modified bigtime
# performs package installation to the target system
installpkg() {
	ALL_PACKAGES=
	[ -n "$var_TARGET_GROUPS" ] && ALL_PACKAGES=`list_packages group "$var_TARGET_GROUPS" | awk '{print $2}'`
	if [ -n "$var_TARGET_PACKAGES_EXCLUDE" ]
	then
		for excl in $var_TARGET_PACKAGES_EXCLUDE
		do
			ALL_PACKAGES=${ALL_PACKAGES//$excl/}
		done
	fi

	if [ -n "$var_TARGET_PACKAGES" ]
	then
		[ -n "$ALL_PACKAGES" ] && ALL_PACKAGES="$ALL_PACKAGES $var_TARGET_PACKAGES"
		[ -z "$ALL_PACKAGES" ] && ALL_PACKAGES=$var_TARGET_PACKAGES
	fi
	ALL_PACKAGES=`echo $ALL_PACKAGES`
	[ -z "$ALL_PACKAGES" ] && die_error "No packages/groups specified to install"

	target_special_fs on

	notify "Package installation will begin now.  You can watch the output in the progress window. Please be patient."

	run_controlled pacman_installpkg "$PACMAN_TARGET --noconfirm -S $ALL_PACKAGES" $TMP_PACMAN_LOG "Installing... Please Wait" 

	local _result=''
	if [ $CONTROLLED_EXIT -ne 0 ]; then
		_result="Installation Failed (see errors below)"
		echo -e "\nPackage Installation FAILED." >>$TMP_PACMAN_LOG
	else
		_result="Installation Complete"
		echo -e "\nPackage Installation Complete." >>$TMP_PACMAN_LOG
	fi

	show_warning "$_result" "$TMP_PACMAN_LOG" text || return 1

	target_special_fs off
	sync

	return $CONTROLLED_EXIT
}


# enable glibc locales from rc.conf and build initial locale DB
target_configure_initial_locale() 
{
    for i in $(grep "^LOCALE" ${var_TARGET_DIR}/etc/rc.conf | sed -e 's/.*="//g' -e's/\..*//g'); do
        sed -i -e "s/^#$i/$i/g" ${var_TARGET_DIR}/etc/locale.gen
    done
    target_locale-gen
}


target_locale-gen ()
{
	inform "Generating glibc base locales..."
	chroot ${var_TARGET_DIR} locale-gen >/dev/null
}

target_configure_initcpio () {
	local ret=0
        # Give initcpio the encrypt hook when / depends on an encrypted volume
        # (other encrypted volumes, not related to / don't need the encrypt hook, afaik)
        # If / also depends on lvm, this way the lvm2 hook will also be included in the right place
        if get_anchestors_mount ';/;'
        then
                hooks=`echo "$ANSWER_DEVICES" | cut -d ' ' -f2 | egrep 'lvm-lv|dm_crypt' | sed -e 's/lvm-lv/lvm2/' -e 's/dm_crypt/encrypt/' | tac`
                hooks=`echo $hooks` # $hooks is now a space separated, correctly ordered list of needed hooks
                if [ -n "$hooks" ]
                then
                        # for each hook we're about to add, remove it first if it's already in
                        for hook in $hooks
                        do
                                sed -i "/^HOOKS/ s/$hook //" ${var_TARGET_DIR}/etc/mkinitcpio.conf || ret=$?
                        done
                        # now add the correctly ordered string
                        sed -i "/^HOOKS/ s/filesystems/$hooks filesystems/" ${var_TARGET_DIR}/etc/mkinitcpio.conf || ret=$?
                fi
        fi
        # The lvm2 hook however is needed for any lvm LV, no matter the involved mountpoints, so include it if we still need to
        if grep -q lvm-lv $TMP_BLOCKDEVICES && ! grep -q '^HOOKS.*lvm2'  ${var_TARGET_DIR}/etc/mkinitcpio.conf
        then
                sed -i "/^HOOKS/ s/filesystems/lvm2 filesystems/" ${var_TARGET_DIR}/etc/mkinitcpio.conf || ret=$?
        fi

        # if keymap/usbinput are not in mkinitcpio.conf, but encrypt is, we should probably add it
        if line=`grep '^HOOKS.*encrypt' ${var_TARGET_DIR}/etc/mkinitcpio.conf`
        then
                if ! echo "$line" | grep -q keymap
                then
                        sed -i '/^HOOKS/ s/encrypt/keymap encrypt/' ${var_TARGET_DIR}/etc/mkinitcpio.conf || ret=$?
                fi
                if ! echo "$line" | grep -q usbinput
                then
                        sed -i '/^HOOKS/ s/keymap/usbinput keymap/' ${var_TARGET_DIR}/etc/mkinitcpio.conf || ret=$?
                fi
        fi
	return $ret
}
