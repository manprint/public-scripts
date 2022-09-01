#!/bin/bash

set -o pipefail
set -o functrace

RED=$(tput setaf 1)
YELLOW=$(tput setaf 2)
RESET=$(tput sgr0)
DESC="Docker Hoster"

trap '__trap_error $? $LINENO' ERR 2>&1

function __trap_error() {
	echo "Error! Exit code: $1 - On line $2"
}

function help() {
	me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
	echo
	echo $DESC
	echo
	echo "List of functions in $YELLOW$me$RESET script: "
	echo
	list=$(declare -F | awk '{print $NF}' | sort | egrep -v "^_")
	for i in ${list[@]}
	do
		echo "Usage: $YELLOW./$me$RESET$RED $i $RESET"
	done
	echo
}

function down() {
	docker stop docker-hoster
	docker rm docker-hoster
}

function up() {
	down
	docker run -dit \
		--name=docker-hoster \
		--hostname=docker-hoster.local.it \
		-v /var/run/docker.sock:/tmp/docker.sock \
		-v /etc/hosts:/tmp/hosts \
		--restart=always \
		dvdarias/docker-hoster
}

if [ "_$1" = "_" ]; then
	help
else
	"$@"
fi
