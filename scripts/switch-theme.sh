#!/usr/bin/env bash

ghostty_config_path="$HOME/.config/ghostty/config"

theme="$1"

if [[ "$theme" == "" ]]; then
	exit 1
fi

sed -i '' -e "s/^theme *=.*/theme = \"$theme\"/" "$ghostty_config_path"

if [[ "$OSTYPE" == "darwin"* ]]; then 
	echo "Reloading Ghostty config..."
	osascript <<'EOF'
		tell application "System Events"
			tell process "Ghostty"
				click menu item "Reload Configuration" of menu "Ghostty" of menu bar item "Ghostty" of menu bar 1
			end tell
		end tell
	EOF
else
	echo "Reloading of config is not implemented for $OSTYPE"
fi
