#!/bin/bash

usage ()
{
	msg="aif -p <procedurename>  Select a procedure # If given, this *must* be the first option
    -i <dia/cli>         Override interface type (optional)
    -d                   Explicitly enable debugging (/var/log/aif/debug.log) (optional)
    -l                   Explicitly enable logging to file (/var/log/aif/aif.log) (optional)
    -h                   Help: show usage  (optional)\n
If the procedurename starts with 'http://' it will be wget'ed.  Otherwise it's assumed to be a procedure in the VFS tree
If the procedurename is prefixed with '<modulename>/' it will be loaded from user module <modulename>.\n
For more info, see the README which you can find in /usr/share/aif/docs\n
Available procedures:
==core==
`find $LIB_CORE/procedures   -type f             | sed \"s#$LIB_CORE/procedures/##\"           | sort`
==user==
`find $LIB_USER/*/procedures -type f 2>/dev/null | sed \"s#$LIB_USER/\(.*\)/procedures/#\1/#\" | sort`"
	[ -n "$procedure" ] && msg="$msg\nProcedure ($procedure) specific options:\n$var_ARGS_USAGE"

	echo -e "$msg"
}


# $1 module name
load_module ()
{
	[ -z "$1" ] && die_error "load_module needs a module argument"
	log "Loading module $1 ..."
	local path=$LIB_USER/"$1"
	[ "$1" = core ] && path=$LIB_CORE
	
	for submodule in lib #procedure don't load procedures automatically!
	do	
		if [ ! -d "$path/${submodule}s" ]
		then
			# ignore this problem for not-core modules
			[ "$1" = core ] && die_error "$path/${submodule}s does not exist. something is horribly wrong with this installation"
		else
			shopt -s nullglob
			local module
			for module in "$path/${submodule}s"/*
			do
				# I have the habit of editing files while testing, don't source my backup files!
				[[ "$module" == *~ ]] && continue
				module=$(basename "$module")
				load_${submodule} "$1" "$module"
			done
		fi
	done
			
}


# $1 module name 
# $2 procedure name
load_procedure()
{
	[ -z "$1" ] && die_error "load_procedure needs a module as \$1 and procedure as \$2"
	[ -z "$2" ] && die_error "load_procedure needs a procedure as \$2"
	if [ "$1" = 'http' ]
	then
		log "Loading procedure $2 ..."
		local procedure=$RUNTIME_DIR/aif-procedure-downloaded-`basename $2`
		wget "$2" -q -O $procedure >/dev/null || die_error "Could not download procedure $2" 
	else
		log "Loading procedure $1/procedures/$2 ..."
		local procedure=$LIB_USER/"$1"/procedures/"$2"
		[ "$1" = core ] && procedure=$LIB_CORE/procedures/"$2"
	fi
	[ -f "$procedure" ] && source "$procedure" || die_error "Something went wrong while sourcing procedure $procedure"
}


# $1 module name   
# $2 library name
load_lib ()
{
	[ -z "$1" ] && die_error "load_library needs a module als \$1 and library as \$2"
	[ -z "$2" ] && die_error "load_library needs a library as \$2"
	log "Loading library $1/libs/$2 ..."
	local lib=$LIB_USER/"$1"/libs/"$2"
	[ "$1" = core ] && lib=$LIB_CORE/libs/"$2"
	source $lib || die_error "Something went wrong while sourcing library $lib"
}


# $1 phase/worker
# $2 phase/worker name
# $3... extra args for phase/worker (optional)
execute ()
{
	[ -z "$1" -o -z "$2" ] && debug 'MAIN' "execute $@" && die_error "Use the execute function like this: execute <type> <name> with type=phase/worker"
	[ "$1" != phase -a "$1" != worker ] && debug 'MAIN' "execute $@" && die_error "execute's first argument must be a valid type (phase/worker)"
	local PWD_BACKUP=`pwd`
	local object=$1_$2

	if [ "$1" = worker ]
	then
		log "*** Executing worker $2"
		if type -t $object | grep -q function
		then
			shift 2
			$object "$@"
			local ret=$?
			local exit_var=exit_$object
			read $exit_var <<< $ret # maintain exit status of each worker
		else
			die_error "$object is not defined!"
		fi
	elif [ "$1" = phase ]
	then
		log "******* Executing phase $2"
		local exit_var=exit_$object
		read $exit_var <<< 0
		# TODO: for some reason the hack below does not work (tested in virtualbox), even though it really should.  Someday I must get indirect array variables working and clean this up...
		# debug 'MAIN' "\$1: $1, \$2: $2, \$object: $object, \$exit_$object: $exit_object"
		# debug 'MAIN' "declare: `declare | grep -e "^${object}=" | cut -d"=" -f 2-`"
		# props to jedinerd at #bash for this hack.
		# eval phase=$(declare | grep -e "^${object}=" | cut -d"=" -f 2-)
		#debug 'MAIN' "\$phase: $phase - ${phase[@]}"
		unset phase
		[ "$2" = preparation ] && phase=( "${phase_preparation[@]}" )
		[ "$2" = basics      ] && phase=( "${phase_basics[@]}" )
		[ "$2" = system      ] && phase=( "${phase_system[@]}" )
		[ "$2" = finish      ] && phase=( "${phase_finish[@]}" )
		# worker_str contains the name of the worker and optionally any arguments
		for worker_str in "${phase[@]}"
		do
			debug 'MAIN' "Loop iteration.  \$worker_str: $worker_str"
			execute worker $worker_str || read $exit_var <<< $? # assign last failing exit code to exit_phase_<phasename>, if any.
		done
		local ret=${!exit_var}
	fi

	debug 'MAIN' "Execute(): $object exit state was $ret"
	cd $PWD_BACKUP
	return $ret
}


# check if a phase/worker executed sucessfully
# returns 0 if ok, the phase/workers' exit state otherwise (and returns 1 if not executed yet)
# $1 phase/worker
# $2 phase/worker name
ended_ok ()
{
	[ -z "$1" -o -z "$2" ] && die_error "Use the ended_ok function like this: ended_ok <type> <name> with type=phase/worker"
	[ "$1" != phase -a "$1" != worker ] && die_error "ended_ok's first argument must be a valid type (phase/worker)"
	object=$1_$2
	exit_var=exit_$object
	debug 'MAIN' "Ended_ok? -> Exit state of $object was: ${!exit_var} (if empty. it's not executed yet)"
	[ "${!exit_var}" = '0' ] && return 0
	[ "${!exit_var}" = '' ] && return 1
	return ${!exit_var}
}


depend_module ()
{
	load_module "$1"
}


depend_procedure ()
{
	load_procedure "$1" "$2"
}


start_process ()
{
	execute phase preparation
	execute phase basics
	execute phase system
	execute phase finish
}


show_report ()
{
	data="Execution Report:"
	data="$data\n-----------------"
	for phase in preparation basics system finish
	do
		object=phase_$phase
		exit_var=exit_$object
		local ret=${!exit_var}
		[ "$ret" = "0" ] && data="$data\nPhase $phase: Success"
		[ "$ret" = "0" ] || data="$data\nPhase $phase: Failed"
		eval phase_array=$(declare | grep -e "^${object}=" | cut -d"=" -f 2-)
		for worker_str in "${phase_array[@]}"
		do
			worker=${worker_str%% *}
			exit_var=exit_worker_$worker
			ret=${!exit_var}
			case "$ret" in
				"")  data="$data\n > Worker $worker: Skipped";;
				"0") data="$data\n > Worker $worker: Sucess";;
				*)   data="$data\n > Worker $worker: Failed";;
			esac
		done
	done
	inform "$data"
}


start_installer ()
{
	log "################## START OF INSTALLATION ##################"
}


# use this function to stop the installation procedure.
# $1 exit code (optional)
stop_installer ()
{
	log "-------------- STOPPING INSTALLATION ----------"
	cleanup_runtime
	[ "$var_UI_TYPE" = dia ] && clear
	exit $1
}
