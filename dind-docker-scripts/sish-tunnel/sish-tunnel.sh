#!/bin/bash

set -o pipefail
set -o functrace

RED=$(tput setaf 1)
YELLOW=$(tput setaf 2)
RESET=$(tput sgr0)
DESC="Start Sish Tunnel Manager With Host sshkey"

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
	docker stop sish-client-debian
	docker rm sish-client-debian
}

# 1. mount local `.ssh folder inside container`; path internal `/home/debian/.ssh`
# 2. specify in env the internal path and name of ssh-privkey (base path is /home/debian/.ssh)
# 3. SERVER_ALIVE_INERVAL => Ping server every 4 seconsd
# 4. SERVER_ALIVE_COUNT_MAX => Number of pings attempts => Timeout = SERVER_ALIVE_INTERVAL * SERVER_ALIVE_COUNT_MAX

function up() {
	down
	docker run -dit \
		-v /home/ubuntu/.ssh:/home/debian/.ssh \
		--name=sish-client-debian \
		--restart=always \
		-e SISH_SSH_SERVER_PORT="2222" \
		-e SUBDOMAIN="my_subdomain" \
		-e LOCAL_HOST="local_host_ip" \
		-e LOCAL_PORT="local_host_port" \
		-e SERVER="sish.adiprint.it" \
		-e INTERNAL_SSHPRIVKEY_PATH="/home/debian/.ssh/id_rsa" \
		-e SERVER_ALIVE_INTERVAL="4" \
		-e SERVER_ALIVE_COUNT_MAX="450" \
		fabiop85/sish-client-debian:latest-pkey-mounted
}

if [ "_$1" = "_" ]; then
	help
else
	"$@"
fi
