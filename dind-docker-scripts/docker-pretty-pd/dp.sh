#!/bin/bash

docker run -it --name=docker-pretty-ps --rm -v /var/run/docker.sock:/var/run/docker.sock fabiop85/docker-pretty-ps:latest docker-pretty-ps -a $@
