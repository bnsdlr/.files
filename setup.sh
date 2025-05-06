#!/bin/bash

dotfiles=$(pwd)

export DOTFILES=$dotfiles

export="export DOTFILES=$dotfiles"
if [[ ! $(cat "$HOME/.zshrc" | grep "$export" >> /dev/null; echo $?) -eq 0 ]]; then
    echo "Adding line to .zshrc: $export"
    echo -e "\n$export" >> $HOME/.zshrc
fi

if [[ ! -f "$HOME/.config/.managed-by-dotfiles" ]]; then
    echo "Making copy of ~/.config to ~/.config-bf-dotfiles"
    cp -r "$HOME/.config" "$HOME/.config-bf-dotfiles"
fi

for file in $(find $dotfiles -name 'links.prop'); do
    links=$(<$file)
    for link in $links; do
        link=$(eval echo "$link")
        from=$(echo "$link" | cut -d "=" -f 1)
        to=$(echo "$link" | cut -d "=" -f 2)
        printf "\x1b[32mRsyncing $from to $to...\x1b[0m\n"
        rsync -a --delete "$from" "$to"
    done
done
