#!/bin/bash
groupname="jsvgrp"
if [ "$#" == "2" ]; then
        groupname="$1"
	newuser="$2"
elif [ "$#" == "1" ]; then
	newuser="$1"
else
	echo "Too many or too few arguments!"
	exit 2
fi
groupadd "$groupname"
if [ "$?" -ne "0" ]; then
        echo "Error creating group ($groupname)"
        echo "Error creating group ($groupname) :: $tstmp." >> ".jsv/log.txt"
        exit 1
fi
if [ -n "$newuser" ]; then
        usermod -G "$groupname" -a "$newuser"
fi

touch ".jsv/groupname.txt"
echo "$groupname" >> ".jsv/groupname.txt"
echo "JSV installed successfully. Group $groupname created and user $newuser added." >> ".jsv/log.txt"
echo "JSV installed successfully."
exit 0
