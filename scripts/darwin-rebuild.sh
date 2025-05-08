#!/bin/bash

profile=$1

if [[ "$profile" == "" ]]; then
    profile="$DOTFILES_DEVICE"
fi

if [[ -z "$profile" ]]; then
    echo "No profile provided and \$DOTFILES_DEVICE env var is not set."
    exit 1
fi

echo "Rebuilding profile: $profile"

darwin-rebuild switch --flake "$HOME/.config/nix#$profile"
