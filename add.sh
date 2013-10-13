#!/bin/bash
#
# Name: `add`
# Author: Jose Salvatierra (jslvtr)
# Date: 4 October 2013
#
# Description
#	This is a file that lets you add files to the current commit area.
#	What happens in the background is that files are added to the .jsv folder
#	And locked by changing the user permissions to only allow the owner to write.

#    ______                _   _                 
#   |  ____|              | | (_)                
#   | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
#   |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#   | |  | |_| | | | | (__| |_| | (_) | | | \__ \
#   |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#                                                
#                                                

##########
#
# `usage`
# Method to display how to correctly use the script.
#
##########
usage() {
	echo "One of the parameters provided is not a file."
	echo "Usage: $0 [file1 file2 ...]"
	exit 1
}

#   _____           _       _   
#  / ____|         (_)     | |  
# | (___   ___ _ __ _ _ __ | |_ 
#  \___ \ / __| '__| | '_ \| __|
#  ____) | (__| |  | | |_) | |_ 
# |_____/ \___|_|  |_| .__/ \__|
#                    | |        
#                    |_|

### If we do not have a file passed as an argument, then exit.
for fil in "$@"; do
	if [ ! -f "$fil" ]; then
		usage
	fi
done
### If the repository directory doesn't exist, then it hasn't been initialized. Exit.
if [ ! -d ".jsv" ]; then
	echo "Repository not initialized in this directory!"
	exit 2
fi
### If the stack folder doesn't exist (where the files are stored before being committed), then we create it.
if [ ! -d ".jsv/stack" ]; then
	mkdir ".jsv/stack"
fi
for file in "$@"; do
	### We find the last commit: (ls | sort -r | head -1) gives us the latest commit first
	#	latest=`ls ".jsv/commit" | sort -r`
	latest=$(ls ".jsv/commits" | sort)
	
	touch ".jsv/current.txt"
	for commit in $latest; do
		### Here we are looping through the commits
		mkdir ".jsv/temp-commit"
		tar -zxf ".jsv/commits/$commit" -C ".jsv/temp-commit"
		
		cd ".jsv/temp-commit"
		commitFiles=$(find * -type f -print)
		cd "../.."
		for commitFile in $commitFiles; do
			commitFileName=$(basename "$commitFile")
			commitFileDirectory="$(dirname "$commitFile")/"
			if [[ "$commitFileName" == $(basename "$file") && "$commitFileDirectory" == $(dirname "$file") ]]; then
				### How to do diff? Do I need to patch all the previous diffs?
				patch -R ".jsv/current.txt" ".jsv/temp-commit/$commitFileDirectory$commitFileName"
			fi	
		done
		### Remove the "temp-commit" folder since it is re-made at every iteration of the loop.
		rm -rf ".jsv/temp-commit"
	done
	### Here we have the file as it was (fully) the last commit. So we diff it.
	newdir=$(dirname "$file")
	newfilename=$(basename "$file")
	newfile="$newdir/$newfilename"
	mkdir -p ".jsv/stack/$newdir"
	touch ".jsv/stack/$newfile"
	### We calculate the diff with "current.txt". This file could be empty, so the diff would then be all of our file (in the first commit).
	diff -u "$file" ".jsv/current.txt" >> ".jsv/stack/$newfile"
	tstmp=$(date +%s)
	echo "Created diff file .jsv/stack/$newfile :: $tstmp" >> ".jsv/log.txt"
	### LOCK THE FILE UNTIL IT GETS COMMITTED
	chmod 700 ".jsv/stack/$newfile"
	user=$(whoami)
	chown "$user" ".jsv/stack/$newfile"
	### Remove "current.txt" as it is the previous version of the file that is now added to "stack".
	rm ".jsv/current.txt"
done
exit 0
