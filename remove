#!/bin/bash
#
# Name: `remove`
# Author: Jose Salvaiterra (jslvtr)
# Date: 4 October 2013
#
# Description
#	This is a file that lets you remove files from the current `add` area (the "stack" folder).
#	If the file doesn't exist, then it exits with code 1.
#

#    ______                _   _                 
#   |  ____|              | | (_)                
#   | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
#   |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#   | |  | |_| | | | | (__| |_| | (_) | | | \__ \
#   |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#                                                
#                                                

#########
#
# `usage`
# Method to display how to correctly use the script.
#
#########
usage() {
	echo "One of the parameters provided is not a file..."
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

### If one of the parameters isn't a file, then exit.
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
### If the stack folder doesn't exist, then we can't possibly have anything to remove. Exit (code 3)
if [ ! -d ".jsv/stack" ]; then
	echo "No files to remove."
	exit 3
fi
for file in "$@"; do
	cd ".jsv/stack"
	filesInStack=$(find * -type f -print)
	fileDir="$(dirname "$file")/"
	cd "../.."
	for stackFile in $filesInStack; do
                stackFileDirectory="$(dirname "$stackFile")/"
                stackFileName=$(basename "$stackFile")
                if [[ "$stackFileName" == $(basename "$file") && "$stackFileDirectory" == $fileDir ]]; then
			rm ".jsv/stack/$stackFileDirectory$stackFileName"
			if [ "$?" -ne "0" ]; then
				echo "Error removing file."
			fi	
		fi
	done
done
exit 0
