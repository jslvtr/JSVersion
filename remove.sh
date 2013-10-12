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
	filesInStack=$(ls ".jsv/stack")
	for stackFile in $filesInStack; do
		stackFileArray=(${stackFile//../ })
                stackFileDirectory=${stackFileArray[0]}
                stackFileName=${stackFileArray[1]}
                if [ "$stackFileName" == "" ]; then
                        stackFileName="$stackFileDirectory"
                        if [[ "$stackFileName" == $(basename "$file") ]]; then
                        	rm ".jsv/stack/$stackFile"
				if [ "$?" -ne "0" ]; then
					echo "Error removing file."
				fi
			fi
               else
                        if [[ "$stackFileName" == $(basename "$file") && "$stackFileDirectory" == $(dirname "$file") ]]; then
                        	rm ".jsv/stack/$stackFile"
				if [ "$?" -ne "0" ]; then
					echo "Error removing file."
				fi	
			fi
                fi
	done
done
exit 0
