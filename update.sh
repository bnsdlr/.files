#!/bin/bash

dotfiles=$(realpath "$0" | sed 's/\(.*\)\/.*/\1/')

cd "$dotfiles"

echo "Pulling updates from github..."

git pull origin main

echo "Pulled changes from github, executing setup.sh..."

./setup.sh
