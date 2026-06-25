#!/usr/bin/env bash

dir=$1
name=$2

if $name; then
	name=$(basename "$dir" | tr ' .' '_')
fi

if ! tmux has-session -t "$name"; then
    tmux new-session -ds "$name" -c "$dir"
    tmux select-window -t "$name:1"
fi

if [[ "$TMUX" == "" ]]; then
    tmux attach -t "$name"
else
    tmux switch-client -t "$name"
fi

