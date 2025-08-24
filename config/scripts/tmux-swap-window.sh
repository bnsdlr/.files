#!/bin/bash

if [[ $# -lt 2 ]]; then
    tmux swap-window -t $1
    tmux select-window -t $1
else
    tmux swap-window -s $1 -t $2
fi

