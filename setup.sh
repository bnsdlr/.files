#!/bin/bash

flag=$1

dotfiles=$(realpath "$0" | sed 's|\(.*\)/.*|\1|')

export DOTFILES=$dotfiles

config_bf_dotfiles="$HOME/.config-bf-dotfiles"
zshrc_bf_dotfiles="$HOME/.zshrc-bf-dotfiles"
scripts_bf_dotfiles="$HOME/.scripts-bf-dotfiles"

if [[ "$flag" == "-r" ]]; then
    read -p "Are you shure you want to remove the dotfiles and get your old config back? [y/N]: " continue
    continue=${continue:-n}

    if [[ "$continue" == "y" ]]; then
        if [[ -d "$config_bf_dotfiles" ]]; then
            echo "Resetting .config..."
            rsync -a --delete "$config_bf_dotfiles/" "$HOME/.config/"
            rm -rf "$config_bf_dotfiles"
        fi

        if [[ -f "$zshrc_bf_dotfiles" ]]; then
            echo "Resetting .zshrc..."
            rsync -a --delete "$zshrc_bf_dotfiles" "$HOME/.zshrc"
            rm "$zshrc_bf_dotfiles"
        fi

        if [[ -d "$scripts_bf_dotfiles" ]]; then
            scripts_bf_dotfiles="$HOME/.scripts-by-niemand8080"
            echo "Deleting $scripts_bf_dotfiles..."
            rm -rf "$scripts_bf_dotfiles"
        elif [[ -d "$HOME/.scripts" ]]; then
            echo "Deleting $HOME/.scripts..."
            rm -rf "$HOME/.scripts"
        fi

        echo "Make sure to delte the $dotfiles direcotry."
    else
        echo "Exiting"
    fi
else
    if [[ ! -d "$config_bf_dotfiles" ]]; then
        echo "Making copy of $HOME/.config to $config_bf_dotfiles"
        cp -r "$HOME/.config" "$config_bf_dotfiles"
    fi
    
    if [[ ! -f "$zshrc_bf_dotfiles" ]]; then
        echo "Making copy of $HOME/.zshrc to $zshrc_bf_dotfiles"
        cp "$HOME/.zshrc" "$zshrc_bf_dotfiles"
    fi

    if [[ -d "$HOME/.scripts" ]]; then
        scripts_bf_dotfiles="$HOME/.scripts-by-niemand8080"
    fi
    if [[ ! -d "$scripts_bf_dotfiles" ]]; then
        mkdir "$scripts_bf_dotfiles"
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

    export="export DOTFILES=$dotfiles"
    if [[ ! $(cat "$HOME/.zshrc" | grep "$export" >> /dev/null; echo $?) -eq 0 ]]; then
        echo "Adding line to .zshrc: $export"
        zshrc="$HOME/.zshrc"
        temp="$DOTFILES/temp-zshrc"
        { echo -e "$export\n"; cat "$zshrc"; } > "$temp" && mv "$temp" "$zshrc"
    fi
fi

