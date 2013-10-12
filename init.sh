#!/bin/bash
#
# Name: `init`
# Author: Jose Salvatierra (jslvtr)
# Date: 1 October 2013
#
# Description
#	This is a file that will initialise a repository in the current folder.
#	It creates a "hidden" folder with the name `.jsv`.
#	You cannot initialise a repository in a folder whose parent folder has a repository initialised.

repoExists() {
	echo "Repository already initialized in current directory!"
	tstmp=`date +%s`
	if [ ! -f ".jsv/log.txt" ]; then
		touch ".jsv/log.txt"
		echo "Logfile initialized :: $tstmp :: $PWD/.jsv" >> ".jsv/log.txt"
	fi
	echo "Tried to initialize repository but it already exists! :: $tstmp :: $PWD" >> ".jsv/log.txt"
	exit 1
}
usage() {
	echo "Usage: $0"
	exit 3
}
if [ -d ".jsv" ]; then
	repoExists
else
	tstmp=`date +%s`
	mkdir ".jsv"
	mkdir ".jsv/stack"
	mkdir ".jsv/commits"
	if [ ! -f ".jsv/log.txt" ]; then
		touch ".jsv/log.txt"
		echo "Logfile initialized :: $tstmp :: $PWD/.jsv" >> ".jsv/log.txt"
	fi
	echo "Repository initialised"
	echo "Repository initialised :: $tstmp :: $PWD." >> ".jsv/log.txt"
	exit 0
fi
