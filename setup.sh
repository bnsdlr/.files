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

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "only macos (darwin) is supported."
    exit 1
fi

# dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mru-spaces -bool true
# finder
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder FXRemoveOldTrashItems -bool true
# disable Ctrl + Space, because of tmux prefix
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "{ enabled = 0; value = { parameters = (32, 49, 262144); type = standard; }; }"

arg=$1

dotfiles=$(realpath "$0" | sed 's|\(.*\)/.*|\1|')

export DOTFILES="$dotfiles"

config_bf_dotfiles="$HOME/.config-bf-dotfiles"
zshrc_bf_dotfiles="$HOME/.zshrc-bf-dotfiles"

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

    for file in $(find $dotfiles -name 'map'); do
        while IFS="" read -r link || [ -n "$p" ]; do
            if [[ ! "$link" == "#"* ]] && [[ "$link" == *"="* ]]; then
                link=$(eval echo "$link")
                from=$(echo "$link" | cut -d "=" -f 1)
                to=$(echo "$link" | cut -d "=" -f 2)
                printf "\x1b[32mrsync -ia --delete \"$from\" \"$to\"...\x1b[0m\n"
                rsync -ia --delete "$from" "$to"
            fi
        done <$file
    done

    dotfiles_export="export DOTFILES=\"$dotfiles\""
    add_line_to_zshrc_if_not_exists "$dotfiles_export"
fi

echo "For the changes to take effect you need to resource your shell."
