#!/usr/bin/env bash

FILE_COLOR=""
DIR_COLOR="\x1b[1;34m"
NC="\x1b[0m"

print_contents() {
	local dir=$1
	local lvl=$2

	local space=$((lvl * 4))
	local dir_space=$(((lvl - 1) * 4))

	if (( $lvl != 0)); then
		local bname=$(basename "$dir")
		printf "%-${dir_space}s${DIR_COLOR}$bname/$NC\n"
	fi

	for entry in "$dir"/*; do
		if [[ -d "$entry" ]]; then
			print_contents "$entry" $((lvl + 1))
		else
			local bname=$(basename "$entry")
			printf "$FILE_COLOR%-${space}s%s$NC\n" "" "$bname"
		fi
	done
}

path="."

if [[ $1 != "" ]] && [[ $1 != "-"* ]]; then
	path="$1"
fi

if [[ "$1" == "-w" ]]; then
	secs=$2
	secs=${secs:-1}
	while true; do
		clear
		print_contents "$path" 0
		sleep $secs
	done
else
	print_contents "$path" 0
fi
