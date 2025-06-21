#!/bin/bash

add_line_to_zshrc_if_not_exists() {
    line="$1"
    if [[ ! $(cat "$HOME/.zshrc" | grep "$line" >> /dev/null; echo $?) -eq 0 ]]; then
        echo "Adding line to .zshrc: $line"
        zshrc="$HOME/.zshrc"
        temp="$DOTFILES/temp-zshrc"
        { echo -e "$line\n"; cat "$zshrc"; } > "$temp" && mv "$temp" "$zshrc"
    fi
}

arg=$1

dotfiles=$(realpath "$0" | sed 's|\(.*\)/.*|\1|')

# Change the hammerspoon config path
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

export DOTFILES="$dotfiles"

config_bf_dotfiles="$HOME/.config-bf-dotfiles"
zshrc_bf_dotfiles="$HOME/.zshrc-bf-dotfiles"
scripts_directory="$HOME/.scripts"

if [[ "$arg" == "-r" ]]; then
    read -p "Are you shure you want to remove the dotfiles and get your old config back? [y/N]: " continue
    continue=${continue:-n}

    if [[ "$continue" == "y" ]]; then
        if [[ -d "$config_bf_dotfiles" ]]; then
            echo "Resetting .config..."
            rsync -ia --delete "$config_bf_dotfiles/" "$HOME/.config/"
            rm -rf "$config_bf_dotfiles"
        fi

        if [[ -f "$zshrc_bf_dotfiles" ]]; then
            echo "Resetting .zshrc..."
            rsync -ia --delete "$zshrc_bf_dotfiles" "$HOME/.zshrc"
            rm "$zshrc_bf_dotfiles"
        fi

        if [[ -d "$HOME/.scripts-by-niemand8080" ]]; then
            scripts_directory="$HOME/.scripts-by-niemand8080"
            echo "Deleting $scripts_directory..."
            rm -rf "$scripts_directory"
        elif [[ -d "$scripts_directory" ]] && [[ -f "$scripts_directory/.managed-by-niemand8080" ]]; then
            echo "Deleting $scripts_directory..."
            rm -rf "$scripts_directory"
        else
            echo "No .scripts directory detected, please remove one your self if you find one..."
            echo "Paths of the .scripts directory may be: $HOME/.scripts; $HOME/.scripts-by-niemand8080" 
        fi

        echo "Make sure to delte the $dotfiles direcotry."
    else
        echo "Exiting"
    fi
else
    device="$DOTFILES_DEVICE"

    devices=("air" "imac" "win")
    devices_string=$(echo "${devices[@]}" | tr ' ' '/')

    device_prompt="Device [$devices_string]: "

    if [[ ! -z "$device" ]]; then
        device_prompt="Device [$devices_string] (default: $device): "
    fi

    read -p "$device_prompt" selected_device
    device=${selected_device:-$device}

    if [[ ! ${devices[@]} =~ $device ]]; then
        echo "Please enter a valid device name."
        exit 1
    fi

    if [[ ! -d "$config_bf_dotfiles" ]]; then
        echo "Making copy of $HOME/.config to $config_bf_dotfiles"
        cp -r "$HOME/.config" "$config_bf_dotfiles"
    fi
    
    if [[ ! -f "$zshrc_bf_dotfiles" ]]; then
        echo "Making copy of $HOME/.zshrc to $zshrc_bf_dotfiles"
        cp "$HOME/.zshrc" "$zshrc_bf_dotfiles"
    fi

    if [[ -d "$scripts_directory" ]] && [[ ! -f "$scripts_directory/.managed-by-niemand8080" ]]; then
        scripts_directory="$HOME/.scripts-by-niemand8080"
        echo "$HOME/.scripts direcotry exists changing path to $scripts_directory"
    fi
    if [[ ! -d "$scripts_directory" ]]; then
        mkdir "$scripts_directory"
    fi
    
    for file in $(find $dotfiles -name 'links.prop'); do
        while IFS="" read -r link || [ -n "$p" ]; do
            if [[ ! "$link" == "#"* ]] && [[ "$link" == *"="* ]]; then
                link=$(eval echo "$link")
                from=$(echo "$link" | cut -d "=" -f 1)
                to=$(echo "$link" | cut -d "=" -f 2)
                printf "\x1b[32mRsyncing $from to $to...\x1b[0m\n"
                rsync -ia --delete "$from" "$to"
            fi
        done <$file
    done

    dotfiles_export="export DOTFILES=\"$dotfiles\""
    add_line_to_zshrc_if_not_exists "$dotfiles_export"

    device_export="export DOTFILES_DEVICE=$device"
    add_line_to_zshrc_if_not_exists "$device_export"
fi

echo "For the changes to take effect you need to resource your shell."
