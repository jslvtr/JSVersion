#!/bin/bash
groupname="jsvgrp"
if [ "$#" -ne 0 ]; then
        groupname="$1"
        touch ".jsv/groupname.txt"
        echo "$groupname" >> ".jsv/groupname.txt"
fi
groupadd "$groupname"
if [ "$?" -ne "0" ]; then
        echo "Error creating group ($groupname)"
        echo "Error creating group ($groupname) :: $tstmp." >> ".jsv/log.txt"
        exit 1
fi
newuser="$2"
if [ -n "$newuser" ]; then
        usermod -G "$groupname" -a "$newuser"
fi
echo "JSV installed successfully. Group $groupname created and user $newuser added."
exit 0
