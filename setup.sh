#!/usr/bin/env bash

GREEN="\x1b[32m"
NC="\x1b[0m"

remove=false
is_test=false

for arg in "$@"; do
	case "$arg" in
		-t|--t|-test|--test) is_test=true ;;
		-r|--r|-remove|--remove) remove=true ;;
		*) echo "unknown flag: $arg"; exit 1 ;;
	esac
done

add_line_to_file_if_not_exists() {
	file="$1"
    line="$2"
    if [[ -f "$file" ]] && ! grep -qF "$line" "$file"; then
        printf "Adding line to %s: \"%s\"\n" "$file" "$line"
		temp="$DOTFILES/tmp-$(basename "$file")"
		if ! $is_test; then
        	{ printf "%s\n\n" "$line"; cat "$file"; } > "$temp" && mv "$temp" "$file"
		fi
    fi
}

update_directory() {
	from="$1"
	to="$2"

	only_if_not_exists=$3

	for dir in $(find "$from" -depth -maxdepth 1 -mindepth 1); do
		to_dir="$to"

		if [[ $only_if_not_exists -eq 1 ]]; then
			if [[ ! -d "$to_dir" ]]; then
				continue
			fi
		fi

		printf "${GREEN}rsync -ia --delete \"$dir\" \"$to_dir\"$NC\n"
		if ! $is_test; then
			if [[ ! -d "$to_dir" ]]; then
				mkdir "$to_dir"
			fi
			rsync -ia --delete "$dir" "$to_dir"
		fi
	done
}

if ! $is_test; then
	if [[ "$OSTYPE" == "darwin"* ]]; then
		# dock
		defaults write com.apple.dock autohide -bool true
		defaults write com.apple.dock mru-spaces -bool true
		# finder
		defaults write com.apple.finder AppleShowAllExtensions -bool true
		defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
		defaults write com.apple.finder FXRemoveOldTrashItems -bool true
		# disable Ctrl + Space, because of tmux prefix
		defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "{ enabled = 0; value = { parameters = (32, 49, 262144); type = standard; }; }"
	fi
fi

dotfiles=$(realpath "$0" | sed 's|\(.*\)/.*|\1|')

export DOTFILES="$dotfiles"

config_bf_dotfiles="$HOME/.config-bf-dotfiles"
zshrc_bf_dotfiles="$HOME/.zshrc-bf-dotfiles"
zshenv_bf_dotfiles="$HOME/.zshenv-bf-dotfiles"
doomd_bf_dotfiles="$HOME/.doom.d-bf-dotfiles"

if $remove; then
    read -p "Are you sure you want to remove the dotfiles and hopefully get your old config back? [y/N]: " continue
    continue=${continue:-n}

    if [[ "$continue" == "y" ]]; then
        if [[ -d "$config_bf_dotfiles" ]]; then
            echo "Resetting .config..."
            update_directory "$config_bf_dotfiles" "$HOME/.config"
			if ! $is_test; then
            	rm -rf "$config_bf_dotfiles"
			fi 
        fi

        if [[ -f "$zshrc_bf_dotfiles" ]]; then
            echo "Resetting .zshrc..."
			if ! $is_test; then
				cp "$zshrc_bf_dotfiles" "$HOME/.zshrc"
				rm "$zshrc_bf_dotfiles"
			fi
        fi

        if [[ -f "$zshenv_bf_dotfiles" ]]; then
            echo "Resetting .zshenv..."
			if ! $is_test; then
				cp "$zshenv_bf_dotfiles" "$HOME/.zshenv"
				rm "$zshenv_bf_dotfiles"
			fi
        fi

        if [[ -d "$doomd_bf_dotfiles" ]]; then
            echo "Resetting .doom.d..."
            update_directory "$doomd_bf_dotfiles" "$HOME/.doom.d"
			if ! $is_test; then
            	rm -rf "$doomd_bf_dotfiles"
			fi
        fi

        echo "Make sure to delete the $dotfiles directory."
    else
        echo "Exiting"
    fi
else
    if [[ ! -d "$config_bf_dotfiles" ]]; then
        echo "Making copy of $HOME/.config to $config_bf_dotfiles"
        update_directory "$HOME/.config" "$config_bf_dotfiles" 1
    fi

    if [[ ! -f "$zshrc_bf_dotfiles" ]]; then
        echo "Making copy of $HOME/.zshrc to $zshrc_bf_dotfiles"
		if ! $is_test; then
        	cp "$HOME/.zshrc" "$zshrc_bf_dotfiles"
		fi
    fi

    if [[ ! -f "$zshenv_bf_dotfiles" ]]; then
        echo "Making copy of $HOME/.zshenv to $zshenv_bf_dotfiles"
		if ! $is_test; then
        	cp "$HOME/.zshenv" "$zshenv_bf_dotfiles"
		fi
    fi

    if [[ ! -d "$doomd_bf_dotfiles" ]]; then
        echo "Making copy of $HOME/.doom.d to $doomd_bf_dotfiles"
        update_directory "$HOME/.doom.d" "$config_bf_dotfiles" 1
    fi

    for file in $(find $dotfiles -name 'map'); do
        while IFS="" read -r link || [ -n "$p" ]; do
			if [[ "$link" == "macos "* ]]; then
				link=${link:6}
				if [[ "$OSTYPE" != "darwin"* ]]; then
					continue;
				fi
			fi
            if [[ ! "$link" == "#"* ]] && [[ "$link" == *"="* ]]; then
                link=$(eval echo "$link")
				from=$(echo "$link" | cut -d "=" -f 1)
				to=$(echo "$link" | cut -d "=" -f 2)
				update_directory "$from" "$to"
			else
				if [[ "$link" == "cp "* ]]; then
                	link=$(eval echo "$link")
					from_to=${link:3}
					printf "${GREEN}cp $from_to$NC\n"
					if ! $is_test; then
						eval "cp $from_to"
					fi
				fi
			fi
        done <$file
    done

    add_line_to_file_if_not_exists "$HOME/.zshenv" "export DOTFILES=\"$dotfiles\""
fi

echo "For the changes to take effect you need to source your shell."
