#!/usr/bin/env bash

config="$HOME/.config"
ghostty_config_path="$config/ghostty/config"

theme="$1"

if [[ "$theme" == "" ]]; then
	exit 1
fi

sed -i '' -e "s/^theme *=.*/theme = \"$theme\"/" "$ghostty_config_path"

if [[ "$OSTYPE" == "darwin"* ]]; then 
	echo "Reloading Ghostty config..."
	osascript "$config/scripts/reload-ghostty-config.scpt"
else
	echo "Reloading of config is not implemented for $OSTYPE"
fi
