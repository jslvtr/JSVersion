#!/bin/bash
#
# Name: `revert`
# Author: Jose Salvatierra (jslvtr)
# Date: 13 October 2013
#
# Description
#	This is a script that will revert your original repository home to the commit you choose.
#	This script prompts the user whether he/she wants to revert by 'x' commits,
#	Or whether he/she wants to revert to commit 'x'.

#    ______                _   _                 
#   |  ____|              | | (_)                
#   | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
#   |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#   | |  | |_| | | | | (__| |_| | (_) | | | \__ \
#   |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#                                                
#                                                

askUser() {
	echo "Do you wish to revert by _x_ commits (1) or to commit _x_ (2)?"
	read choice
}

usage() {
	echo "Please do not provide any parameters."
	echo "Usage: $0"
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

if [ "$#" -ne "0" ]; then
	usage
fi

askUser

if [ "$choice" -e "2" ]; then
	### User wants to go back to commit _x_
	cd ".jsv"
	mkdir "temp-struct"
	latest=$(ls "commits" | sort)
	count=$(ls "commits" | wc -w)
	index=0
	for commit in $latest; do
		if [ "$index" -lt "$choice" ]; then
			if [ -d "temp-commit" ]; then
				rm -rf "temp-commit"
			fi
			mkdir "temp-commit"
			tar -zxf "commits/$commit" -C "temp-commit"
			cd "temp-commit"
			commitFiles=$(find * -type f -print)
			cd ".."
			for commitFile in $commitFiles; do
				commitFileName=$(basename "$commitFile")
				commitFileDirectory="$(dirname "$commitFile")/"
				if [ ! -d "temp-struct/$commitFileDirectory" ]; then
					mkdir -p "temp-struct/$commitFileDirectory"
				fi
				if [ ! -f "temp-struct/$commitFileDirectory$commitFileName" ]; then
					touch "temp-struct/$commitFileDirectory$commitFileName"
				fi
				patch -R "temp-struct/$commitFileDirectory$commitFileName" "temp-commit/$commitFile"
					
			done
		fi
	let index++
	done
	cd ".."
	toRemove=$(find . -maxdepth 1 ! -name '.*')
	for tR in $toRemove; do
		rm -rf "$tR"
	done
	cp -rf ".jsv/temp-struct/*" "."
	rm -rf "temp-struct"
elif [ "$choice" -e "1" ]; then
	### User wants to go back by _x_ commits
	
else
	### User doesn't know what he wants; exit
	echo "No correct choice selected."
	exit 2
fi
