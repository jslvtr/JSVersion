#!/bin/bash
groupname=`cat ".jsv/groupname.txt"`
for user in $*; do
	gpasswd -d $user $groupname
done
deluser --group --only-if-empty "$groupname"
if [ "$?" -ne "0" ]; then
	echo "Error removing group. Maybe you have missed some accounts?"
	exit 1
fi
exit 0
