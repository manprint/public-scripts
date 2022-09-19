#!/bin/bash

set -o pipefail
set -o functrace

RED=$(tput setaf 1)
YELLOW=$(tput setaf 2)
RESET=$(tput sgr0)
DESC="Deploy Nginx"

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
	mkdir -vp $(pwd)/data/nginx_data
}

function __volume() {
	docker volume create \
		--driver local \
		--opt type=none \
		--opt device=$(pwd)/data/nginx_data \
		--opt o=bind \
		nginx_data
}

function down() {
	docker stop nginx
	docker rm nginx
	docker volume rm nginx_data
}

function up() {
	down
	__mkdir
	__volume
	docker run -dit \
		--name=nginx \
		--hostname=nginx.local.it \
		-p 80:80 \
		-p 443:443 \
		-v nginx_data:/etc/nginx \
		--log-opt max-size=5m \
		--log-opt max-file=3 \
		nginx:latest
}

if [ "_$1" = "_" ]; then
	help
else
	"$@"
fi
