#!/bin/bash

set -o pipefail
set -o functrace

RED=$(tput setaf 1)
YELLOW=$(tput setaf 2)
RESET=$(tput sgr0)
DESC="Docker Portainer"

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

function __mkdir() {
	mkdir -vp $(pwd)/data/portainer
}

function down() {
	docker stop portainer
	docker rm portainer
}

function up() {
	down
	docker run -dit \
	-p 9000:9000 \
	--name portainer \
	--restart=always \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $(pwd)/data/portainer:/data \
	portainer/portainer-ce:latest
}


if [ "_$1" = "_" ]; then
	help
else
	"$@"
fi
