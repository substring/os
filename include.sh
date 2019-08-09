#!/bin/bash

# useful variables
export _OUTPUT=
# Check we are running in a pipeline, that is in CI
if [[ -d ./work ]] ; then
  _OUTPUT=./work/output
elif [[ -d /work ]] ; then
  _OUTPUT=/work/output
else
  echo "ERROR: could not define work/output folder" >&2
  exit 1
fi

logstamp() {
  #LC_NUMERIC="en_US.UTF-8" printf "[%12.2f]" `awk '{printf $1}' /proc/uptime`
  printf "[%14d]" "$SECONDS"
}

log () {
	echo -e "\e[1m$(logstamp) \e[21m\e[7m$* \e[0m"
}

#
# log and die
#
die () {
  log "${@:2}"
  exit "$1"
}

#
# make a single built_packages file
#
built_packages_list() {
  filename="$_OUTPUT"/unique_packages.txt
  cat "$_OUTPUT"/built_packages* | sort | uniq > "$filename"
  echo $filename
}
