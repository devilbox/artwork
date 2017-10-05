#!/usr/bin/env bash

set -e
set -u
set -o pipefail

###
### Variables
###

IFS=$'\n'

# Current directory
CWD="$( dirname "${0}" )"

declare -a TESTS=()


###
### Run tests
###

# Get all [0-9]+.sh test files
FILES="$( find ${CWD} -regex "${CWD}/[0-9].+\.sh" | sort -u )"
for f in ${FILES}; do
	TESTS+=("${f}")
done

# Start a single test
if [ "${#}" -eq "1" ]; then
	sh -c "${TESTS[${1}]}"

# Run all tests
else
	for i in "${TESTS[@]}"; do
		echo "sh -c ${CWD}/${i}"
		sh -c "${i}"
	done
fi
