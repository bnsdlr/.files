#!/usr/bin/env bash

dotfiles=$(realpath "$0" | sed 's/\(.*\)\/.*/\1/')

cd "$dotfiles"

if git status | grep -i "changes to be committed" >/dev/null; then 
	if [[ "$1" != "-f" ]]; then
		echo "This would discard all changes, use -f to update anyway."
		exit 1
	fi
fi

echo "Pulling updates..."

git fetch --prune origin
git reset --hard origin/master
git clean -f -d

./setup.sh
