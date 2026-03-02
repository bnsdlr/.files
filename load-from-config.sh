#!/usr/bin/env bash

GREEN="\x1b[32m"
NC="\x1b[0m"

arg1=$1

dotfiles=$DOTFILES
configdir=$HOME/.config

if [[ "$dotfiles" == "" ]]; then
	dotfiles=$(realpath "$0" | sed 's|\(.*\)/.*|\1|')
fi

echo ".files at $dotfiles"

if [[ "$arg1" == "--all" ]] || [[ "$arg1" == "-a" ]]; then

	for entry in $configdir/*; do
		bname=$(basename "$entry")
		dst="$dotfiles/config"

		if [[ -d "$entry" ]] && [[ -d "$dst" ]]; then
			printf "${GREEN}rsync -ia --delete \"$entry\" \"$dst\"$NC\n"
			rsync -ia --delete "$entry" "$dst"
		elif [[ -f "$entry" ]] && [[ -f "$dst" ]]; then
			printf "${GREEN}cp $entry $dst $NC\n"
			cp "$entry" "$dst/$bname"
		else
			printf "${GREEN}rsync -ia --delete \"$entry\" \"$dst\"$NC\n"
			rsync -ia --delete "$entry" "$dst"
		fi
	done

else

	for entry in $dotfiles/config/*; do
		bname=$(basename "$entry")
		src="$configdir"

		if [[ -d "$entry" ]] && [[ -d "$src" ]]; then
			printf "${GREEN}rsync -ia --delete \"$src\" \"$entry\"$NC\n"
			rsync -ia --delete "$src" "$entry"
		elif [[ -f "$entry" ]] && [[ -f "$src" ]]; then
			printf "${GREEN}cp $src $entry $NC\n"
			cp "$src" "$entry/$bname"
		fi
	done

fi
