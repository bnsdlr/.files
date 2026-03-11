#!/usr/bin/env bash

GREEN="\x1b[32m"
NC="\x1b[0m"

is_test=false
load_all=false
non_existent=false
load_config=false
load_doom_d=false
load_zshrc=false

for arg in "$@"; do
	case "$arg" in
		-*t*|-test|--test) is_test=true ;;&
		-*ne*|--non-existent) non_existent=true ;;&
		-*a*|-all|--all) load_all=true ;;&
		-*c*) load_config=true ;;&
		-*d*) load_doom_d=true ;;&
		-*z*) load_zshrc=true ;;&
	esac
done

dotfiles=$DOTFILES

if [[ "$dotfiles" == "" ]]; then
	dotfiles=$(realpath "$0" | sed 's|\(.*\)/.*|\1|')
fi

src_config_dir=$HOME/.config
dst_config_dir=$dotfiles/config
src_doom_d_dir=$HOME/.doom.d
dst_doom_d_dir=$dotfiles/doom.d
src_zshrc_file=$HOME/.zshrc
dst_zshrc_file=$dotfiles/config/zsh/zshrc

echo ".files at $dotfiles"

if $is_test; then
	echo "is test"
fi

if $non_existent && ($load_all || $load_config); then
	if $is_test; then
		echo "would load config that does not exist in the dotfiles from $src_config_dir:"
	fi

	for entry in "$src_config_dir"/*; do
		bname=$(basename "$entry")

		if [[ -f "$entry" ]] && [[ -f "$dst_config_dir" ]]; then
			printf "${GREEN}cp $entry $dst_config_dir $NC\n"
			if ! $is_test; then
				cp "$entry" "$dst_config_dir/$bname"
			fi
		else
			printf "${GREEN}rsync -ia --delete \"$entry\" \"$dst_config_dir\"$NC\n"
			if ! $is_test; then
				rsync -ia --delete "$entry" "$dst_config_dir"
			fi
		fi
	done
fi

if ! $non_existent && ($load_all || $load_config); then
	if $is_test; then
		echo "would update $dst_config_dir with matching config files in $src_config_dir:"
	fi

	for entry in "$dst_config_dir"/*; do
		bname=$(basename "$entry")
		dname=$(dirname "$entry")
		src="$src_config_dir/$bname"

		if [[ -d "$entry" ]] && [[ -d "$src" ]]; then
			printf "${GREEN}rsync -ia --delete \"$src\" \"$dname\"$NC\n"
			if ! $is_test; then
				rsync -ia --delete "$src" "$dname"
			fi
		elif [[ -f "$entry" ]] && [[ -f "$src" ]]; then
			printf "${GREEN}cp $src $entry $NC\n"
			if ! $is_test; then
				cp "$src" "$entry"
			fi
		fi
	done
fi

if $load_all || $load_zshrc; then
	if $is_test; then
		echo "would update $dst_zshrc_file with $src_zshrc_file:"
	fi

	printf "${GREEN}cp $src_zshrc_file $dst_zshrc_file $NC\n"

	if ! $is_test; then
		cp "$src_zshrc_file" "$dst_zshrc_file"
	fi
fi

if $load_all || $load_doom_d; then
	if $is_test; then
		echo "would update $dst_doom_d_dir with $src_doom_d_dir:"
	fi

	printf "${GREEN}rsync -ia --delete \"$src_doom_d_dir\" \"$dst_doom_d_dir\"$NC\n"

	if ! $is_test; then
		rsync -ia --delete "$src_doom_d_dir" "$dst_doom_d_dir"
	fi
fi
