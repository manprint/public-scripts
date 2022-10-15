#!/bin/bash

function help() {
	echo "Screen wrapper for bash script"
	echo
	echo "Syntax:"
	echo "bscreen <screen-name> <script>"
	echo
	echo "Example:"
	echo "bscreen test-screen ./example.sh"
}

# Get the options
while getopts ":h" option; do
	case $option in
		h) # display Help
			help
			exit;;
		\?) # incorrect option
			echo "Error: Invalid option"
			exit;;
	esac
done

# Default
if [[ $# -eq 0 ]] ; then
    help
    exit 0
fi

IGNOREOFF=3 screen -S $1 -d -m /bin/bash
screen -r $1 -X stuff $2$(echo -ne '\015') 
screen -ls
