#!/bin/bash

profile=$1

if [[ "$profile" == "" ]]; then
    echo "Please provide a profile add: \" <profile_name>\" to your command."
    exit 1
fi

darwin-rebuild switch --flake "$HOME/.config/nix#$profile"
