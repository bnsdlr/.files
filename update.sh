#!/bin/bash

dotfiles=$(realpath "$0" | sed 's/\(.*\)\/.*/\1/')

cd "$dotfiles"

echo "Pulling updates..."

git pull origin main

./setup.sh
