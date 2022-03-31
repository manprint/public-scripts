.PHONY: help \
		install_bscreen \
		install_docker-save-xz \
		install_all

TITLE_MAKEFILE=Install Personal Scripts

SHELL=/bin/bash
#.SHELLFLAGS += -e
#.ONESHELL: hello world

export CURRENT_DIR := $(shell pwd)
export RED := $(shell tput setaf 1)
export RESET := $(shell tput sgr0)
export DATE_NOW := $(shell date)

.DEFAULT := help

help:
	@printf "\n$(RED)$(TITLE_MAKEFILE)$(RESET)\n"
	@awk 'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ \
	{ printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo

##@ Scripts

install_bscreen: ## Install Bscreen
	@sudo curl -v -sSL https://raw.githubusercontent.com/manprint/public-scripts/master/bscreen -o /usr/local/bin/bscreen
	@sudo chmod +x /usr/local/bin/bscreen

install_docker_save_xz: ## Install Docker Save Xz
	@sudo curl -v -sSL https://raw.githubusercontent.com/manprint/public-scripts/master/docker-save-xz -o /usr/local/bin/docker-save-xz
	@sudo chmod +x /usr/local/bin/docker-save-xz

##@ Install All

install_all: install_bscreen install_docker_save_xz ## Install all scripts
