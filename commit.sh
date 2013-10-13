#!/bin/bash
#
# Name: `commit`
# Author: Jose Salvatierra (jslvtr)
# Date: 4 October 2013
#
# Description
#	Commits the changes and stores them in the correct folder hierarchy
#	It also unlocks the file, allowing a 777 access for files commited.

#    ______                _   _                 
#   |  ____|              | | (_)                
#   | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
#   |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#   | |  | |_| | | | | (__| |_| | (_) | | | \__ \
#   |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#                                                
#                                                

usage() {
	echo "Usage: $0 [commit_message]"
	exit 1
}

#     _____           _       _   
#    / ____|         (_)     | |  
#   | (___   ___ _ __ _ _ __ | |_ 
#    \___ \ / __| '__| | '_ \| __|
#    ____) | (__| |  | | |_) | |_ 
#   |_____/ \___|_|  |_| .__/ \__|
#                      | |        
#                      |_|        


if [ ! -d ".jsv/stack" ]; then
	echo "Nothing to commit."
	exit 2
else
	cd ".jsv"
	tstmp=$(date +%s)
	touch "stack/$tstmp.message"
	commitmsg="$1"
	default="No commit message"
	output=${commitmsg:=$default}
	echo "$output" > "stack/$tstmp.message"

	### We have all the files to commit inside .jsv/stack.
	### They belong to user who added them, and have modifier 700.
	cd "stack"
	filesToCommit=$(find * -type f -print)
	for file in $filesToCommit; do
		chmod 775 "$file"
		chgrp "jsvgrp" "$file"
	done
	cd ".."
	count=$(ls "commits" | wc -w)
	cd "stack"
	find * -type f -print0 -exec tar zcf "$tstmp.$count.tar.gz" {} +
	cd ".."
	mv "stack/$tstmp.$count.tar.gz" "."
	chgrp "jsvgrp" "$tstmp.$count.tar.gz"
	chmod 775 "$tstmp.$count.tar.gz"
	mv "$tstmp.$count.tar.gz" "commits"
	rm -rf "stack"
	echo "New commit ($output) (count:$count) :: $tstmp :: user $(whoami)" >> "log.txt"
	exit 0
fi
exit 0
