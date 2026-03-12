#!/usr/bin/env bash

GREEN="\x1b[32m"
NC="\x1b[0m"

is_test=false
load_all=false
non_existent=false
load_config=false
load_doom_d=false
load_zshrc=false
verbose=false

for arg in "$@"; do
	case "$arg" in
		-*) 
			for ((i=1;i<${#arg};i++)); do
				case "${arg:i:1}" in
					t) is_test=true ;;
					a) load_all=true ;;
					n) non_existent=true ;;
					c) load_config=true ;;
					d) load_doom_d=true ;;
					z) load_zshrc=true ;;
					v) verbose=true ;;
				esac
			done
			;;
	esac
done

if ! $load_all && ! $load_config && ! $load_zshrc && ! $load_doom_d; then
	echo "you probably should at least specify one of these flags: -a -c -d -z"
fi

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
		dst="$dst_config_dir/$bname"

		if [[ -f "$entry" ]] && [[ -f "$dst" ]]; then
			printf "${GREEN}cp $entry $dst $NC\n"
			if ! $is_test; then
				cp "$entry" "$dst"
			fi
		else
			printf "${GREEN}rsync -ria --delete \"$entry/\" \"$dst/\"$NC\n"
			if ! $is_test; then
				rsync -ria --delete "$entry/" "$dst/"
			elif $verbose; then
				rsync -ria --dry-run --delete "$entry/" "$dst/"
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
		src="$src_config_dir/$bname"

		if [[ -d "$entry" ]] && [[ -d "$src" ]]; then
				printf "${GREEN}rsync -ria --delete \"$src/\" \"$entry/\"$NC\n"
			if ! $is_test; then
				rsync -ria --delete "$src/" "$entry/"
			elif $verbose; then
				rsync -ria --dry-run --delete "$src/" "$entry/"
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

	printf "${GREEN}rsync -ria --delete \"$src_doom_d_dir/\" \"$dst_doom_d_dir\"$NC\n"

	if ! $is_test; then
		rsync -ria --delete "$src_doom_d_dir/" "$dst_doom_d_dir/"
	elif $verbose; then
		rsync -ria --dry-run --delete "$src_doom_d_dir/" "$dst_doom_d_dir/"
	fi
fi
