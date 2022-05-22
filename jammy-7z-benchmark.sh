#!/bin/bash

# cpus = 0.5 (0.25 * 2 core)
# cpus = 1.0 (0.5 * 2 core)
# cpus = 2.0 (2 full core)

docker run --rm -it \
	--name=7zip-tester \
	--memory="1024M" \
	--memory-swap="4096M" \
	--oom-kill-disable \
	--memory-swappiness="60" \
	--cpuset-cpus="0,1" \
	--cpus="2.00" \
	fabiop85/7zip-ubuntu-jammy-tester:latest bash -c "7z b"
