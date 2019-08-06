#!/bin/bash


###### Set some default variables ######
TITLE="Groovy Arcade Linux Setup"
LOG="/dev/tty7"
LIB_CORE=/opt/gasetup/core
LIB_USER=/opt/gasetup/user
RUNTIME_DIR=/tmp/gasetup
LOG_DIR=/var/log
LOGFILE=$LOG_DIR/gasetup.log
DISCLAIMER="This setup has the potential to remove disk drives and lose data, backup first."
export LC_COLLATE=C # for consistent sorting behavior

###### Early bootstrap ######

# load the lib-ui, it is one we need everywhere so we must load it early.
source $LIB_CORE/libs/lib-ui.sh || { echo "Something went wrong while sourcing library $LIB_CORE/libs/lib-ui.sh" >&2 ; exit 2; }
ui_init
# load the lib-flowcontrol. we also need some of it's functions early (like usage()).
source $LIB_CORE/libs/lib-flowcontrol.sh || { echo "Something went wrong while sourcing library $LIB_CORE/libs/lib-flowcontrol.sh" >&2 ; exit 2; }
# lib-misc. we need it early, at least for check_is_in whis is used by the debug function.
source $LIB_CORE/libs/lib-misc.sh || { echo "Something went wrong while sourcing library $LIB_CORE/libs/lib-misc.sh" >&2 ; exit 2; }

# default function to process additional arguments. can be overridden by procedures.
process_args ()
{
	true
}




###### perform actual logic ######
echo "Welcome to $TITLE"

[[ $EUID -ne 0 ]] && die_error "You must have root privileges to run Groovy Arcade Setup"

mount -o remount,rw / &>/dev/null 
cleanup_runtime
needed_pkgs_fs= # will hold extra needed packages for blockdevices/filesystems, populated when the Fs'es are created

### Set configuration values ###
# note : you're free to use or ignore these in your procedure.  probably you want to use these variables to override defaults in your configure worker

#DEBUG: don't touch it. it can be set in the env
arg_ui_type=
LOG_TO_FILE=0
module=
procedure=



# in that case -p needs to be the first option, but that's doable imho
# an alternative would be to provide an argumentstring for the profile. eg gasetup -p profile -a "-a a -b b -c c"

# you can override these variables in your procedures
var_OPTS_STRING=""
var_ARGS_USAGE=""

# Processes args that were not already matched by the basic rules.
process_args ()
{
	# known options: we don't know any yet
	# return 0

	# if we are still here, we didn't return 0 for a known option. hence this is an unknown option
	usage
	exit 5
}


# Check if the first args are -p <procedurename>.  If so, we can load the procedure, and hence $var_OPTS_STRING and process_args can be overridden
if [ "$1" = '-p' ]
then
	[ -z "$2" ] && usage && exit 1
	# note that we allow procedures like http://foo/bar. module -> http:, procedure -> http://foo/bar.
	if [[ $2 =~ ^http:// ]]
	then
		module=http
		procedure="$2"
	elif grep -q '\/' <<< "$2"
	then
		#user specified module/procedure
		module=`dirname "$2"`
		procedure=`basename "$2"`
	else
		module=core
		procedure="$2"
	fi

	shift 2
fi

# If no procedure given, bail out
[ -z "$procedure" ] && usage && exit 5

load_module core
[ "$module" != core -a "$module" != http ] && load_module "$module"
# this is a workaround for bash <4.2, where associative arrays are inherently local,
# so we must source these variables in the main scope
source $LIB_CORE/libs/lib-blockdevices-filesystems.sh

load_procedure "$module" "$procedure"

while getopts ":i:dlp:$var_OPTS_STRING" OPTION
do
	case $OPTION in
	i)
		[ -z "$OPTARG" ] && usage && exit 1 #TODO: check if it's necessary to do this. the ':' in $var_OPTS_STRING might be enough
		[ "$OPTARG" != cli -a "$OPTARG" = !dia ] && die_error "-i must be dia or cli"
		arg_ui_type=$OPTARG
		ui_init
		;;
	d)
		export DEBUG=1
		LOG_TO_FILE=1
		;;
	l)
		LOG_TO_FILE=1
		;;
	p)
		die_error "If you pass -p <procedurename>, it must be the FIRST option"
		;;
	h)
		usage
		exit
		;;
	?)
		# If we hit something elso, call process_args
		process_args -$OPTION $OPTARG # you can override this function in your profile to parse additional arguments and/or override the behavior above
		;;
	esac

done


# Set pacman vars.  allow procedures to have set $var_TARGET_DIR (TODO: look up how delayed variable substitution works. then we can put this at the top again)
# flags like --noconfirm should not be specified here.  it's up to the procedure to decide the interactivity
# NOTE: Pacman will run with currently active locale, if you want to parse output, you should prefix with LANG=C
PACMAN=pacman
PACMAN_TARGET="pacman --root $var_TARGET_DIR --config /tmp/pacman.conf"

start_installer

start_process

stop_installer
