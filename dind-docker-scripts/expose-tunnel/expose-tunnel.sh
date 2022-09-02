#!/bin/bash

# Help
# Description:
#  Share a local url with a remote expose server
#
# Usage:
#  share-cwd [options] [--] [<host>]
#
# Arguments:
#  host
#
# Options:
#      --subdomain[=SUBDOMAIN]
#      --auth[=AUTH]                (TOKEN)
#      --basicAuth[=BASICAUTH]      (HTTP_ACCESS)
#      --dns[=DNS]
#      --domain[=DOMAIN]
#      --server[=SERVER]
#      --server-host[=SERVER-HOST]
#      --server-port[=SERVER-PORT]
#  -h, --help                       Display help for the given command. When no command is given display help for the share-cwd command
#  -q, --quiet                      Do not output any message
#  -V, --version                    Display this application version
#      --ansi|--no-ansi             Force (or disable --no-ansi) ANSI output
#  -n, --no-interaction             Do not ask any interactive question
#      --env[=ENV]                  The environment the command should run under
#  -v|vv|vvv, --verbose             Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug

set -o pipefail
set -o functrace

RED=$(tput setaf 1)
YELLOW=$(tput setaf 2)
RESET=$(tput sgr0)
DESC="Expose Client Managements"

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

CLIENT_NAME="expose-test"
LOCAL_HOST_PORT="http://my-host:my-port"
SERVER_HOST="expose.adiprint.it"
SERVER_PORT="" # implicit 80
SUBDOMAIN="my-subdomain"
BASIC_AUTH="" # username:password
TOKEN="secret-user-token"

function down() {
	docker stop $CLIENT_NAME
	docker rm $CLIENT_NAME
}

function up() {
	down
	docker run -dit \
		--name=$CLIENT_NAME \
		--restart=always \
		fabiop85/expose:client-alpine-v2.3.0 \
		share $LOCAL_HOST_PORT \
		--server-host=$SERVER_HOST \
		--server-port=$SERVER_PORT \
		--subdomain=$SUBDOMAIN \
		--basicAuth=$BASIC_AUTH \
		--auth=$TOKEN
	sleep 5
	docker logs $CLIENT_NAME
}

if [ "_$1" = "_" ]; then
	help
else
	"$@"
fi
