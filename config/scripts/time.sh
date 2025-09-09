#!/usr/bin/env bash

CATEGORIES=(
    "SCHOOL"
    "PROGRAMMING"
    "WASTED"
    "STOP"
)

selected="NO_SELECTION"

if [[ $1 != "" ]]; then
	if [[ " ${CATEGORIES[*]} " =~ " $1 " ]]; then
		selected="$1"
	else
		echo "Invalid selection: $1"
		exit 1
	fi
else
	selected=$(printf "%s\n" "${CATEGORIES[@]}" | sk --margin 10% --color="bw")
fi

[[ $selected == "NO_SELECTION" || $selected == "" ]] && exit 0

if [[ "$selected" == "STOP" ]]; then
    timew stop
	tmux set -g status-right ""
else
    timew start "$selected"
	tmux set -g status-right "$selected"
fi
