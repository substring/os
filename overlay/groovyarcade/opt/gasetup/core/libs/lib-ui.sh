#!/bin/bash
# Note that $var_UI_TYPE may not be set here. especially if being loaded in the "early bootstrap" phase

source /opt/gasetup/libui.sh

# mandatory to call me when you want to use me. call me again after setting $var_UI_TYPE
ui_init ()
{
	cats=(MAIN PROCEDURE UI UI-INTERACTIVE FS MISC NETWORK PACMAN SOFTWARE)
	if [ "$LOG_TO_FILE" = '1' ]; then
		logs="$LOG $LOGFILE"
	else
		logs=$LOG
	fi
	if [ "$DEBUG" = '1' ]; then
		libui_sh_init ${var_UI_TYPE:-cli} "$RUNTIME_DIR" "$logs" "${cats[@]}"
	else
		libui_sh_init ${var_UI_TYPE:-cli} "$RUNTIME_DIR" "$logs"
	fi

	# get keymap/font (maybe configured by aif allready in another process or even in another shell)
	# otherwise, take default keymap and consolefont as configured in /etc/rc.conf. can be overridden
	# Note that the vars in /etc/rc.conf can also be empty!
	[ -e $RUNTIME_DIR/aif-keymap      ] && var_KEYMAP=`     cat $RUNTIME_DIR/aif-keymap`
	[ -e $RUNTIME_DIR/aif-consolefont ] && var_CONSOLEFONT=`cat $RUNTIME_DIR/aif-consolefont`
	[ -z "$var_KEYMAP"      ] && var_KEYMAP=$KEYMAP
	[ -z "$var_CONSOLEFONT" ] && var_CONSOLEFONT=$CONSOLEFONT
	#[ -z "$var_KEYMAP"      ] && source /etc/rc.conf && var_KEYMAP=$KEYMAP
	#[ -z "$var_CONSOLEFONT" ] && source /etc/rc.conf && var_CONSOLEFONT=$CONSOLEFONT
}

# taken from setup
printk()
{
	case $1 in
		"on")  echo 4 >/proc/sys/kernel/printk ;;
		"off") echo 0 >/proc/sys/kernel/printk ;;
	esac
}


# Get a list of available partionable blockdevices for use in ask_option
# populates array $BLOCKFRIENDLY with elements like:
#   '/dev/sda' '/dev/sda 640133 MiB (640 GiB)'
listblockfriendly()
{
	BLOCKFRIENDLY=()
	for i in $(finddisks)
	do
		get_blockdevice_size $i MiB
		size_GiB=$(($BLOCKDEVICE_SIZE/2**10))
		BLOCKFRIENDLY+=($i "$i ${BLOCKDEVICE_SIZE} MiB ($size_GiB GiB)")
	done
}

# captitalize first character
function capitalize () {
	sed 's/\([a-z]\)\([a-zA-Z0-9]*\)/\u\1\2/g';
}

set_keymap ()
{
	KBDDIR="/usr/share/kbd"

	KEYMAPS=()
	for i in $(find $KBDDIR/keymaps -name "*.gz" | sort); do
		KEYMAPS+=("${i##$KBDDIR/keymaps/}" -)
	done
	ask_option "${var_KEYMAP:-no}" "Select a keymap" '' optional "${KEYMAPS[@]}"
	if [ -n "$ANSWER_OPTION" ]
	then
		loadkeys -q $KBDDIR/keymaps/$ANSWER_OPTION
		var_KEYMAP=$ANSWER_OPTION
		echo "$var_KEYMAP" > $RUNTIME_DIR/aif-keymap
	fi

	FONTS=()
	for i in $(find $KBDDIR/consolefonts -maxdepth 1 -name "*.gz"  | sed 's|^.*/||g' | sort); do
		FONTS+=("$i" -)
	done
	ask_option "${var_CONSOLEFONT:-no}" "Select a console font" '' optional "${FONTS[@]}"
	if [ -n "$ANSWER_OPTION" ]
	then
		var_CONSOLEFONT=$ANSWER_OPTION
		for i in 1 2 3 4
		do
			if [ -d /dev/vc ]; then
				setfont $KBDDIR/consolefonts/$var_CONSOLEFONT -C /dev/vc/$i
			else
				setfont $KBDDIR/consolefonts/$var_CONSOLEFONT -C /dev/tty$i
			fi
		done
		echo "$var_CONSOLEFONT" > $RUNTIME_DIR/aif-consolefont
	fi
}

# $1 "topic"
# shift 1; "$@" list of failed things
warn_failed () {
	local topic=$1
	shift
	if [ -n "$1" ]
	then
		local list_failed=
		while [ -n "$1" ]
		do
			[ -n "$list_failed" ] && list_failed="$list_failed, "
			list_failed="${list_failed}$1"
			shift
		done
		show_warning "Preconfigure failed" "Beware: the following steps failed: $list_failed. Please report this. Continue at your own risk"
	fi
	return 0
}
