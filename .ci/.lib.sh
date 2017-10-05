#!/usr/bin/env bash

set -e
set -u
set -o pipefail


###
### Run
###
run() {
	_cmd="${1}"

	_red="\033[0;31m"
	_green="\033[0;32m"
	_yellow="\033[0;33m"
	_reset="\033[0m"
	_user="$(whoami)"

	printf "${_yellow}[%s] ${_red}%s \$ ${_green}${_cmd}${_reset}\n" "$(hostname)" "${_user}"
	sh -c "LANG=C LC_ALL=C ${_cmd}"
}


###
### Get sub directories
###
function get_subdirs() {
	local path="${1}"
	find "${path}" -type d \! -name "$( basename "${path}" )" -prune | sort
}


