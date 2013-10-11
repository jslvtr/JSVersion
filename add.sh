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

##########
#
# `usage`
# Method to display how to correct use the script.
#
##########
usage() {
	echo "One of the parameters provided is not a file."
	echo "Usage: $0 [file1 file2 ...]"
	exit 1
}

### If we do not have a file passed as an argument, then exit.
for fil in $*; do
	if [ ! -f "$fil" ]; then
		usage
	fi
done
### If the repository directory doesn't exist, then it hasn't been initialized. Exit.
if [ ! -d ".jsv" ]; then
	echo "Repository not initialized in this directory!"
	exit 2
fi
cd ".jsv"
### If the stack folder doesn't exist (where the files are stored before being committed), then we create it.
if [ ! -d "stack" ]; then
	mkdir "stack"
fi
for file in $*; do
	### We find the last commit: (ls | sort -r | head -1) gives us the latest commit first
	#	latest=`ls ".jsv/commit" | sort -r`
	latest=`ls "commit" | sort`
	touch "current.txt"
	for commit in $latest; do
		### Here we are looping through the commits
		mkdir "temp-commit"
		tar -zxvf $latest "temp-commit"
		### temp-commit has DIRECTORY..FILE
		commitFiles=`ls "temp-commit"`
		for commitFile in $commitFiles; do
			commitFileArray=(${commitFile//../ })
			commitFileDirectory=${commitFileArray[0]}
			commitFileName=${commitFileArray[1]}
			if [[ "$commitFileName" == $(basename "$file") && "$commitFileDirectory" == $(dirname "$file") ]]; then ###THIS IS ACTUALLY GONNA WORK
				### How to do diff? Do I need to patch all the previous diffs?
				patch -f "current.txt" "$commitFile"
			fi
		done
		### Remove the "temp-commit" folder since it is re-made at every iteration of the loop.
		rm -rf "temp-commit"
	done
	### Here we have the file as it was (fully) the last commit. So we diff it.
	newdir=`$(dirname "$file")`
	newfilename=`$(basename "$file")`
	concat=".."
	newfile="$newdir$concat$newfilename"
	touch "stack/$newfile"
	### We calculate the diff with "current.txt". This file could be empty, so the diff would then be all of our file (in the first commit).
	diff --normal "$file" "current.txt" >> "stack/$newfile"
	### LOCK THE FILE UNTIL IT GETS COMMITTED
	chmod 700 "stack/$newfile"
	user=`whoami`
	chown "$user" "stack/$newfile"
	### Remove "current.txt" as it is the previous version of the file that is now added to "stack".
	rm "current.txt"
done
exit 0
