#!/usr/bin/env bash

ZIG_DIR="$HOME/.zig"

case $1 in 
	l|ls|list)
		echo "Available versions:"
		for entry in "$ZIG_DIR"/*; do
			entry=${entry:${#ZIG_DIR}+1}
			if [[ "$entry" == "zig-"* ]]; then
				echo "$entry"
			fi
		done
		;;
	a|add)
		new_zig=$(readlink -f "$2")
		dst_version=$3

		if [[ "$dst_version" == "" ]]; then
			echo -e "Please specify a target version, e.g.:\nzv.sh add zig-0.16.0-dev.2821+3edaef9e0.tar.xz 0.16.0-dev"
			exit 1
		fi

		override=false

		if [[ -d "$ZIG_DIR/zig-$dst_version" ]]; then
			read -p "Zig version already exists, are you sure you want to continue? [y/N]: " wanttocontinue
			wanttocontinue=${wanttocontinue:-n}

			if [[ $wanttocontinue != "y" ]] && [[ $wanttocontinue != "Y" ]]; then
				exit 0
			fi
			override=true
		fi

		if [[ -f "$new_zig" ]]; then
			if [[ "$new_zig" == *".tar.xz" ]]; then
				if $override; then
					echo "rm -rf \"$ZIG_DIR/zig-$dst_version\""
					rm -rf "$ZIG_DIR/zig-$dst_version"
				fi

				echo "mkdir \"$ZIG_DIR/zig-$dst_version\""
				mkdir "$ZIG_DIR/zig-$dst_version"
				echo "tar xf \"$new_zig\" -C \"$ZIG_DIR/zig-$dst_version\" --strip-components=1"
				tar xf "$new_zig" -C "$ZIG_DIR/zig-$dst_version" --strip-components=1
				echo "IMPORTANT!"
				echo -e "\n\trun to use the added version: zv.sh use $dst_version"
				
				# cuz apple
				if [[ "$OSTYPE" == "darwin"* ]]; then
					echo "So you can run zig, without any issues:"
					echo "xattr -dr com.apple.quarantine \"$ZIG_DIR/zig-$dst_version\""
					xattr -dr com.apple.quarantine "$ZIG_DIR/zig-$dst_version"
				fi
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
			echo "ln -sfn \"$ZIG_DIR/zig-$target_version\" \"$ZIG_DIR/current\""
			ln -sfn "$ZIG_DIR/zig-$target_version" "$ZIG_DIR/current"
			echo "now using: $target_version"
		else
			echo "Could not find version: \"$target_version\""
		fi
		;;
	c|current)
		echo "$(readlink $ZIG_DIR/current)"
		;;
	delete)
		version=$2
		target="$ZIG_DIR/zig-$version"

		if [[ ! -d "$target" ]]; then
			exit 0
		fi

		read -p "Are you sure you want to delete \"$target\"? [y/N]: " wanttocontinue
		wanttocontinue=${wanttocontinue:-n}

		if [[ "$wanttocontinue" != "y" ]] && [[ "$wanttocontinue" != "Y" ]]; then
			exit 0
		fi

		echo "rm -rf \"$target\""
		rm -rf "$target"

		;;
	h|help)
		echo -e "Zig Version Manager"
		echo -e ""
		echo -e "\tl|ls|list"
		echo -e ""
		echo -e "\t\tlist all awailable zig versions."
		echo -e ""
		echo -e "\ta|add [zig.tar.xz] [as_version]"
		echo -e ""
		echo -e "\t\t[zig.tar.xz] - zig release (can be downloaded from: https://ziglang.org/download/)"
		echo -e "\t\t[as_version] - a sting representing the version of the zig source code, e.g.: 0.16.0-dev"
		echo -e ""
		echo -e "\tu|use [version]"
		echo -e ""
		echo -e "\t\t[version]    - the zig version you want to use, e.g.: 0.16.0-dev"
		echo -e ""
		echo -e "\tc|current"
		echo -e ""
		echo -e "\t\tprints the currently seclected zig version dir."
		echo -e ""
		echo -e "\tdelete [version]"
		echo -e ""
		echo -e "\t\t[version]    - deletes the specified zig version."
		echo -e ""
		;;
	*)
		echo "Unknown argument: $1"
		echo "run zv.sh help for more info"
		;;
esac

