#!/usr/bin/env bash

set -e
set -u
set -o pipefail

CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"


###
### Load Library
###
# shellcheck disable=SC1090
. ${CWD}/.lib.sh


# Get all users
ALL_USERS="$( get_subdirs "${CWD}/../submissions" )"

for u in ${ALL_USERS}; do

	# Get all project folders per user
	USER_PROJECTS="$( get_subdirs "${u}" )"

	for p in ${USER_PROJECTS}; do

		# Names for pretty output
		user_base="$( basename "${u}" )"
		project_base="$( basename "${p}" )"
		full_path="submissions/${user_base}/${project_base}"

		# Check PNG directory exists
		if [ ! -d "${p}/png" ]; then
			>&2 echo "[ERR] Required directory missing: ${full_path}/png"
			exit 1
		else
			echo "[OK]  Directory present: ${full_path}/png"
		fi
		# Check RAW directory exists
		if [ ! -d "${p}/raw" ]; then
			>&2 echo "[ERR] Required directory missing: ${full_path}/raw"
			exit 1
		else
			echo "[OK]  Directory present: ${full_path}/raw"
		fi
		# Check README
		regex="^\|\s*[0-9]{4}-[0-9]{2}-[0-9]{2}\s*\|.*${user_base}.*\|.*submissions/${user_base}/${project_base}.*\|.*\|$"
		if ! grep -E "${regex}" ${CWD}/../README.md >/dev/null 2>&1; then
			echo "[Err] Wrong line in Logo table in README"
			run "grep -E '${regex}' ${CWD}/../README.md"
			exit 1
		else
			echo "[OK]  README line looks good: $( grep -Eo "${regex}" ${CWD}/../README.md )"
		fi
	done
done
