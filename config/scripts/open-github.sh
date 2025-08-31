#!/usr/bin/env bash
# source: https://github.com/SylvanFranklin/.config/blob/df0087d62958add7d78e29192682825adbb98e7c/scripts/open_github.sh

# Open the current repository in the browser
dir=$(tmux run "echo #{pane_start_path}")
cd $dir
url=$(git remote get-url origin) 

# Check if the repository is on GitHub
if [[ $url == *"github.com"* ]]; then
  open $url
else
  echo "This repository is not hosted on GitHub"
fi
