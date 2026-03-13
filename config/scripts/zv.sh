#!/usr/bin/env bash

ZIG_DIR="$HOME/.zig"

case $1 in 
	l|ls|list)
		echo "Available versions:"
		for entry in "$ZIG_DIR"/*; do
			if [[ "$entry" != *"current" ]] && [[ -d "$entry" ]]; then
				echo "${entry:${#ZIG_DIR}+5}"
			fi
		done
	;;
	a|add)
		new_zig=$2
		dst_version=$3

		if [[ "$dst_version" == "" ]]; then
			echo -e "Please specify a target version, e.g.:\nzv.sh add zig-0.16.0-dev.2821+3edaef9e0.tar.xz 0.16.0-dev"
			exit 1
		fi

		if [[ -f "$new_zig" ]]; then
			if [[ "$new_zig" == *".tar.xz" ]]; then
				echo "tar xf \"$new_zig\" \"$ZIG_DIR/zig-$dst_version\""
				# tar xf "$new_zig" "$ZIG_DIR/zig-$dst_version"
				echo "run to use the added version: zv.sh use $dst_version"
			else
				echo "Please provide a .tar.xz file..."
			fi
		else
			echo "Cannot find $new_zig"
		fi
	;;
	u|use)
		target_version=$2
		if [[ "$target_version" != "" ]] && [[ -d "$ZIG_DIR/zig-$target_version" ]]; then
			echo "ln -s \"$ZIG_DIR/zig-$target_version\" \"$ZIG_DIR/current\""
			ln -s "$ZIG_DIR/zig-$target_version" "$ZIG_DIR/current"
			echo "Changed zig version to: $target_version"
		else
			echo "Could not find version: \"$target_version\""
		fi
	;;
	*)
		echo "Unknown argument: $1"
	;;
esac

