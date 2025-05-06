#!/bin/bash

flag=$1

dotfiles=$(pwd)

export DOTFILES=$dotfiles

# export="export DOTFILES=$dotfiles"
# if [[ ! $(cat "$HOME/.zshrc" | grep "$export" >> /dev/null; echo $?) -eq 0 ]]; then
#     echo "Adding line to .zshrc: $export"
#     echo -e "\n$export" >> $HOME/.zshrc
# fi

config_bf_dofiles="$HOME/.config-bf-dotfiles"
zshrc_bf_dofiles="$HOME/.zshrc-bf-dotfiles"

if [[ "$flag" == "-r" ]]; then
    read -p "Are you shure you want to remove the dotfiles and get your old config back? [y/N]: " continue
    continue=${continue:-n}

    if [[ "$continue" == "y" ]]; then
        if [[ -d "$config_bf_dofiles" ]]; then
            echo "Resetting .config..."
            rsync -a --delete "$config_bf_dofiles/" "$HOME/.config/"
            rm -rf "$config_bf_dofiles"
        fi

        if [[ -f "$zshrc_bf_dofiles" ]]; then
            echo "Resetting .zshrc..."
            rsync -a --delete "$zshrc_bf_dofiles" "$HOME/.zshrc"
            rm "$zshrc_bf_dofiles"
        fi
    else
        echo "Exiting"
    fi
else
    if [[ ! -f "$HOME/.config/.managed-by-dotfiles" ]]; then
        echo "Making copy of $HOME/.config to $config_bf_dofiles"
        cp -r "$HOME/.config" "$config_bf_dofiles"
    fi
    
    if [[ ! -f "$zshrc_bf_dofiles" ]]; then
        echo "Making copy of $HOME~/.zshrc to $zshrc_bf_dofiles"
        cp "$HOME/.zshrc" "$zshrc_bf_dofiles"
    fi
    
    for file in $(find $dotfiles -name 'links.prop'); do
        while IFS="" read -r link || [ -n "$p" ]; do
            if [[ ! "$link" == "#"* ]] && [[ "$link" == *"="* ]]; then
                link=$(eval echo "$link")
                from=$(echo "$link" | cut -d "=" -f 1)
                to=$(echo "$link" | cut -d "=" -f 2)
                printf "\x1b[32mRsyncing $from to $to...\x1b[0m\n"
                rsync -a --delete "$from" "$to"
            fi
        done <$file
    done
fi
