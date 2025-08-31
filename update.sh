#!/usr/bin/env bash

dotfiles=$(realpath "$0" | sed 's/\(.*\)\/.*/\1/')

cd "$dotfiles"

echo "Pulling updates..."

git fetch --prune origin
git reset --hard origin/main
git clean -f -d

./setup.sh
