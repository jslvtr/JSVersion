#!/bin/bash -x

if [ ! -n "$1" ]; then
	echo "Not enough arguments passed."
	exit 1
fi
toRun="./add.sh"
shift
space=" "
if [ "$1" == "" ]; then
	space=""
fi
if [ -x "$toRun" ]; then
	exec "$toRun" "$@"
fi
