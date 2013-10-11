#!/bin/bash
#
# Name: `commit`
# Author: Jose Salvatierra (jslvtr)
# Date: 4 October 2013
#
# Description
#	Commits the changes and stores them in the correct folder hierarchy
#	It also unlocks the file, allowing a 777 access for files commited.

usage() {
	echo "Usage: $0 [commit_message]"
	exit 1
}

if [ ! -d ".jsv/stack" ]; then
	echo "Nothing to commit."
	exit 2
else
	cd ".jsv"
	tstmp=`date +%s`
	touch "stack/$tstmp.message"
	commitmsg="$1"
	$default="No commit message"
	output=${commitmsg:=$default}
	echo "$output" > "stack/$tstmp.message"

	### We have all the files to commit inside .jsv/stack.
	### They belong to user who added them, and have modifier 700.
	for file in `ls "stack"`; do
		chmod 775 "$file"
		chgrp "jsvgrp" "$file"
	done
	count=`ls "commits" | wc -w`
	tar -zcvf "$tstmp.$count.tar.gz" "stack/*"
	chgrp "jsvgrp" "$tstmp.$count.tar.gz"
	chmod 775 "$tstmp.$count.tar.gz"
	mv "$tstmp.$count.tar.gz" "commits"
	rm "stack/*"
	echo "New commit ($output) (count:$count) :: $tstmp :: user $(whoami)" >> "log.txt"
	exit 0